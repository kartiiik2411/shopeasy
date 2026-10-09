import 'package:shopeasy_app/ui/views/home/home_view.dart';
import 'package:shopeasy_app/ui/views/product_list/product_list_view.dart';
import 'package:stacked/stacked_annotations.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView, initial: true),
    MaterialRoute(page: ProductListView),
  ],
  dependencies: [],
)
class App {}
