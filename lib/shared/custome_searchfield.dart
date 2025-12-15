import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final VoidCallback? onFilterTap;

  const CustomSearchField({
    super.key,
    this.hintText = "Search ",
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),

          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.black, width: 1.2),
          ),

          // Left search icon
          prefixIcon: const Icon(Icons.search, color: Colors.grey),

          // Right filter icon button
          suffixIcon: GestureDetector(
            onTap: onFilterTap,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.filter_list_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
