import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pump_gym/theme/pump_colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:pump_gym/theme/theme_provider.dart';
import 'package:pump_gym/features/providers/qr_scan_provider.dart';

void showGymQrModal(
  BuildContext context, {
  required String userId,
  required String username,
  required bool isAdmin,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _GymQrModal(
      userId: userId,
      username: username,
      isAdmin: isAdmin,
    ),
  );
}

class _GymQrModal extends ConsumerStatefulWidget {
  final String userId;
  final String username;
  final bool isAdmin;

  const _GymQrModal({
    required this.userId,
    required this.username,
    required this.isAdmin,
  });

  @override
  ConsumerState<_GymQrModal> createState() => _GymQrModalState();
}

class _GymQrModalState extends ConsumerState<_GymQrModal> {
  late final MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _switchTab(bool scan) {
    if (ref.read(qrModalProvider).scanning == scan) return;
    ref.read(qrModalProvider.notifier).switchTab(scan);

    if (scan) {
      _scannerController.start();
    } else {
      _scannerController.stop();
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (ref.read(qrModalProvider).processing) return;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();

      if (value == null || value.isEmpty) continue;

      ref.read(qrModalProvider.notifier).setProcessing(true);
      _scannerController.stop();

      // TODO: Validate the scanned QR with the backend.
      // Do not treat an arbitrary QR code as a successful check-in.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'QR detected. Gym verification is not connected yet.'.tr(),
          ),
        ),
      );

      // Keep the scanner open so the user can try another QR.
      ref.read(qrModalProvider.notifier).setProcessing(false);
      _scannerController.start();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(pumpPaletteProvider);
    final qrState = ref.watch(qrModalProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: p.border),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'GYM SIGN-IN'.tr(),
                      style: TextStyle(
                        color: p.foreground,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: p.mutedForeground),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Tabs
              Row(
                children: [
                  Expanded(
                    child: _QrTab(
                      label: 'SCAN GYM QR'.tr(),
                      selected: qrState.scanning,
                      palette: p,
                      onTap: () => _switchTab(true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QrTab(
                      label: 'SHOW MY QR'.tr(),
                      selected: !qrState.scanning,
                      palette: p,
                      onTap: () => _switchTab(false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Show either the real scanner or the user's QR.
              if (qrState.scanning)
                _ScannerCard(
                  controller: _scannerController,
                  onDetect: _onDetect,
                )
              else
                _PersonalQrCard(
                  userId: widget.userId,
                  username: widget.username,
                  palette: p,
                ),

              const SizedBox(height: 20),

              Text(
                qrState.scanning
                    ? 'Point your camera at the gym QR code at the front desk.'
                        .tr()
                    : 'Show this to the front-desk admin so they can scan it and verify your check-in.'
                        .tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: p.mutedForeground,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 18),

              // Bottom action button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: qrState.scanning
                      ? () {
                          // The camera is already scanning.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Point the camera at the gym QR code.'.tr(),
                              ),
                            ),
                          );
                        }
                      : () => _switchTab(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: p.primary,
                    foregroundColor: p.primaryForeground,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.bolt, size: 21),
                  label: Text(
                    (qrState.scanning ? 'SCAN GYM QR' : 'BACK TO SCANNER').tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScannerCard extends StatelessWidget {
  final MobileScannerController controller;
  final void Function(BarcodeCapture) onDetect;

  const _ScannerCard({
    required this.controller,
    required this.onDetect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 260,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: MobileScanner(
          controller: controller,
          onDetect: onDetect,
        ),
      ),
    );
  }
}

class _PersonalQrCard extends StatelessWidget {
  final String userId;
  final String username;
  final PumpPalette palette;

  const _PersonalQrCard({
    required this.userId,
    required this.username,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: userId,
            version: QrVersions.auto,
            size: 200,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.black,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '@$username',
            style: const TextStyle(
              color: Color(0xFF555555),
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _QrTab extends StatelessWidget {
  final String label;
  final bool selected;
  final PumpPalette palette;
  final VoidCallback onTap;

  const _QrTab({
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? palette.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: selected ? palette.primary : palette.border,
            ),
          ),
          child: Text(
            label.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? palette.primaryForeground
                  : palette.mutedForeground,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
