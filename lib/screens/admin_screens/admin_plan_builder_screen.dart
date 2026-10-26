import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/admin_shell.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/features/providers/admin_protocol_provider.dart';
import 'package:pump_gym/screens/admin_screens/admin_protocol_editor_screen.dart';
import 'package:pump_gym/widgets/admin_top_bar.dart';
import 'package:pump_gym/wide_layout.dart';

class AdminPlanBuilderScreen extends ConsumerWidget {
  const AdminPlanBuilderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocols = ref.watch(adminProtocolsProvider);
    return AdminShell(
      body: Column(
        children: [
          if (!showsDesktopTopNav(context)) const AdminTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ADMIN HQ CONSOLE'.tr(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // _Card(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const Text(
                  //         'WALK-IN PLAN (DROP-IN) — PRICE',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           letterSpacing: 1.5,
                  //         ),
                  //       ),
                  //       const SizedBox(height: 24),
                  //       const Text(
                  //         'DROP-IN FEE (\$)',
                  //         style: TextStyle(
                  //           fontSize: 11,
                  //           letterSpacing: 1.4,
                  //         ),
                  //       ),
                  //       const SizedBox(height: 10),
                  //       Row(
                  //         children: [
                  //           const Expanded(
                  //             child: TextField(
                  //               decoration: InputDecoration(
                  //                 hintText: adminWalkInFeeHintDummyData,
                  //               ),
                  //             ),
                  //           ),
                  //           const SizedBox(width: 12),
                  //           ElevatedButton(
                  //             onPressed: () {},
                  //             child: const Text('SAVE PRICE'),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '30-DAY PROTOCOLS'.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  showAdminProtocolEditor(context, ref),
                              icon: const Icon(Icons.add),
                              label: Text('NEW PROTOCOL'.tr()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        PumpCardGrid(
                          compact: 1,
                          medium: 1,
                          expanded: 3,
                          spacing: 7,
                          children: [
                            for (final protocol in protocols)
                              _ProtocolCard(
                                title: protocol.title,
                                details:
                                    '{category} · {difficulty} · {days} days · {gain}'
                                        .tr(namedArgs: {
                                  'category':
                                      protocol.category.tr().toUpperCase(),
                                  'difficulty':
                                      protocol.difficulty.tr().toUpperCase(),
                                  'days': '${protocol.durationDays}',
                                  'gain': protocol.expectedGain,
                                }).toUpperCase(),
                                price: '\$${protocol.price}',
                                onEdit: () => showAdminProtocolEditor(
                                  context,
                                  ref,
                                  protocol: protocol,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: child,
    );
  }
}

class _ProtocolCard extends StatelessWidget {
  final String title;
  final String details;
  final String price;
  final VoidCallback onEdit;

  const _ProtocolCard({
    required this.title,
    required this.details,
    required this.price,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  details,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11,
                    height: 1.5,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            tooltip: 'Edit protocol'.tr(),
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }
}
