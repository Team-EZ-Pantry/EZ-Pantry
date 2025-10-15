import 'package:flutter/material.dart';

class PantryItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final int quantity;
  final VoidCallback? onTap;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const PantryItemTile({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.quantity,
    this.onTap,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.9,
          ),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Row(
          children: [
            // Item name
            SizedBox(
              width: 220, // adjust this to your layout
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.normal),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 20),

            // Decrement button
            InkWell(
              onTap: onDecrement,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                child: const Text(
                  '-',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 6),

            // Quantity badge
            Container(
              width: 40,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$quantity',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(width: 6),

            // Increment button
            InkWell(
              onTap: onIncrement,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                child: const Text(
                  '+',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Subtitle below item
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        // Removed trailing icon entirely
      ),
    );
  }
}
