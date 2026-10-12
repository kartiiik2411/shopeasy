# shopeasy_app

ShopEasy is a three-screen Flutter shopping app built with Stacked state
management and the DummyJSON API.

## Run

```sh
flutter pub get
flutter run
```

Demo login: `emilys` / `emilyspass`.

## Structure

- `lib/ui/views/`: Stacked login, product catalogue, and product details screens.
- `lib/ui/common/`: Reusable `AppTextField` and `AppDialog` widgets.
- `lib/core/network/`: `ApiConstants`, `ApiService`, and API errors.
- `lib/domain/`: Entities, repository contracts, and use cases.
- `lib/data/`: DummyJSON-backed authentication and product repositories.
- Startup checks for a persisted Firebase sign-in token and opens the home
  screen or sign-in screen after the splash screen.
- Product browsing includes category images, sort/category/gender/filter
  controls, voice search, and camera capture. Camera capture is not visual
  product search because the current DummyJSON catalogue has no image-search
  endpoint.

Routes and dependencies are generated from `lib/app/app.dart` using
`dart run build_runner build`.
