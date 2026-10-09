import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductUseCase {
  const GetProductUseCase(this._repository);

  final ProductRepository _repository;

  Future<Product> call(int id) => _repository.getProduct(id);
}
