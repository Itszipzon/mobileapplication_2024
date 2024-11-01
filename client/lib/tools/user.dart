import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/tools/api_handler.dart';

class User {
  final String? token;
  const User({this.token});
}

class UserNotifier extends AutoDisposeAsyncNotifier<User> {
  @override
  Future<User> build() async {
    return await _loadToken();
  }

  Future<User> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    return User(token: token);
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
    state = AsyncData(User(token: token));
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    state = const AsyncData(User());
  }

  Future<bool> inSession() async {
    final currentUser = state.valueOrNull;
    if (currentUser?.token == null) return false;

    final result = await ApiHandler.userInSession(currentUser!.token!);
    if (!result) await clearToken();
    return result;
  }

  Future<bool> logout() async {
    final currentUser = state.valueOrNull;
    if (currentUser?.token == null) return false;

    final result = await ApiHandler.logout(currentUser!.token!);
    if (result) await clearToken();
    return result;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final currentUser = state.valueOrNull;
    if (currentUser?.token == null) throw Exception("User not logged in");

    return await ApiHandler.getProfile(currentUser!.token!);
  }

  void clear() {
    state = const AsyncData(User());
  }

  String? get token => state.valueOrNull?.token;
}

final userProvider = AsyncNotifierProvider.autoDispose<UserNotifier, User>(() {
  return UserNotifier();
});
