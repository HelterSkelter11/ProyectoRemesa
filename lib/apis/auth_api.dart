import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';


class AuthApi {
  final supabase = Supabase.instance.client;
  //final _storage = FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    try {
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      final response = await supabase
          .from('auth_table')
          .select()
          .match({'username': username, 'password': hashedPassword})
          .maybeSingle();

      if (response != null) {
        //await _storage.write(key: 'auth_token', value: response.data[0]['token']);
        return true;
      }
    } catch (e) {
      print('Error en el login: $e');
    }
    return false;
  }

  Future<void> logout() async {
    //await _storage.delete(key: 'auth_token');
  }
}
