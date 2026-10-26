import 'package:go_router/go_router.dart';
import 'package:pump_gym/screens/admin_access_screen.dart';
import 'package:pump_gym/screens/admin_screens/admin_analytics_screen.dart';
import 'package:pump_gym/screens/admin_screens/admin_athletes_screen.dart';
import 'package:pump_gym/screens/admin_screens/admin_groups_screen.dart';
import 'package:pump_gym/screens/admin_screens/admin_plan_builder_screen.dart';
import 'package:pump_gym/screens/admin_screens/admin_walk_in_screen.dart';
import 'package:pump_gym/screens/admin_screens/admin_walk_in_history_screen.dart';
import 'package:pump_gym/screens/auth_screen.dart';
import 'package:pump_gym/screens/athlete_screens/history_screen.dart';

import 'package:pump_gym/screens/athlete_screens/home_screen.dart';
import 'package:pump_gym/screens/athlete_screens/leaderboard_screen.dart';
import 'package:pump_gym/screens/athlete_screens/machines_screen.dart';
import 'package:pump_gym/screens/athlete_screens/profile_screen.dart';
import 'package:pump_gym/screens/athlete_screens/schedule_screen.dart';
import 'package:pump_gym/screens/athlete_screens/session_screen.dart';
import 'package:pump_gym/screens/sign_up_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const auth = '/auth';
  static const adminAccess = '/admin-access';
  static const signUp = '/signup';

  static const lobby = '/lobby';
  static const plans = '/plans';
  static const catalog = '/catalog';
  static const session = '/session';
  static const sessionComplete = '/session/complete';
  static const community = '/community';
  static const history = '/history';
  static const profile = '/profile';
  static const coach = '/coach';
  static const settings = '/settings';

  static const dashboard = '/dashboard';
  static const protocols = '/protocols';
  static const athletes = '/athletes';
  static const groups = '/groups';
  static const plansConfig = '/plans-config';
  static const team = '/team';
  static const walkIn = '/walk-in';
  static const walkInGymQr = '/walk-in/gym-qr';
  static const walkInScan = '/walk-in/scan';
  static const walkInHistory = '/walk-in/history';
  static const lookup = '/lookup';
}

/// Canonical enums matching backend spec §12.1.
enum UserRole { user, admin }

enum VisitSource { self, admin, walkin }

enum ProtocolIntensity { push, pull, legs, upper, rest }

enum MembershipPlanType { unlimited, sessionPack }

enum SubscriptionStatus { active, expired, cancelled }

enum AssignmentStatus { active, completed, abandoned }

enum Lang { en, ar }

enum PumpRole { none, user, admin }

final router = GoRouter(
  initialLocation: AppRoutes.auth,
  routes: [
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminAccess,
      builder: (context, state) => const AdminAccessScreen(),
    ),
    GoRoute(
      path: AppRoutes.lobby,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.plans,
      builder: (context, state) => const ScheduleScreen(),
    ),
    GoRoute(
      path: AppRoutes.catalog,
      builder: (context, state) => const MachinesScreen(),
    ),
    GoRoute(
      path: AppRoutes.session,
      builder: (context, state) => const SessionScreen(),
    ),
    GoRoute(
      path: AppRoutes.community,
      builder: (context, state) => const LeaderboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const AdminAnalyticsScreen(),
    ),
    GoRoute(
      path: AppRoutes.protocols,
      builder: (context, state) => const AdminPlanBuilderScreen(),
    ),
    GoRoute(
      path: AppRoutes.athletes,
      builder: (context, state) => const AdminAthletesScreen(),
    ),
    GoRoute(
      path: AppRoutes.groups,
      builder: (context, state) => const AdminGroupsScreen(),
    ),
    GoRoute(
      path: AppRoutes.walkIn,
      builder: (context, state) => const AdminWalkInScreen(),
    ),
    GoRoute(
      path: AppRoutes.walkInHistory,
      builder: (context, state) => const AdminWalkInHistoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),
  ],
);
