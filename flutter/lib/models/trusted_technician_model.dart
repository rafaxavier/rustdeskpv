import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hbb/models/platform_model.dart';

/// Modelo para gerenciar técnicos/máquinas remotas confiáveis
/// 
/// Permite ao usuário host autorizar uma máquina remota uma única vez
/// e depois ela conecta automaticamente sem diálogos de confirmação.
/// 
/// Dados armazenados:
/// - trusted_technicians_list: JSON array de peer_ids confiáveis
/// - trusted_tech_{peer_id}_name: Nome humano (opcional)
/// - trusted_tech_{peer_id}_timestamp: Data da autorização
class TrustedTechnicianModel {
  static const String kTrustedTechniciansListKey = 'trusted_technicians_list';
  static const String kTrustedTechNamePrefix = 'trusted_tech_';
  static const String kTrustedTechTimestampSuffix = '_timestamp';

  // Observable para UI reagir a mudanças
  final trustedPeerIds = RxList<String>([]);
  final trustedMap = RxMap<String, Map<String, String>>({});

  /// Carrega a lista de técnicos confiáveis
  void loadTrustedTechnicians() {
    try {
      final stored = bind.mainGetLocalOption(key: kTrustedTechniciansListKey);
      if (stored.isEmpty) {
        trustedPeerIds.clear();
        trustedMap.clear();
        return;
      }

      final decoded = jsonDecode(stored) as List<dynamic>;
      final peerIds = decoded.cast<String>().toList();
      trustedPeerIds.assignAll(peerIds);

      // Carregar dados adicionais para cada técnico
      for (String peerId in peerIds) {
        _loadTechnicianData(peerId);
      }
    } catch (e) {
      debugPrint('Erro ao carregar técnicos confiáveis: $e');
      trustedPeerIds.clear();
      trustedMap.clear();
    }
  }

  /// Carrega dados específicos de um técnico
  void _loadTechnicianData(String peerId) {
    try {
      final name = bind.mainGetLocalOption(
        key: '${kTrustedTechNamePrefix}${peerId}_name',
      );
      final timestamp = bind.mainGetLocalOption(
        key: '${kTrustedTechNamePrefix}$peerId${kTrustedTechTimestampSuffix}',
      );

      trustedMap[peerId] = {
        'name': name,
        'timestamp': timestamp,
      };
    } catch (e) {
      debugPrint('Erro ao carregar dados do técnico $peerId: $e');
    }
  }

  /// Adiciona um técnico à lista de confiáveis
  Future<void> addTrustedTechnician({
    required String peerId,
    required String technicianName,
  }) async {
    if (peerId.isEmpty) return;

    if (!trustedPeerIds.contains(peerId)) {
      trustedPeerIds.add(peerId);
      _saveTrustedList();
    }

    // Salvar nome e timestamp
    await bind.mainSetLocalOption(
      key: '${kTrustedTechNamePrefix}${peerId}_name',
      value: technicianName,
    );
    await bind.mainSetLocalOption(
      key: '${kTrustedTechNamePrefix}$peerId${kTrustedTechTimestampSuffix}',
      value: DateTime.now().toIso8601String(),
    );

    _loadTechnicianData(peerId);
  }

  /// Remove um técnico da lista de confiáveis
  Future<void> removeTrustedTechnician(String peerId) async {
    if (trustedPeerIds.remove(peerId)) {
      _saveTrustedList();
    }

    // Limpar dados associados
    await bind.mainSetLocalOption(
      key: '${kTrustedTechNamePrefix}${peerId}_name',
      value: '',
    );
    await bind.mainSetLocalOption(
      key: '${kTrustedTechNamePrefix}$peerId${kTrustedTechTimestampSuffix}',
      value: '',
    );

    trustedMap.remove(peerId);
  }

  /// Verifica se um técnico é confiável
  bool isTrustedTechnician(String peerId) {
    return trustedPeerIds.contains(peerId);
  }

  /// Obtém o nome do técnico confiável
  String getTechnicianName(String peerId) {
    return trustedMap[peerId]?['name'] ?? '';
  }

  /// Obtém a data de autorização
  String getTechnicianTimestamp(String peerId) {
    return trustedMap[peerId]?['timestamp'] ?? '';
  }

  /// Get all trusted technicians com seus dados
  List<Map<String, String>> getAllTrustedTechnicians() {
    return trustedPeerIds.map((peerId) {
      return {
        'peer_id': peerId,
        'name': getTechnicianName(peerId),
        'timestamp': getTechnicianTimestamp(peerId),
      };
    }).toList();
  }

  /// Salva a lista de técnicos confiáveis
  void _saveTrustedList() {
    try {
      final encoded = jsonEncode(trustedPeerIds.toList());
      bind.mainSetLocalOption(
        key: kTrustedTechniciansListKey,
        value: encoded,
      );
    } catch (e) {
      debugPrint('Erro ao salvar lista de técnicos: $e');
    }
  }

  /// Limpa todos os técnicos confiáveis
  Future<void> clearAllTrustedTechnicians() async {
    for (String peerId in trustedPeerIds.toList()) {
      await removeTrustedTechnician(peerId);
    }
  }
}
