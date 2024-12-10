import 'package:flutter/material.dart';
import 'EnviarRemesaScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'apis/user_api.dart';
import 'package:intl/intl.dart';
import 'AgregarFondosScreen.dart';
import 'HistorialScreen.dart';
import 'main.dart'; 

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reloadData();
  }

  bool isLoading = false;

  Future<void> _reloadData() async {
    setState(() {
      isLoading = true;
    });

    await _loadUserData();
    await _loadTransacciones();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadUserData() async {
    final userApi = UserApi();
    final userInfo = await userApi.getUserById();

    if (userInfo != null) {
      setState(() {
        username = userInfo['username'] ?? 'No Disponible';
        balance = double.tryParse(userInfo['balance'].toString()) ?? 0.0;
      });
    }
  }

  Future<void> _loadTransacciones() async {
    final userApi = UserApi();
    final transacciones = await userApi.getTransactionsForUser();

    if (transacciones != null) {
      setState(() {
        recentTransactions = transacciones;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await supabase.auth.signOut(); 
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
              
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal[700]!, Colors.teal[300]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            username.isEmpty ? 'Cargando...' : username,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _logout, // Llama a la función de cerrar sesión
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Cerrar sesión',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                              color: Colors.black87,
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
                                      builder: (context) =>
                                          const EnviarRemesaScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal[600],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Enviar Remesa'),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AgregarFondosScreen(),
                                    ),
                                  ).then((_) {
                                    _reloadData();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal[600],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Agregar Fondos'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Recent Transactions Section
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
                              color: Colors.black87,
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
                                    ? DateFormat('dd/MM/yyyy hh:mm a').format(
                                        DateTime.parse(Rawfecha).toLocal())
                                    : 'Fecha no disponible';

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: const Icon(
                                      Icons.history,
                                      color: Colors.teal,
                                      size: 32,
                                    ),
                                    title: Text(
                                      descripcion,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Lps. $monto\n$fecha',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black54,
                                      size: 16,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ] else ...[
                            const Text(
                              'No se han encontrado transacciones recientes.',
                              style: TextStyle(
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                              context,
                            MaterialPageRoute(
                              builder: (context) => HistorialScreen(recentTransactions: recentTransactions),
                            ),
                          );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Ver Historial'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
