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

          final transaccionId = await supabase
              .from('historial')
              .select(
                  'transaccion(*), hecho_en, direccion_salida, direccion_entrada')
              .or('direccion_salida.eq.$direccion,direccion_entrada.eq.$direccion')
              .order('hecho_en', ascending: false);

          return transaccionId;
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

  Future<void> agregarTransaccion({
    required String direccionDestino,
    required double monto,
    required String descripcion,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId != null) {
        //obtiene el otro usuario
        final direccionDestinoResponse = await supabase
            .from('direcciones')
            .select('user_id')
            .eq('direccion', direccionDestino)
            .maybeSingle();

        if (direccionDestinoResponse == null) {
          throw Exception('La dirección de destino no existe');
        }
        //id del otro usuario hecho
        final user_id_destino = direccionDestinoResponse['user_id'];

        //id del usuario que envia
        final direccionUser = await supabase
            .from('direcciones')
            .select('direccion')
            .eq('user_id', userId)
            .maybeSingle();

        if (direccionUser != null && direccionUser['direccion'] != null) {
          //direeccion del usuario que envia
          final direccionSalida = direccionUser['direccion'];

          if (direccionSalida == direccionDestino) {
            throw Exception('No se puede enviar a usted mismo');
          }

          //balance del user que envia
          final balanceResponse = await supabase
              .from('user')
              .select('balance')
              .eq('user_id', userId)
              .single();

          final balance = balanceResponse['balance'];

          if (monto > balance) {
            throw Exception('Saldo insuficiente');
          }

          //crea la transaccion
          final response = await supabase.from('transaccion').insert({
            'descripcion': descripcion,
            'monto': monto,
            //'stablecoin': stablecoin,
            'estado': 'pendiente',
            'metodo_conversion': 'manual',
          }).select('transaccion_id');

          if (response.isEmpty) {
            throw Exception('Error al crear la transacción: $response');
          }

          //crea el historial
          final transaccionId = response[0]['transaccion_id'];
          await supabase.from('historial').insert([
            {
              'transaccion_id': transaccionId,
              'direccion_salida': direccionSalida,
              'direccion_entrada': direccionDestino,
              'hecho_en': DateTime.now().toIso8601String(),
            }
          ]);

          await supabase
            .from('user')
            .update({'balance': balance - monto})
            .eq('user_id', userId);

          final balanceDestinoResponse = await supabase
            .from('user')
            .select('balance')
            .eq('user_id', user_id_destino)
            .single();

            final balanceDestino = balanceDestinoResponse['balance'];

            await supabase
            .from('user')
            .update({'balance': balanceDestino + monto})
            .eq('user_id', user_id_destino);
          
        } else {
          throw Exception('No se encontró la dirección del usuario');
        }
      } else {
        throw Exception('Usuario no ha iniciado sesión');
      }
    } catch (e) {
      print('Error al agregar transacción: $e');
      throw e;
    }
  }

  Future<void> agregarFondos({
    required double monto,
    required String descripcion,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        throw Exception('Usuario no ha iniciado sesión');
      }

      final direccionUser = await supabase
          .from('direcciones')
          .select('direccion')
          .eq('user_id', userId)
          .maybeSingle();

      if (direccionUser == null || direccionUser['direccion'] == null) {
        throw Exception('No se encontró la dirección del usuario');
      }

      final direccionDestino = direccionUser['direccion'];

      final response = await supabase.from('transaccion').insert({
        'descripcion': descripcion,
        'monto': monto,
        'estado': 'completada',
        'metodo_conversion': 'manual',
      }).select('transaccion_id');

      if (response.isEmpty) {
        throw Exception('Error al crear la transacción');
      }

      final transaccionId = response[0]['transaccion_id'];

      await supabase.from('historial').insert([
        {
          'transaccion_id': transaccionId,
          'direccion_salida': 'BANCO',
          'direccion_entrada': direccionDestino,
          'hecho_en': DateTime.now().toIso8601String(),
        }
      ]);

      final userBalance = await supabase
          .from('user')
          .select('balance')
          .eq('user_id', userId)
          .maybeSingle();

      if (userBalance == null || userBalance['balance'] == null) {
        throw Exception('No se encontró el balance del usuario');
      }

      final nuevoBalance = userBalance['balance'] + monto;

      final balanceUpdateResponse = await supabase
          .from('user')
          .update({'balance': nuevoBalance})
          .eq('user_id', userId)
          .select('*');

      if (balanceUpdateResponse.isNotEmpty) {
        print('Balance actualizado correctamente');
      } else {
        throw Exception('Error al actualizar el balance del usuario');
      }

      print('Transacción completada con éxito y balance actualizado');
    } catch (e) {
      print('Error al agregar fondos: $e');
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
