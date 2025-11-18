// Flutter widget tests for PantryPage
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:ez_pantry/screens/pantry_page.dart';
import 'package:ez_pantry/models/pantry_item_model.dart';
import 'package:ez_pantry/providers/pantry_provider.dart';

class FakePantryProvider extends PantryProvider {
  bool _loadingLocal = false;
  List<PantryItemModel> _itemsLocal = <PantryItemModel>[];
  Completer<bool>? loadCompleter;

  @override
  bool get loading => _loadingLocal;

  @override
  List<PantryItemModel> get items => _itemsLocal;

  @override
  Future<bool> loadPantryItems() async {
    _loadingLocal = true;
    notifyListeners();

    final bool result = await (loadCompleter?.future ?? Future<bool>.value(true));

    _loadingLocal = false;
    notifyListeners();
    return result;
  }

  @override
  Future<void> createPantry(String pantryName) async {
    // no-op for tests
    return;
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final int idx = _itemsLocal.indexWhere((e) => e.id == productId);
    if (idx != -1) {
      _itemsLocal[idx].quantity = quantity;
      notifyListeners();
    }
  }
}

void main() {
  testWidgets('shows loading indicator while provider is loading', (WidgetTester tester) async {
    final FakePantryProvider fake = FakePantryProvider();
    fake.loadCompleter = Completer<bool>();

    // Start with no items; load will wait until we complete the completer
    fake._itemsLocal = <PantryItemModel>[];

    await tester.pumpWidget(
      ChangeNotifierProvider<PantryProvider>.value(
        value: fake,
        child: const MaterialApp(home: PantryPage()),
      ),
    );

    // initState schedules loadPantryItems, which sets loading=true and notifies.
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Finish loading
    fake.loadCompleter!.complete(true);
    await tester.pumpAndSettle();
  });

  testWidgets('shows empty pantry when provider has no items', (WidgetTester tester) async {
    final FakePantryProvider fake = FakePantryProvider();
    fake.loadCompleter = Completer<bool>();
    fake._itemsLocal = <PantryItemModel>[];

    await tester.pumpWidget(
      ChangeNotifierProvider<PantryProvider>.value(
        value: fake,
        child: const MaterialApp(home: PantryPage()),
      ),
    );

    // allow load to start
    await tester.pump();

    // Complete load
    fake.loadCompleter!.complete(true);
    await tester.pumpAndSettle();

    expect(find.text('Empty Pantry'), findsOneWidget);
  });

  testWidgets('renders item list and increments quantity on + tap', (WidgetTester tester) async {
    final FakePantryProvider fake = FakePantryProvider();
    fake.loadCompleter = Completer<bool>();

    fake._itemsLocal = <PantryItemModel>[
      PantryItemModel(
        id: 1,
        name: 'Apple',
        quantity: 1,
        nutritionFacts: <String, dynamic>{},
        createdAt: DateTime.now(),
        productType: 'Fruit'
      ),
    ];

    await tester.pumpWidget(
      ChangeNotifierProvider<PantryProvider>.value(
        value: fake,
        child: const MaterialApp(home: PantryPage()),
      ),
    );

    // Start the load and then complete
    await tester.pump();
    fake.loadCompleter!.complete(true);
    await tester.pumpAndSettle();

    // Verify the item appears
    expect(find.text('Apple'), findsOneWidget);
    // Quantity should show initial 1
    expect(find.text('1'), findsWidgets);

    // Tap the + button (there should be a single '+' in the item)
    final Finder plusFinder = find.text('+').first;
    await tester.tap(plusFinder);
    await tester.pumpAndSettle();

    // After tapping, pantry page increments local quantity and calls updateQuantity which updates provider
    expect(find.text('2'), findsWidgets);
  });
}
