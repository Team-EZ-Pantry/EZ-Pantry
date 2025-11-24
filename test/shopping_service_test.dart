import 'dart:convert';
import 'dart:io';

import 'package:ez_pantry/models/pantry_item_model.dart';
import 'package:ez_pantry/services/shopping_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HttpServer server;
  final List<Map<String, dynamic>> receivedRequests = <Map<String, dynamic>>[];

  setUpAll(() async {
    // Start a local HTTP server on port 3000 to mock the API endpoints used by ShoppingService.
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);

    server.listen((HttpRequest request) async {
      final String path = request.uri.path; // example: /api/shoppingList/
      final String method = request.method;

      // capture body if present
      String body = '';
      if (request.contentLength > 0) {
        body = await utf8.decoder.bind(request).join();
      }

      // Keep track of requests for assertions
      receivedRequests.add(<String, dynamic>{
        'path': path,
        'method': method,
        'body': body,
        'headers': request.headers.value('authorization'),
      });

      // Basic routing based on path
      if (path == '/api/shoppingList/' && method == 'GET') {
        // Return a shopping_lists array with a single id
        final Map<String, dynamic> resp = <String, dynamic>{
          'shopping_lists': <Map<String, dynamic>>[
            <String, dynamic>{'shopping_list_id': 123}
          ]
        };
        request.response.statusCode = 200;
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode(resp));
        await request.response.close();
        return;
      }

      // Simpler check for fetch list: path startsWith '/api/shoppingList/' and method GET
      if (path.startsWith('/api/shoppingList/') && method == 'GET') {
        // Return a shoppingList object with products array
        final Map<String, dynamic> product = <String, dynamic>{
          'id': 1,
          'product_name': 'Apple',
          'brand': 'TestBrand',
          'quantity': 2,
          'expiration_date': null,
          'image_url': null,
          'calories_per_100g': '',
          'protein_per_100g': '',
          'carbs_per_100g': '',
          'fat_per_100g': '',
          'nutrition': <String, dynamic>{},
          'created_at': DateTime.now().toIso8601String(),
        };

        final Map<String, dynamic> resp = <String, dynamic>{
          'shoppingList': <String, dynamic>{'products': <Map<String, dynamic>>[product]},
        };

        request.response.statusCode = 200;
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode(resp));
        await request.response.close();
        return;
      }

      // Add item: POST to /api/shoppingList/<id>/products
      if (path.contains('/api/shoppingList/') && path.endsWith('/products') && method == 'POST') {
        request.response.statusCode = 201;
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode(<String, dynamic>{'status': 'created'}));
        await request.response.close();
        return;
      }

      // Update quantity: PUT to /api/shoppingList/<id>/products/<productId>/quantity
      if (path.contains('/products/') && path.endsWith('/quantity') && method == 'PUT') {
        request.response.statusCode = 200;
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode(<String, dynamic>{'status': 'updated'}));
        await request.response.close();
        return;
      }

      // Default: not found
      request.response.statusCode = 404;
      await request.response.close();
    });
  });

  tearDownAll(() async {
    await server.close(force: true);
  });

  test('getShoppingListId returns id from server', () async {
    final ShoppingService service = ShoppingService();
    final int id = await service.getShoppingListId();
    expect(id, equals(123));
  });

  test('fetchShoppingListItems returns parsed PantryItemModel list', () async {
    final ShoppingService service = ShoppingService();
    final List<PantryItemModel> items = await service.fetchShoppingListItems(123);
    expect(items, isNotEmpty);
    expect(items.first.name, equals('Apple'));
    expect(items.first.id, equals(1));
  });

  test('addItem posts productId and quantity', () async {
    final ShoppingService service = ShoppingService();
    // Clear previous captured requests
    receivedRequests.clear();

    await service.addItem(7, 5);

    // The last POST should be captured
    final Map<String, dynamic> last = receivedRequests.last;
    expect(last['method'], equals('POST'));
    final Map<String, dynamic> parsed = jsonDecode(last['body'] as String) as Map<String, dynamic>;
    expect(parsed['productId'], equals(7));
    expect(parsed['quantity'], equals(5));
  });
}
