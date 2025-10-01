import 'package:flutter/material.dart';

class PantryItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  int quantity = 0;
  final VoidCallback? onTap;

  PantryItemTile({
    super.key,
    required this.title,
    this.subtitle = '',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // light grey line
            width: 0.5,         // thin
          ),
        ),
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
