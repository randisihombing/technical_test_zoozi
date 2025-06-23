import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  String baseUrlEndPoint = "https://wallet-testing-murex.vercel.app";

  Future<String> login(String email, String password) async {
    final response = await dio.post('$baseUrlEndPoint/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data['access_token'];
  }

  Future<void> register(String name, String email, String password) async {
    await dio.post('$baseUrlEndPoint/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });
  }
}
