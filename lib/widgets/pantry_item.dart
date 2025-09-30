import 'package:flutter/material.dart';

//***************************************//
//     Reusable pantry item class.       //
//***************************************//

// icon parts are commented out for now, but fix it later when icons are made

class PantryItem extends StatelessWidget {
  final String title;
  final String subtitle;
  //final IconData icon;
  final VoidCallback? onTap;

  const PantryItem({
    Key? key,
    required this.title,
    this.subtitle = '',
    //required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
