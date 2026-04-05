import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/models/server_model.dart';
import 'package:flutter_hbb/models/trusted_technician_model.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

/// Widget para gerenciar técnicos/máquinas remotas confiáveis
/// 
/// Exibe uma lista de técnicos que foram autorizados para acesso automático
/// e permite remover técnicos da lista de confiáveis.
class TrustedTechniciansWidget extends StatefulWidget {
  final VoidCallback? onTechniciansChanged;

  const TrustedTechniciansWidget({
    Key? key,
    this.onTechniciansChanged,
  }) : super(key: key);

  @override
  State<TrustedTechniciansWidget> createState() =>
      _TrustedTechniciansWidgetState();
}

class _TrustedTechniciansWidgetState extends State<TrustedTechniciansWidget> {
  late TrustedTechnicianModel _model;

  @override
  void initState() {
    super.initState();
    try {
      _model = Provider.of<ServerModel>(context, listen: false)
          .trustedTechnicianModel;
    } catch (e) {
      debugPrint('Erro ao inicializar modelo de técnicos: $e');
      // Fallback para um novo modelo se necessário
      _model = TrustedTechnicianModel();
      _model.loadTrustedTechnicians();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('Trusted Technicians'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  translate('trusted_technicians_description'),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Obx(() {
            final technicians = _model.trustedPeerIds;

            if (technicians.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        translate('No trusted technicians yet'),
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        translate('Check the checkbox when accepting a connection to add to trusted list'),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: technicians.length,
              itemBuilder: (context, index) {
                final peerId = technicians[index];
                final name = _model.getTechnicianName(peerId);
                final timestamp = _model.getTechnicianTimestamp(peerId);

                return ListTile(
                  leading: Icon(
                    Icons.verified_user,
                    color: Colors.green,
                  ),
                  title: Text(
                    name.isNotEmpty ? name : peerId,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      if (name.isNotEmpty)
                        Text(
                          'ID: $peerId',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      if (timestamp.isNotEmpty)
                        Text(
                          'Added: ${_formatTimestamp(timestamp)}',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _showRemoveConfirmation(
                      context,
                      peerId,
                      name.isNotEmpty ? name : peerId,
                    ),
                  ),
                  dense: false,
                );
              },
            );
          }),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.delete_sweep_outlined),
                label: Text(translate('Clear All Trusted Technicians')),
                onPressed: _model.trustedPeerIds.isEmpty
                    ? null
                    : () => _showClearAllConfirmation(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.red[900],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveConfirmation(
    BuildContext context,
    String peerId,
    String name,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate('Remove Trusted Technician')),
        content: Text(
          translate('Are you sure you want to remove') +
              '\n$name\n' +
              translate('from trusted technicians?'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(translate('Cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _model.removeTrustedTechnician(peerId);
              widget.onTechniciansChanged?.call();
              if (mounted) {
                setState(() {});
              }
            },
            child: Text(
              translate('Remove'),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate('Clear All Trusted Technicians')),
        content: Text(
          translate('Are you sure you want to remove all trusted technicians?') +
              '\n' +
              translate('This action cannot be undone.'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(translate('Cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _model.clearAllTrustedTechnicians();
              widget.onTechniciansChanged?.call();
              if (mounted) {
                setState(() {});
              }
            },
            child: Text(
              translate('Clear All'),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
