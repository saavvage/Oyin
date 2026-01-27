import '../entities/private/models/user_profile.dart';
class MockUserRepository {
  MockUserRepository._();

  static final MockUserRepository instance = MockUserRepository._();

  UserProfileM? _profile;

  UserProfileM? get profile => _profile;

  void save(UserProfileM profile) {
    _profile = profile;
  }

  void clear() {
    _profile = null;
  }

  UserProfileM getOrDefault() {
    return _profile ??
        const UserProfileM(
          firstName: 'Ivan',
          lastName: 'Ivanov',
          email: 'ivan@example.ru',
          city: 'Almaty, Kazakhstan',
          phone: '+7 777 123 45 67',
          birthDate: null,
        );
  }
}
