import 'package:flutter/material.dart';

const kScaffoldColor = Color(0xffe3edf8);

const kDefaultHead = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.w600,
  fontSize: 24.0,
);

const kH2 = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

var kDefaultButton = TextButton.styleFrom(
  backgroundColor: Colors.lightBlue,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(0),
  ),
  elevation: 5,
  shadowColor: Colors.lightBlue,
);

var kDefaultInput = InputDecoration(
  isDense: true,
  label: const Text('Customer Name'),
  suffixIcon: const Icon(Icons.person),
  border: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.lightBlueAccent,
    ),
    borderRadius: BorderRadius.circular(
      20,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.lightBlueAccent,
    ),
    borderRadius: BorderRadius.circular(
      20,
    ),
  ),
);
