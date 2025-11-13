import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 420,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
                        SizedBox(width: 12),
                        // Left-aligned label inside the pill
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('johndoe1234', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                const Text('Change username'),
                const SizedBox(height: 8),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: TextEditingController(text: 'currentUsername'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter new username',
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                  width: 300,
                  child: TextButton(
                    onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(title: const Text('Change password')),
                        body: const Center(child: Text('Password change screen')), 
                      ),
                      ),
                    );
                    },
                    child: const Text('Change password'),
                  ),
                  ),
                ),
                const SizedBox(height: 30),

                Align(
                  child: SizedBox(
                    width: 300,
                    height: 200,
                    child: Card.filled(
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 10,
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              child: Text('Expiration Alerts'),
                            )
                          ]
                        ),
                      ),
                    ))
                ),


                // Visible card: give it an explicit size and content so it renders
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 300,
                    height: 56,
                    child: Card.filled(
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 10,
                      child: Center(
                        child: Text(
                          'Sign out',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
