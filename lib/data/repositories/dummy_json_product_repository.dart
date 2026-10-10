import '../../core/network/api_constants.dart';
import '../../core/network/api_service.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class DummyJsonProductRepository implements ProductRepository {
  DummyJsonProductRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  @override
  Future<List<Product>> getProducts({
    String query = '',
    String? category,
  }) async {
    final normalizedQuery = query.trim();
    final normalizedCategory = category?.trim();
    final String path;
    final Map<String, String>? queryParameters;

    if (normalizedQuery.isNotEmpty) {
      path = ApiConstants.productSearch;
      queryParameters = {
        'q': normalizedQuery,
        'limit': '${ApiConstants.pageSize}',
      };
    } else if (normalizedCategory != null &&
        normalizedCategory.isNotEmpty &&
        normalizedCategory != 'All') {
      path =
          '${ApiConstants.products}/category/${Uri.encodeComponent(normalizedCategory)}';
      queryParameters = {'limit': '${ApiConstants.pageSize}'};
    } else {
      path = ApiConstants.products;
      queryParameters = {
        'limit': '${ApiConstants.pageSize}',
        'skip': '0',
      };
    }

    final response = await _apiService.get(
      path,
      queryParameters: queryParameters,
    ) as Map<String, dynamic>;
    final products = (response['products'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList(growable: false);

    if (normalizedQuery.isNotEmpty &&
        normalizedCategory != null &&
        normalizedCategory.isNotEmpty &&
        normalizedCategory != 'All') {
      return products
          .where((product) => product.category == normalizedCategory)
          .toList(growable: false);
    }
    return products;
  }

  @override
  Future<List<String>> getCategories() async {
    final response =
        await _apiService.get(ApiConstants.categories) as List<dynamic>;
    return response.whereType<String>().toList(growable: false);
  }

  @override
  Future<Product> getProduct(int id) async {
    final response =
        await _apiService.get('${ApiConstants.products}/$id')
            as Map<String, dynamic>;
    return Product.fromJson(response);
  }
}
