import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:credit_debit/constants.dart';
import 'package:credit_debit/models/customers.dart';
import 'package:credit_debit/screens/customer_screen.dart';
import 'package:credit_debit/components/dashboard_screen/add_customer.dart';
import 'package:credit_debit/components/dashboard_screen/customer_state.dart';

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
  @override
  void initState() {
    super.initState();
    Provider.of<CustomerData>(context, listen: false).refreshCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerData>(
      builder: (context, customerData, child) {
        return ListView.builder(
          itemCount: customerData.customers.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (builder, index) {
            final customer = customerData.customers[index];
            // return FutureBuilder<List<Map<String, Object?>>>(
            //   future: Transactions.getTransactionSums(customer['id']),
            //   builder: (context, snapshot) {
            //     final customerAmount = snapshot.data;
            // double totalPaid =
            //     (customerAmount?[0]['total_paid'] as double?) ?? 0.0;
            // double totalReceived =
            //     (customerAmount?[0]['total_received'] as double?) ?? 0.0;
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
                                  widget: widget, customer: customer),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        );
                      },
                    ),
                    Text(
                      (2 - 3).toString(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
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
    required this.customer,
  });

  final Map<String, dynamic> customer;
  final ShowCustomers widget;

  @override
  Widget build(BuildContext context) {
    final customerData = Provider.of<CustomerData>(context, listen: false);

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
              context: widget.parentContext,
              builder: (builder) => Container(
                padding: EdgeInsets.only(
                    bottom:
                        MediaQuery.of(widget.parentContext).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: AddCustomer(customer: customer),
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
            await Customers.deleteItem(customer['id']);
            customerData.refreshCustomers();
            if (!context.mounted) return; // ver important
            context.pop();
          },
        ),
      ],
    );
  }
}
