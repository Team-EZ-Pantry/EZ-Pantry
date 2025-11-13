import 'package:ez_pantry/widgets/logout_check.dart';
import 'package:flutter/material.dart';

import '../widgets/logout_check_dialog.dart';
import '../utilities/logout_user.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool expirationAlerts = true;
  bool recipeReminders = false;
  bool shoppingListReminders = true;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 420,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      children: <Widget>[
                        CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
                        SizedBox(width: 12),
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
                const SizedBox(height: 20),
              SizedBox(
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
                const SizedBox(height: 20),

                
                const SizedBox(
                  width: 280,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Notification Settings'),
                  ),
                ),
                
                // Preferences card
                SizedBox(
                  width: 300,
                  height: 200,
                  child: Card(
                    color: Colors.green[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Row 1
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Expiration Alerts'),
                              Switch(
                                value: expirationAlerts,
                                onChanged: (bool value) {
                                  setState(() {
                                    expirationAlerts = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          const Divider(thickness: 1, height: 10),
                          // Row 2
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Recipe Reminders'),
                              Switch(
                                value: recipeReminders,
                                onChanged: (bool value) {
                                  setState(() {
                                    recipeReminders = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          const Divider(thickness: 1, height: 10),
                          // Row 3
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('shoppingListReminders'),
                              Switch(
                                value: shoppingListReminders,
                                onChanged: (bool value) {
                                  setState(() {
                                    shoppingListReminders = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),


                const SizedBox(
                  width: 280,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Theme'),
                  ),
                ),
                // Theme card
                SizedBox(
                  width: 300,
                  height: 56,
                  child: Card(
                    color: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 10,
                    child: Center(
                      child: Text(
                        '[Current Theme]',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 100,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => LogoutCheckDialog(onStayLoggedIn: () {  }, onConfirmLogout: () { logoutUser(context); },),
                        );
                      },
                    child: const Text('Log out'),
                  ),
                ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(title: const Text('Delete Account')),
                              body: const Center(child: Text('Delete account screen')),
                            ),
                          ),
                        );
                      },
                      child: const Text('Delete Account'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
