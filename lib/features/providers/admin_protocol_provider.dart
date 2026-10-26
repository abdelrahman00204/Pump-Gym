import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/dummy_data/admin_protocol_dummy_data.dart';

final adminProtocolsProvider =
    NotifierProvider<AdminProtocolsNotifier, List<AdminProtocol>>(
  AdminProtocolsNotifier.new,
);

class AdminProtocolsNotifier extends Notifier<List<AdminProtocol>> {
  @override
  List<AdminProtocol> build() => List.unmodifiable(adminProtocolsDummyData);

  void save(AdminProtocol protocol) {
    final existingIndex = state.indexWhere((item) => item.id == protocol.id);
    final updated = [...state];
    if (existingIndex == -1) {
      updated.add(protocol);
    } else {
      updated[existingIndex] = protocol;
    }
    state = List.unmodifiable(updated);
  }

  void remove(String id) {
    state = List.unmodifiable(state.where((item) => item.id != id));
  }
}
