import '../repositories/product_repository.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<String>> call() => _repository.getCategories();
}
