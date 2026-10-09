import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../domain/use_cases/get_product_use_case.dart';

class ProductDetailsViewModel extends BaseViewModel {
  ProductDetailsViewModel({
    required this.productId,
    GetProductUseCase? getProduct,
  }) : _getProduct =
           getProduct ?? GetProductUseCase(locator<ProductRepository>());

  final int productId;
  final GetProductUseCase _getProduct;

  Product? product;
  int selectedImageIndex = 0;

  Future<void> loadProduct() async {
    setBusy(true);
    try {
      product = await _getProduct(productId);
    } catch (error) {
      setError(error);
    } finally {
      setBusy(false);
    }
  }

  void selectImage(int index) {
    selectedImageIndex = index;
    notifyListeners();
  }
}
