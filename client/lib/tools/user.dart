import 'package:client/dummy_data.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/tools/api_handler.dart';

class User {
  final String? token;
  const User({this.token});

  Future<bool> inSession() async {
    if (token == null) return false;

    final result = await ApiHandler.userInSession(token!);
    return result;
  }
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

  void logout(BuildContext context, RouterNotifier router) async {
    await clearToken();
  }

  Future<Map<String, dynamic>> getProfile() async {
    final currentUser = state.valueOrNull;
    if (currentUser?.token == null) throw Exception("User not logged in");
    var profile = await ApiHandler.getProfile(currentUser!.token!);
    profile["pfp"] = await ApiHandler.hasPfp(profile["username"])
        ? "${ApiHandler.url}/api/user/pfp/${profile["username"]}"
        : DummyData.profilePicture;
    return profile;
  }

  String? get token => state.valueOrNull?.token;
}

final userProvider = AsyncNotifierProvider.autoDispose<UserNotifier, User>(() {
  return UserNotifier();
});
