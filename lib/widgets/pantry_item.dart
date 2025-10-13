import 'package:flutter/material.dart';

class PantryItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final int quantity;
  final VoidCallback? onTap;

  const PantryItemTile({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.quantity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // light grey line
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        title: Row(
          children: <Widget>[
            Container(
              width: 40, // fixed width
              height: 28, // adjust height for the badge
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green.shade100, // light background color
                borderRadius: BorderRadius.circular(6), // rounded corners
              ),
              child: Text(
                'x$quantity',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_right),
        onTap: onTap,
      ),
    );
  }
}
