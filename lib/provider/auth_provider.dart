import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'dio_provider.dart';
import '../auth/auth_remote_datasource.dart';

final authRemoteProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSource(dio);
});

final authTokenProvider = StateProvider<String?>((ref) => null);

final loginProvider = FutureProvider.family<String, Map<String, String>>((ref, credentials) async {
  final authRemote = ref.watch(authRemoteProvider);
  final token = await authRemote.login(credentials['email']!, credentials['password']!);
  ref.read(authTokenProvider.notifier).state = token;
  return token;
});

final registerProvider = FutureProvider.family<void, Map<String, String>>((ref, data) async {
  final remote = ref.read(authRemoteProvider);
  await remote.register(data['name']!, data['email']!, data['password']!);
});

