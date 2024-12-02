import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getUserById() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId != null) {
        final response = await supabase
            .from('user')
            .select('*')
            .eq('user_id', userId)
            .maybeSingle();

        if (response != null) {
          return response;
        }
      } else {
        print('Usuario no ha iniciado session.');
      }
    } catch (e) {
      print('Error al obtener el usuario: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getTransactionsForUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId != null) {
        final direccionUser = await supabase
            .from('direcciones')
            .select('direccion')
            .eq('user_id', userId)
            .maybeSingle();

        if (direccionUser != null && direccionUser['direccion'] != null) {
          final direccion = direccionUser['direccion'];

          final transaccion_id = await supabase
              .from('historial')
              .select('*, transaccion:*')
              .or('direccion_salida.eq.$direccion,direccion_entrada.eq.$direccion')
              .order('hecho_en', ascending: false);

          return transaccion_id;
        } else {
          print('No se encontró la dirección del usuario.');
        }
      } else {
        print('Usuario no ha iniciado sesión.');
      }
    } catch (e) {
      print('Error al obtener transacciones: $e');
    }
    return null;
  }

  Future<void> agregarTransaccion({ required String direccionDestino, required double monto, required String stablecoin, required String descripcion, required bool entrada}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId != null) {
        final direccionUser = await supabase
            .from('direcciones')
            .select('direccion')
            .eq('user_id', userId)
            .maybeSingle();

        if (direccionUser != null && direccionUser['direccion'] != null) {
          final direccionSalida = direccionUser['direccion'];

          final balanceResponse = await supabase
              .from('usuarios')
              .select('balance')
              .eq('user_id', userId)
              .single();

          final balance = balanceResponse['balance'];

          if (monto > balance) {
            throw Exception('Saldo insuficiente');
          }

          final response = await supabase.from('transaccion').insert({
            'descripcion': descripcion,
            'monto': monto,
            'stablecoin': stablecoin,
            'estado': 'pendiente',
            'direccion_salida': direccionSalida,
            'direccion_entrada': direccionDestino,
            'metodo_conversion': 'manual', //no se que poner aqui xd
          }).select();

          if (response.isEmpty) {
            throw Exception('Error al crear la transacción: ${response}');
          }

          final transaccionId = response[0]['id'];
          await supabase.from('historial').insert([
            {
              'transaccion_id': transaccionId,
              'direccion_salida': direccionSalida,
              'direccion_entrada': direccionDestino,
              'hecho_en': DateTime.now().toIso8601String(),
            }
          ]);

          print('Transacción creada con éxito');
        } else {
          throw Exception('No se encontró la dirección del usuario');
        }
      } else {
        throw Exception('Usuario no ha iniciado sesión');
      }
    } catch (e) {
      print('Error al agregar transacción: $e');
    }
  }

  /*Future<void> agregarTransaccion({
    required bool entrada,
    required String direccion,
    required String descripcion,
    required double monto,
    required String stablecoin,
    required String estado,
    required String metodoConversion,
  }) async {
    final response = await supabase.from('transaccion').insert({
      'entrada': entrada,
      'direccion': direccion,
      'descripcion': descripcion,
      'monto': monto,
      'stablecoin': stablecoin,
      'estado': estado,
      'metodo_conversion': metodoConversion,
    });

    if (response.error != null) {
      throw Exception(
          'Error al agregar la transacción: ${response.error!.message}');
    }

    print('Transacción agregada: ${response.data}');
  }*/
}
