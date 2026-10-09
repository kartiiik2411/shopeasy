import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'product_list_viewmodel.dart';

class ProductListView extends StackedView<ProductListViewModel> {
  const ProductListView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ProductListViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: const Center(child: Text('Products will appear here')),
    );
  }

  @override
  ProductListViewModel viewModelBuilder(BuildContext context) =>
      ProductListViewModel();
}
