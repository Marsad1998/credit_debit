import 'package:credit_debit/components/dashboard/customer_state.dart';
import 'package:credit_debit/constants.dart';
import 'package:credit_debit/db_connect.dart';
import 'package:credit_debit/models/customers.dart';
import 'package:credit_debit/widgets/trans_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCustomer extends StatelessWidget {
  const AddCustomer({
    super.key,
    this.customer,
  });

  final Map<String, dynamic>? customer;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(
      text: customer != null ? customer!['name'] : '',
    );
    TextEditingController phoneController = TextEditingController(
      text: customer != null ? customer!['phone'] : '',
    );
    final _formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
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
              icon: const Icon(Icons.phone_enabled),
              controller: phoneController,
              callBackFunction: (value) => value == null || value.isEmpty
                  ? 'Customer Phone is Required'
                  : null,
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (customer == null) {
                    await Customers.createItem(
                        nameController.text, phoneController.text);
                  } else {
                    await Customers.updateItem(customer!['id'],
                        nameController.text, phoneController.text);
                  }

                  Provider.of<CustomerData>(context, listen: false)
                      .refreshCustomers();

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
