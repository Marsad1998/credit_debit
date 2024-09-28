import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:credit_debit/utils/constants.dart';
import 'package:credit_debit/services/customer_services.dart';
import 'package:credit_debit/services/transaction_services.dart';
import 'package:credit_debit/views/customer_screen.dart';
import 'package:credit_debit/components/dashboard_screen/add_customer.dart';
import 'package:credit_debit/viewmodels/customer_state.dart';
import 'package:credit_debit/viewmodels/transaction_state.dart';

class ShowCustomers extends StatefulWidget {
  const ShowCustomers({
    super.key,
    required this.parentContext,
  });

  final BuildContext parentContext;

  @override
  State<ShowCustomers> createState() => _ShowCustomersState();
}

class _ShowCustomersState extends State<ShowCustomers> {
  // Map<int, double> customerBalances = {};

  @override
  void initState() {
    super.initState();
    Provider.of<CustomerState>(context, listen: false).refreshCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerState>(
      builder: (context, customerData, child) {
        return ListView.builder(
          itemCount: customerData.customers.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (builder, index) {
            final customer = customerData.customers[index];

            Provider.of<TransactionState>(context, listen: false)
                .refreshBalance(customer['id']);

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: ListTile(
                onTap: () {
                  context.pushNamed(
                    CustomerScreen.id,
                    extra: customer,
                  );
                },
                leading: CircleAvatar(
                  child: Text(
                    customer['name'][0].toUpperCase(),
                  ),
                ),
                title: Text(customer['name']),
                subtitle: Text(customer['phone']),
                tileColor: Colors.white,
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: const Icon(Icons.more_vert),
                      onTap: () {
                        showModalBottomSheet(
                          context: widget.parentContext,
                          builder: (builder) {
                            return Container(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(widget.parentContext)
                                    .viewInsets
                                    .bottom,
                              ),
                              child: CustomerActions(
                                  widget: widget, dbCustomer: customer),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        );
                      },
                    ),
                    Consumer<TransactionState>(
                      builder: (context, transData, child) {
                        return Text(
                          transData.totalBalanceF(customer['id']).toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CustomerActions extends StatelessWidget {
  const CustomerActions({
    super.key,
    required this.widget,
    required this.dbCustomer,
  });

  final Map<String, dynamic> dbCustomer;
  final ShowCustomers widget;

  @override
  Widget build(BuildContext context) {
    final customerData = Provider.of<CustomerState>(context, listen: false);

    return ListView(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text('Edit'),
          leading: const Icon(Icons.edit),
          tileColor: kScaffoldColor,
          onTap: () {
            Navigator.pop(context);

            showModalBottomSheet(
              isScrollControlled: true,
              context: widget.parentContext,
              builder: (builder) => Container(
                padding: EdgeInsets.only(
                    bottom:
                        MediaQuery.of(widget.parentContext).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: AddCustomer(dbCustomer: dbCustomer),
                ),
              ),
            );
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: const Text('Delete'),
          leading: const Icon(Icons.delete),
          tileColor: kScaffoldColor,
          onTap: () async {
            await CustomerService.deleteCustomer(dbCustomer['id']);
            await TransactionService.deleteCustomerTransaction(
                dbCustomer['id']);
            customerData.refreshCustomers();
            if (!context.mounted) return; // ver important
            Provider.of<TransactionState>(context, listen: false)
                .refreshBalance(null);
            context.pop();
          },
        ),
      ],
    );
  }
}
