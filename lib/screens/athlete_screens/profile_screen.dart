import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:pump_gym/widgets/session_running.dart';
import 'package:pump_gym/features/providers/profile_screen_provider.dart';
import 'package:pump_gym/dummy_data/athlete_profile_dummy_data.dart';
import 'package:pump_gym/wide_layout.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../theme/pump_colors.dart';
import '../../../theme/pump_theme.dart';
import '../../../theme/theme_options.dart';
import '../../widgets/top_bar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final nameController =
      TextEditingController(text: athleteProfileDummyData.name);
  final usernameController =
      TextEditingController(text: athleteProfileDummyData.username);
  final rankController =
      TextEditingController(text: athleteProfileDummyData.rank);
  final bioController =
      TextEditingController(text: athleteProfileDummyData.bio);
  final weightController =
      TextEditingController(text: athleteProfileDummyData.weightKg);
  final heightController =
      TextEditingController(text: athleteProfileDummyData.heightCm);
  final calorieController =
      TextEditingController(text: athleteProfileDummyData.dailyCalories);
  final waterController =
      TextEditingController(text: athleteProfileDummyData.dailyWaterLiters);

  int selectedTheme = 0;

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(pumpPaletteProvider);
    final selectedAvatar = ref.watch(profileAvatarProvider);

    return AthleteShell(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              if (!showsDesktopTopNav(context))
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTopBarDelegate(
                    child: Container(
                      color: p.background,
                      padding: const EdgeInsets.symmetric(
                        horizontal: PumpSpacing.lg,
                        vertical: PumpSpacing.md,
                      ),
                      child: TopBar(
                        canPop: context.canPop(),
                        onBack: () => context.pop(),
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PumpSpacing.lg,
                  vertical: PumpSpacing.md,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(height: PumpSpacing.sm),
                      PumpColumns(
                        main: [
                          _ProfileHeaderCard(
                            selectedAvatar: selectedAvatar,
                            name: nameController.text,
                            username: usernameController.text,
                            rank: rankController.text,
                            onAvatarSelect: (i) => ref
                                .read(profileAvatarProvider.notifier)
                                .select(i),
                          ),
                          _QrCodeCard(username: usernameController.text),
                        ],
                        side: [
                          _AthleteInfoCard(
                            nameController: nameController,
                            usernameController: usernameController,
                            rankController: rankController,
                            bioController: bioController,
                            weightController: weightController,
                            heightController: heightController,
                            calorieController: calorieController,
                            waterController: waterController,
                          ),
                          const _ThemesCard(),
                        ],
                      ),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const PumpFloatingBar(child: SessionRunningBar()),
        ],
      ),
    );
  }
}

class _StickyTopBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTopBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 64.0; // CHANGED from 72.0 to match child height

  @override
  double get minExtent => 64.0; // CHANGED from 72.0 to match child height

  @override
  bool shouldRebuild(covariant _StickyTopBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}

// ---------------------------------------------------------------------------
// Profile header card
// ---------------------------------------------------------------------------
class _ProfileHeaderCard extends ConsumerWidget {
  final int selectedAvatar;
  final String name;
  final String username;
  final String rank;
  final ValueChanged<int> onAvatarSelect;
  const _ProfileHeaderCard({
    required this.selectedAvatar,
    required this.name,
    required this.username,
    required this.rank,
    required this.onAvatarSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: p.primary, width: 2),
            ),
            child: CircleAvatar(
              backgroundColor: p.secondary,
              child: Icon(Icons.person,
                  size: 44, color: p.foreground.withValues(alpha: 0.7)),
            ),
          ),
          const SizedBox(height: 14),
          Text(name.toUpperCase(),
              style: PumpTextStyles.displayXl(p.foreground)),
          const SizedBox(height: 4),
          Text('@$username', style: PumpTextStyles.bodySm(p.mutedForeground)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: p.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(PumpRadius.pill),
            ),
            child: Text(
                'RANK: {rank}'.tr(namedArgs: {
                  'rank': rank.tr().toUpperCase(),
                }),
                style: PumpTextStyles.label(p.primary)),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 3; i++) ...[
                GestureDetector(
                  onTap: () => onAvatarSelect(i),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedAvatar == i
                            ? p.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      backgroundColor: p.secondary,
                      child: Icon(Icons.person,
                          size: 22, color: p.mutedForeground),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              const _PillButton(icon: Icons.link, label: 'Use URL'),
            ],
          ),
          const SizedBox(height: 12),
          const _PillButton(icon: Icons.upload, label: 'Upload'),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: p.secondary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text('Paste direct image URL...'.tr(),
                style: PumpTextStyles.bodySm(p.mutedForeground)),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends ConsumerWidget {
  final IconData icon;
  final String label;
  const _PillButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(PumpRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: p.foreground.withValues(alpha: 0.7)),
          const SizedBox(width: 6),
          Text(label.tr(),
              style:
                  PumpTextStyles.bodySm(p.foreground).copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QR code card
// ---------------------------------------------------------------------------
class _QrCodeCard extends ConsumerWidget {
  final String username;
  const _QrCodeCard({required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Column(
        children: [
          Text('YOUR SIGN-IN QR CODE'.tr(),
              style: PumpTextStyles.label(p.mutedForeground)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                QrImageView(
                  data: 'pump://checkin/@$username',
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 8),
                Text('@$username',
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Show this to the front-desk admin so they can scan it and check you in.'
                .tr(),
            textAlign: TextAlign.center,
            style: PumpTextStyles.bodySm(p.mutedForeground),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Athlete info card
// ---------------------------------------------------------------------------
class _AthleteInfoCard extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController rankController;
  final TextEditingController bioController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController calorieController;
  final TextEditingController waterController;

  const _AthleteInfoCard({
    required this.nameController,
    required this.usernameController,
    required this.rankController,
    required this.bioController,
    required this.weightController,
    required this.heightController,
    required this.calorieController,
    required this.waterController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ATHLETE INFORMATION'.tr(),
              style: PumpTextStyles.bodyMd(p.foreground)
                  .copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: PumpSpacing.lg),
          _LabeledField(label: 'Full Name', controller: nameController),
          const SizedBox(height: PumpSpacing.md),
          _LabeledField(
              label: 'Username', controller: usernameController, prefix: '@'),
          const SizedBox(height: PumpSpacing.md),
          _LabeledField(label: 'Rank Title', controller: rankController),
          const SizedBox(height: PumpSpacing.md),
          _LabeledField(label: 'Bio', controller: bioController),
          const SizedBox(height: PumpSpacing.md),
          Row(
            children: [
              Expanded(
                  child: _LabeledField(
                      label: 'Target Weight (kg)',
                      controller: weightController)),
              const SizedBox(width: PumpSpacing.sm),
              Expanded(
                  child: _LabeledField(
                      label: 'Height (cm)', controller: heightController)),
            ],
          ),
          const SizedBox(height: PumpSpacing.md),
          Row(
            children: [
              Expanded(
                  child: _LabeledField(
                      label: 'Daily Calorie Goal',
                      controller: calorieController)),
              const SizedBox(width: PumpSpacing.sm),
              Expanded(
                  child: _LabeledField(
                      label: 'Water Goal (L)', controller: waterController)),
            ],
          ),
          const SizedBox(height: PumpSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('SAVE PROFILE'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends ConsumerWidget {
  final String label;
  final TextEditingController controller;
  final String? prefix;
  const _LabeledField(
      {required this.label, required this.controller, this.prefix});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr().toUpperCase(),
            style: PumpTextStyles.label(p.mutedForeground)),
        const SizedBox(height: PumpSpacing.xs),
        TextField(
          controller: controller,
          style: PumpTextStyles.bodyMd(p.foreground),
          decoration: InputDecoration(
            prefixText: prefix,
            prefixStyle: PumpTextStyles.bodyMd(p.mutedForeground),
            filled: true,
            fillColor: p.secondary,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Themes card
// ---------------------------------------------------------------------------
class _ThemesCard extends ConsumerWidget {
  const _ThemesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeId = ref.watch(themeProvider);
    final p = ref.watch(pumpPaletteProvider);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EYE-COMFORT COLOR THEMES'.tr(),
            style: PumpTextStyles.bodyMd(p.foreground)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: PumpSpacing.md),
          for (final option in themeOptions) ...[
            _ThemeRow(
              option: option,
              isSelected: option.themeId == themeId,
              palette: p,
              onTap: () {
                ref.read(themeProvider.notifier).setTheme(option.themeId);
              },
            ),
            const SizedBox(height: PumpSpacing.sm),
          ],
          const SizedBox(height: 6),
          Text(
            'ALL THEMES ARE ZERO-STRAIN DARK PALETTES WITH FULL UI RE-TINT.'
                .tr(),
            style: PumpTextStyles.label(p.mutedForeground),
          ),
        ],
      ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  final ThemeOption option;
  final bool isSelected;
  final PumpPalette palette;
  final VoidCallback onTap;

  const _ThemeRow({
    required this.option,
    required this.isSelected,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: p.secondary,
          border: Border.all(
            color: isSelected ? p.primary : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(PumpRadius.pill),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: option.swatch,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            const SizedBox(width: PumpSpacing.sm),
            Expanded(
              child: Text(
                option.name.tr(),
                style: PumpTextStyles.bodyMd(p.foreground),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: p.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ACTIVE'.tr(),
                  style: TextStyle(
                    color: p.primaryForeground,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
