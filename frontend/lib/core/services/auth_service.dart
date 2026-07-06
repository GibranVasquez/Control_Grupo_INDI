import '../../models/mock_data.dart';

class AuthService {
  static MockUser? _currentUser;

  static MockUser? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;
  static bool get isAdmin => _currentUser?.role == UserRole.admin;
  static bool get isAdministrative => _currentUser?.role == UserRole.administrative;
  static bool get isOperator => _currentUser?.role == UserRole.operator;

  static bool login(String email, String password) {
    final user = MockData.users.where(
      (u) => u.email == email && u.password == password,
    );
    if (user.isNotEmpty) {
      _currentUser = user.first;
      return true;
    }
    return false;
  }

  static void logout() {
    _currentUser = null;
  }
}
