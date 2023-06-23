import 'package:go_router/go_router.dart';
import 'package:starter/screens/initial_screen.dart';

import '../screens/home_screen.dart';
import '../screens/static_screens/settings_screen.dart';
import '../screens/user/login_screen.dart';
import '../screens/user/news_screen.dart';
import '../screens/user/profile_screen.dart';
import '../screens/user/register_screen.dart';
import '../screens/user/ticket_id.dart';
import '../screens/user/ticket_new.dart';
import '../screens/user/tickets.dart';

final routes = GoRouter(
  initialLocation: '/',
  routes: [
    // Loader Screen

    GoRoute(
      path: '/',
      builder: (context, state) => InitialScreen(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    // User Screens
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/tickets',
      builder: (context, state) => Tickets(),
    ),
    GoRoute(
      path: '/ticket_new',
      builder: (context, state) => TicketNew(),
    ),
    GoRoute(
      path: '/ticket_id/:id',
      builder: (context, state) => TicketId(id: (state.pathParameters['id']!)),
    ),
    // Static Screen
    GoRoute(
      path: '/news',
      builder: (context, state) => NewsPage(),
    ),

    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
    ),
  ],
);
