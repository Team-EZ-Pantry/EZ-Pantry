import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // needed for FilteringTextInputFormatter

class PantryItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final int quantity;
  final VoidCallback? onTap;
  final VoidCallback? incrementQuantity;
  final VoidCallback? decrementQuantity;
  final ValueChanged<int>? changeQuantity;

  const PantryItemTile({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.quantity,
    this.onTap,
    this.incrementQuantity,
    this.decrementQuantity,
    this.changeQuantity,
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
              width: 220,
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.normal),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 20),

            // Decrement button
            InkWell(
              onTap: decrementQuantity,
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

            // Editable quantity badge
            InkWell(
              onTap: () async {
                final controller = TextEditingController(text: quantity.toString());
                final newQuantity = await showDialog<int>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Edit Quantity'),
                    content: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        hintText: 'Enter a positive number',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final value = int.tryParse(controller.text);
                          if (value != null && value >= 0) {
                            Navigator.pop(context, value);
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );

                if (newQuantity != null) {
                  changeQuantity?.call(newQuantity);
                }
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
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
            ),

            const SizedBox(width: 6),

            // Increment button
            InkWell(
              onTap: incrementQuantity,
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

        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      ),
    );
  }
}
