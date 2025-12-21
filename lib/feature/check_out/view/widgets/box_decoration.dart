import 'package:flutter/material.dart';

BoxDecoration checkoutBoxDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade100,
    borderRadius: BorderRadius.circular(12),
  );
}
