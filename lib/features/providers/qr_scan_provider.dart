import 'package:flutter_riverpod/flutter_riverpod.dart';

final qrModalProvider =
    NotifierProvider<QrModalNotifier, QrModalState>(QrModalNotifier.new);

class QrModalState {
  final bool scanning;
  final bool processing;

  const QrModalState({this.scanning = true, this.processing = false});

  QrModalState copyWith({bool? scanning, bool? processing}) => QrModalState(
        scanning: scanning ?? this.scanning,
        processing: processing ?? this.processing,
      );
}

class QrModalNotifier extends Notifier<QrModalState> {
  @override
  QrModalState build() => const QrModalState();

  void switchTab(bool scanning) =>
      state = QrModalState(scanning: scanning, processing: false);

  void setProcessing(bool value) => state = state.copyWith(processing: value);
}
