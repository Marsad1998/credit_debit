import 'package:credit_debit/views/auth_screen.dart';
import 'package:credit_debit/views/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:credit_debit/views/pdf_generator.dart';
import 'package:credit_debit/views/add_transaction.dart';
import 'package:credit_debit/views/customer_screen.dart';
import 'package:credit_debit/views/dashboard_screen.dart';

class MyRoutes {
  static GoRouter routes = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: AuthScreen.id,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: DashboardScreen.id,
        builder: (context, state) =>
            const DashboardScreen(title: 'Smart Records'),
      ),
      GoRoute(
        path: '/settings',
        name: Settings.id,
        builder: (context, state) => const Settings(),
      ),
      GoRoute(
        path: '/show_transactions',
        name: 'show_transactions',
        builder: (context, state) => const PdfGenerator(),
      ),
      GoRoute(
        path: '/show_customer_transaction',
        name: CustomerScreen.id,
        builder: (context, state) =>
            CustomerScreen(customer: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: '/add_transactions',
        name: AddTransaction.id,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return AddTransaction(
            customer: args['customer'],
            transaction: args['transaction'],
            type: args['type'],
          );
        },
      ),
    ],
  );
}
