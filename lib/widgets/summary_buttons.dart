import 'package:flutter/material.dart';

class SummaryDiv extends StatelessWidget {
  const SummaryDiv(
      {super.key,
      required this.label,
      required this.amount,
      required this.colour,
      this.txtcolour});

  final String label;
  final String amount;
  final Color colour;
  final Color? txtcolour;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            style: TextStyle(
              color: colour,
              fontWeight: FontWeight.bold,
            ),
            label,
          ),
          Text(
            amount,
            style: TextStyle(color: txtcolour, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
