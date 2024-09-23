import 'package:go_router/go_router.dart';
import 'package:credit_debit/screens/add_transaction.dart';
import 'package:credit_debit/screens/customer_screen.dart';
import 'package:credit_debit/screens/dashboard_screen.dart';

class MyRoutes {
  static GoRouter routes = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: DashboardScreen.id,
        builder: (context, state) =>
            const DashboardScreen(title: 'Credit Debit'),
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
