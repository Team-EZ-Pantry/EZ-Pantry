import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/pantry_item_model.dart';

class PantryItemTile extends StatelessWidget {
  final PantryItemModel item;
  final VoidCallback? onTap;
  final VoidCallback? incrementQuantity;
  final VoidCallback? decrementQuantity;
  final ValueChanged<int>? changeQuantity;

  const PantryItemTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.incrementQuantity,
    required this.decrementQuantity,
    required this.changeQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.9),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.all(2),
              child: SizedBox( // Item image
                width: 48,
                height: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                ),
              ),
            ),
              
            const SizedBox(width: 12),
          
            // Item name and brand
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    item.brand ?? 'None',
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          
            const SizedBox(width: 8),
          
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
          
            // Quantity display (tappable)
            InkWell(
              onTap: () async {
                final TextEditingController controller = TextEditingController(text: quantity.toString());
                final int? newQuantity = await showDialog<int>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Edit Quantity'),
                    content: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        hintText: 'Enter a positive number',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final int? value = int.tryParse(controller.text);
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
                  '${item.quantity}',
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
              
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}