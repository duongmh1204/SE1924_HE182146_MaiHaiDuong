import '../models/user.dart';
import 'user_repository.dart';

class InMemoryUserRepository implements UserRepository {
  final List<UserModel> _users = <UserModel>[
    const UserModel(
      id: 1,
      fullName: 'Nguyễn Văn A',
      email: 'a.nguyen@gmail.com',
      avatar: '',
    ),
    const UserModel(
      id: 2,
      fullName: 'Trần Thị B',
      email: 'b.tran@gmail.com',
      avatar: '',
    ),
  ];

  @override
  Future<List<UserModel>> getUsers() async {
    return List<UserModel>.from(_users);
  }

  @override
  Future<void> addUser(UserModel user) async {
    _users.add(user);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    _users.removeWhere((u) => u.id == id);
  }
}
