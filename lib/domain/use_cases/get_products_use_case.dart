import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<Product>> call({String query = '', String? category}) {
    return _repository.getProducts(query: query, category: category);
  }
}
