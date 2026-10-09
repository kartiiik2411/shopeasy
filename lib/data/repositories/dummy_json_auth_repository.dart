import '../../core/network/api_constants.dart';
import '../../core/network/api_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class DummyJsonAuthRepository implements AuthRepository {
  DummyJsonAuthRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  final ApiService _apiService;
  String? _accessToken;
  AuthUser? _currentUser;

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final response =
        await _apiService.post(
              ApiConstants.login,
              body: {'username': username, 'password': password},
            )
            as Map<String, dynamic>;
    _accessToken =
        response['accessToken'] as String? ?? response['token'] as String?;
    if (_accessToken == null || _accessToken!.isEmpty) {
      throw StateError('Login succeeded without an access token.');
    }
    _currentUser = _userFromJson(response);
    return _currentUser!;
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    final token = _accessToken;
    if (token == null) return null;
    final response =
        await _apiService.get(
              ApiConstants.currentUser,
              accessToken: token,
            )
            as Map<String, dynamic>;
    _currentUser = _userFromJson(response);
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _accessToken = null;
    _currentUser = null;
  }

  AuthUser _userFromJson(Map<String, dynamic> json) => AuthUser(
    id: '${json['id']}',
    email: json['email'] as String? ?? '',
    displayName:
        '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
    photoUrl: json['image'] as String?,
  );
}
