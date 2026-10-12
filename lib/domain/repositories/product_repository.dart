import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({String query = '', String? category});

  Future<List<String>> getCategories();

  Future<Product> getProduct(int id);
}
