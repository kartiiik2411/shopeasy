import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shopeasy_app/core/network/api_service.dart';
import 'package:shopeasy_app/data/repositories/dummy_json_auth_repository.dart';
import 'package:shopeasy_app/data/repositories/dummy_json_product_repository.dart';

void main() {
  group('DummyJsonAuthRepository', () {
    test('logs in and sends the access token to /auth/me', () async {
      final requests = <http.Request>[];
      final apiService = ApiService(
        client: MockClient((request) async {
          requests.add(request);
          if (request.url.path == '/auth/login') {
            return _jsonResponse({
              'id': 1,
              'username': 'emilys',
              'firstName': 'Emily',
              'lastName': 'Johnson',
              'email': 'emily@example.com',
              'image': 'https://example.com/emily.png',
              'accessToken': 'test-access-token',
            });
          }
          return _jsonResponse({
            'id': 1,
            'firstName': 'Emily',
            'lastName': 'Johnson',
            'email': 'emily@example.com',
            'image': 'https://example.com/emily.png',
          });
        }),
      );
      final repository = DummyJsonAuthRepository(apiService: apiService);

      final user = await repository.login(
        username: 'emilys',
        password: 'emilyspass',
      );
      final currentUser = await repository.getCurrentUser();

      expect(jsonDecode(requests.first.body), {
        'username': 'emilys',
        'password': 'emilyspass',
      });
      expect(requests[1].url.path, '/auth/me');
      expect(
        requests[1].headers['Authorization'],
        'Bearer test-access-token',
      );
      expect(user.displayName, 'Emily Johnson');
      expect(currentUser?.email, 'emily@example.com');

      await repository.signOut();
      expect(await repository.getCurrentUser(), isNull);
      expect(requests, hasLength(2));
    });
  });

  group('DummyJsonProductRepository', () {
    test('uses DummyJSON search and category endpoints', () async {
      final requests = <http.Request>[];
      final repository = DummyJsonProductRepository(
        apiService: ApiService(
          client: MockClient((request) async {
            requests.add(request);
            if (request.url.path == '/products/category-list') {
              return _jsonResponse(['beauty', 'fragrances']);
            }
            if (request.url.path == '/products/category/beauty') {
              return _jsonResponse({
                'products': [_productJson(id: 1, category: 'beauty')],
              });
            }
            if (request.url.path == '/products' &&
                request.url.queryParameters.containsKey('skip')) {
              return _jsonResponse({
                'products': [_productJson(id: 1, category: 'beauty')],
              });
            }
            if (request.url.path == '/products/search') {
              return _jsonResponse({
                'products': [
                  _productJson(id: 1, category: 'beauty'),
                  _productJson(id: 2, category: 'fragrances'),
                ],
              });
            }
            return _jsonResponse(_productJson(id: 1, category: 'beauty'));
          }),
        ),
      );

      final categories = await repository.getCategories();
      final initialProducts = await repository.getProducts();
      final categoryProducts = await repository.getProducts(
        category: 'beauty',
      );
      final products = await repository.getProducts(
        query: 'serum',
        category: 'beauty',
      );
      final detail = await repository.getProduct(1);

      expect(categories, ['beauty', 'fragrances']);
      expect(requests[0].url.path, '/products/category-list');
      expect(requests[1].url.path, '/products');
      expect(requests[1].url.queryParameters, {'limit': '20', 'skip': '0'});
      expect(initialProducts, hasLength(1));
      expect(requests[2].url.path, '/products/category/beauty');
      expect(requests[2].url.queryParameters, {'limit': '20'});
      expect(categoryProducts, hasLength(1));
      expect(requests[3].url.path, '/products/search');
      expect(requests[3].url.queryParameters, {'q': 'serum', 'limit': '20'});
      expect(products.map((product) => product.id), [1]);
      expect(requests[4].url.path, '/products/1');
      expect(detail.discountedPrice, closeTo(90, 0.01));
      expect(detail.brand, 'ShopEasy');
    });
  });
}

http.Response _jsonResponse(Object body) => http.Response(
  jsonEncode(body),
  200,
  headers: {'content-type': 'application/json'},
);

Map<String, Object> _productJson({required int id, required String category}) =>
    {
      'id': id,
      'title': 'Face serum',
      'description': 'A hydrating face serum.',
      'price': 100,
      'discountPercentage': 10,
      'rating': 4.5,
      'stock': 20,
      'brand': 'ShopEasy',
      'category': category,
      'thumbnail': 'https://example.com/product.png',
      'images': ['https://example.com/product.png'],
    };
