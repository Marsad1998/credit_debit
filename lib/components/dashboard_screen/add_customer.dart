import 'package:credit_debit/models/customer.dart';
import 'package:credit_debit/viewmodels/customer_state.dart';
import 'package:credit_debit/utils/constants.dart';
import 'package:credit_debit/services/customer_services.dart';
import 'package:credit_debit/utils/notification.dart';
import 'package:credit_debit/widgets/trans_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCustomer extends StatelessWidget {
  const AddCustomer({
    super.key,
    this.dbCustomer,
  });

  final Map<String, dynamic>? dbCustomer;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(
      text: dbCustomer != null ? dbCustomer!['name'] : '',
    );
    TextEditingController phoneController = TextEditingController(
      text: dbCustomer != null ? dbCustomer!['phone'] : '',
    );
    final formKey = GlobalKey<FormState>();

    final customerData = Provider.of<CustomerState>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const Text(
              'Add Customers',
              style: kDefaultHead,
            ),
            const SizedBox(height: 15),
            TransField(
              autofocus: true,
              label: 'Customer Name',
              icon: const Icon(Icons.person),
              controller: nameController,
              callBackFunction: (value) => value == null || value.isEmpty
                  ? 'Customer name is Required'
                  : null,
            ),
            const SizedBox(height: 15),
            TransField(
              label: 'Customer Phone',
              icon: const Icon(Icons.phone),
              controller: phoneController,
              callBackFunction: (value) => value == null || value.isEmpty
                  ? 'Customer Phone is Required'
                  : null,
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (dbCustomer == null) {
                    Customer customer = Customer(
                        name: nameController.text, phone: phoneController.text);
                    await CustomerService.createCustomer(customer);
                  } else {
                    Customer customer = Customer(
                        id: dbCustomer!['id'],
                        name: nameController.text,
                        phone: phoneController.text);
                    await CustomerService.updateCustomer(customer);
                  }

                  if (!context.mounted) return; // ver important
                  Notifications.showNotification(
                      context, 'Customer Saved Successfully');
                  customerData.refreshCustomers();
                  Navigator.pop(context);
                }
              },
              style: kDefaultButton,
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
