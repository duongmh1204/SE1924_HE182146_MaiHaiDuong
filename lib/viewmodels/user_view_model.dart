import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../repositories/in_memory_user_repository.dart';
import '../repositories/user_repository.dart';

class UserState {
  final List<UserModel> items;
  final bool isLoading;

  const UserState({
    this.items = const <UserModel>[],
    this.isLoading = false,
  });

  UserState copyWith({
    List<UserModel>? items,
    bool? isLoading,
  }) {
    return UserState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserViewModel extends StateNotifier<UserState> {
  UserViewModel(this.repository) : super(const UserState(isLoading: true)) {
    loadUsers();
  }

  final UserRepository repository;

  Future<void> loadUsers() async {
    state = const UserState(isLoading: true);
    final users = await repository.getUsers();
    state = state.copyWith(items: users, isLoading: false);
  }

  Future<void> addUser({
    required String fullName,
    required String email,
    required String avatar,
  }) async {
    final newId = state.items.isEmpty
        ? 1
        : state.items.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;

    final newUser = UserModel(
      id: newId,
      fullName: fullName,
      email: email,
      avatar: avatar,
    );

    await repository.addUser(newUser);
    state = state.copyWith(items: <UserModel>[...state.items, newUser]);
  }

  Future<void> updateUser(UserModel user) async {
    await repository.updateUser(user);
    state = state.copyWith(
      items: <UserModel>[
        for (final u in state.items)
          if (u.id == user.id) user else u,
      ],
    );
  }

  Future<void> deleteUser(int id) async {
    await repository.deleteUser(id);
    state = state.copyWith(
      items: state.items.where((u) => u.id != id).toList(),
    );
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return InMemoryUserRepository();
});

final userViewModelProvider =
    StateNotifierProvider<UserViewModel, UserState>((ref) {
  return UserViewModel(ref.watch(userRepositoryProvider));
});
