import 'package:flutter/material.dart';
import 'EnviarRemesaScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'apis/user_api.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final supabase = Supabase.instance.client;
  String username = '';
  double balance = 0.0;
  List<Map<String, dynamic>> recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTransacciones();
  }

  Future<void> _loadUserData() async {
    final userApi = UserApi();
    final userInfo = await userApi.getUserById();

    print(userInfo);
    if (userInfo != null) {
      userInfo.forEach((key, value) {
        print('$key: $value, type: ${value.runtimeType}');
      });
      setState(() {
        username = userInfo['username'] ?? 'No Disponible';
        balance = double.tryParse(userInfo['balance'].toString()) ?? 0.0;
      });
    } else {
      print('no se pudo cargar los datos del usuario');
    }
  }

  Future<void> _loadTransacciones() async {
    final userApi = UserApi();
    final transacciones = await userApi.getTransactionsForUser();

    if (transacciones != null) {
      for (var transaccion in transacciones) {
        print('Transacción: $transaccion');
      }
      setState(() {
        recentTransactions = transacciones;
      });
    } else {
      print('no se pudo cargar las transacciones del usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    username.isEmpty ? 'Cargando...' : username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(
                    Icons.account_circle,
                    size: 32,
                    color: Colors.black,
                  ),
                ],
              ),
            ),

            // Balance Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Balance:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${balance.toStringAsFixed(2)} Lps',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EnviarRemesaScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Enviar Remesa'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Agregar Fondos'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Reciente Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reciente:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (recentTransactions.isNotEmpty) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentTransactions.take(3).length,
                      itemBuilder: (context, index) {
                        final transaccion = recentTransactions[index];
                        final descripcion = transaccion['transaccion']
                                ['descripcion'] ??
                            'Descripción no disponible';
                        final monto =
                            transaccion['transaccion']['monto'] ?? 0.0;
                        final Rawfecha = transaccion['hecho_en'];
                        final fecha = Rawfecha != null
                            ? DateFormat('dd/MM/yyyy hh:mm a')
                                .format(DateTime.parse(Rawfecha).toLocal())
                            : 'Fecha no disponible';

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.history,
                            color: Colors.teal,
                            size: 32,
                          ),
                          title: Text(
                            descripcion,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Lps. $monto\n$fecha',
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white70,
                            size: 16,
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    const Text(
                      'No se han encontrado transacciones recientes.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Historial'),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Navigation
            Container(
              color: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EnviarRemesaScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
