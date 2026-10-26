import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/dummy_data/admin_walk_in_dummy_data.dart';

final adminWalkInRecordsProvider =
    NotifierProvider<AdminWalkInRecordsNotifier, List<AdminWalkInRecord>>(
  AdminWalkInRecordsNotifier.new,
);

class AdminWalkInRecordsNotifier extends Notifier<List<AdminWalkInRecord>> {
  @override
  List<AdminWalkInRecord> build() =>
      List.unmodifiable(adminWalkInRecordsDummyData(DateTime.now()));

  bool checkInMember({
    required String id,
    required String name,
    required String username,
  }) {
    if (state.any(
      (record) =>
          record.username == username &&
          !record.oneTimeVisitor &&
          record.checkedOutAt == null,
    )) {
      return false;
    }
    final now = DateTime.now();
    state = List.unmodifiable([
      AdminWalkInRecord(
        id: '$id-${now.microsecondsSinceEpoch}',
        name: name,
        username: username,
        checkedInAt: now,
        source: 'ADMIN SCAN',
        oneTimeVisitor: false,
      ),
      ...state,
    ]);
    return true;
  }

  void addVisitor(String name) {
    final now = DateTime.now();
    state = List.unmodifiable([
      AdminWalkInRecord(
        id: 'visitor-${now.microsecondsSinceEpoch}',
        name: name.trim(),
        username: '',
        checkedInAt: now,
        source: 'WALK-IN',
        oneTimeVisitor: true,
      ),
      ...state,
    ]);
  }

  void checkOut(String id) {
    final index = state.indexWhere((record) => record.id == id);
    if (index == -1 || state[index].checkedOutAt != null) return;
    final updated = [...state];
    updated[index] = updated[index].checkOut(DateTime.now());
    state = List.unmodifiable(updated);
  }
}
