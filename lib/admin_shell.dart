import 'package:flutter/material.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/nav_icons.dart';


/// Admin version of [AthleteShell]: same responsive behavior, admin destinations
/// (Dashboard, Protocols, Athletes, Groups, Walk-in).
class AdminShell extends StatelessWidget {
  final Widget body;
  const AdminShell({super.key, required this.body});

  @override
  Widget build(BuildContext context) =>
      AthleteShell(navSet: adminNavSet, body: body);
}