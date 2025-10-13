import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/pantry_provider.dart';
import 'screens/login_page.dart';
import 'screens/pantry_page.dart';
import 'screens/recipes_page.dart';
import 'screens/shopping_page.dart';
import 'utilities/session_controller.dart';

void main() {
  runApp(
      ChangeNotifierProvider<PantryProvider>(
        create: (_) => PantryProvider(),
      child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = SessionController();
    
    /// Check for the auth token
    String launchRoute;

    //sessionController.clearAuthToken();
    //debugPrint('Cleared AuthToken for testing.');

    if (sessionController.checkAuthToken()) {
      launchRoute = '/home';
      debugPrint('AuthToken found, navigating to home.');
    }
    else {
      launchRoute = '/login';
      debugPrint('No AuthToken, navigating to login.');
    }

    return MaterialApp(
      title: 'EZ Pantry',
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),

			initialRoute: launchRoute,
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/home': (BuildContext context) => const MyHomePage(title: 'EZ Pantry'),
      },

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1; // 0 for Recipes, 1 for Pantry, 2 for Shopping

  late List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      const RecipesPage(),
      PantryPage(), // non-const
      const ShoppingPage(),
    ];

    // Safe async call after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PantryProvider>().loadPantryItems();
    });
  }




  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            }
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Pantry',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Shopping',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
