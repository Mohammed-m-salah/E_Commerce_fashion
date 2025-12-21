import 'package:flutter/material.dart';

class ListSize extends StatefulWidget {
  const ListSize({super.key});

  @override
  State<ListSize> createState() => _ListSizeState();
}

class _ListSizeState extends State<ListSize> {
  final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: sizes.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            bool isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                width: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFff5722)
                      : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFff5722)
                        : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade700
                            : Colors.grey.shade400),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  sizes[index],
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
