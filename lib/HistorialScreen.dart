import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'apis/user_api.dart';

class HistorialScreen extends StatefulWidget {
  final List<Map<String, dynamic>> recentTransactions;

  const HistorialScreen({super.key, required this.recentTransactions});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  DateTime? fechaDesde;
  DateTime? fechaHasta;
  bool filtrarRecibidos = true;
  bool filtrarEnviados = true;
  String direccion = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

Future<void> _loadUserData() async {
    final userApi = UserApi();
    final userInfo = await userApi.getDir();

    if (userInfo != null) {
      setState(() {
        direccion = userInfo['direccion'] ?? 'No Disponible';
      });
    }
  }
  

  List<Map<String, dynamic>> get transaccionesFiltradas {
    List<Map<String, dynamic>> filtradas = widget.recentTransactions;

    if (!filtrarRecibidos) {
      filtradas = filtradas
          .where((t) => t['direccion_entrada'] != direccion)
          .toList();
    }
    if (!filtrarEnviados) {
      filtradas = filtradas
          .where((t) => t['direccion_salida'] != direccion)
          .toList();
    }

    if (fechaDesde != null) {
      filtradas = filtradas.where((t) {
        final fechaTransaccion = DateTime.parse(t['hecho_en']);
        return fechaTransaccion.isAfter(fechaDesde!) ||
            fechaTransaccion.isAtSameMomentAs(fechaDesde!);
      }).toList();
    }

    if (fechaHasta != null) {
      filtradas = filtradas.where((t) {
        final fechaTransaccion = DateTime.parse(t['hecho_en']);
        return fechaTransaccion.isBefore(fechaHasta!) ||
            fechaTransaccion.isAtSameMomentAs(fechaHasta!);
      }).toList();
    }

    return filtradas;
  }

  Future<void> _seleccionarFechaDesde() async {
    final seleccion = await showDatePicker(
      context: context,
      initialDate: fechaDesde ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (seleccion != null) {
      setState(() {
        fechaDesde = seleccion;
      });
    }
  }

  Future<void> _seleccionarFechaHasta() async {
    final seleccion = await showDatePicker(
      context: context,
      initialDate: fechaHasta ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (seleccion != null) {
      setState(() {
        fechaHasta = seleccion;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Historial de Transacciones',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey.shade50, // Fondo más suave
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtrar Transacciones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),

            // Filtros de tipo de transacción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: filtrarRecibidos,
                      activeColor: Colors.teal,
                      onChanged: (value) {
                        setState(() {
                          filtrarRecibidos = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      'Recibido',
                      style: TextStyle(color: Colors.teal),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: filtrarEnviados,
                      activeColor: Colors.teal,
                      onChanged: (value) {
                        setState(() {
                          filtrarEnviados = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      'Enviado',
                      style: TextStyle(color: Colors.teal),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Selector de fechas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _seleccionarFechaDesde,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          fechaDesde != null
                              ? DateFormat('dd/MM/yyyy').format(fechaDesde!)
                              : 'Desde',
                          style: const TextStyle(color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _seleccionarFechaHasta,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          fechaHasta != null
                              ? DateFormat('dd/MM/yyyy').format(fechaHasta!)
                              : 'Hasta',
                          style: const TextStyle(color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lista de transacciones filtradas
            Expanded(
              child: transaccionesFiltradas.isNotEmpty
                  ? ListView.builder(
                      itemCount: transaccionesFiltradas.length,
                      itemBuilder: (context, index) {
                        final transaccion = transaccionesFiltradas[index];
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

                        return Card(
                          elevation: 6,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Icon(
                              transaccion['transaccion']['tipo'] == 'recibido'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: transaccion['transaccion']['tipo'] == 'recibido'
                                  ? Colors.green
                                  : Colors.red,
                              size: 32,
                            ),
                            title: Text(
                              descripcion,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            subtitle: Text(
                              'Lps. $monto\n$fecha',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.teal,
                              size: 16,
                            ),
                            onTap: () {
                              _showTransactionDetails(context, transaccion);
                            },
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No se han encontrado transacciones.',
                        style: TextStyle(
                          color: Colors.black45,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para mostrar los detalles de una transacción
  void _showTransactionDetails(
      BuildContext context, Map<String, dynamic> transaccion) {
    final descripcion =
        transaccion['transaccion']['descripcion'] ?? 'Descripción no disponible';
    final monto = transaccion['transaccion']['monto'] ?? 0.0;
    final Rawfecha = transaccion['hecho_en'];
    final fecha = Rawfecha != null
        ? DateFormat('dd/MM/yyyy hh:mm a')
            .format(DateTime.parse(Rawfecha).toLocal())
        : 'Fecha no disponible';
    final receptor = transaccion['direccion_entrada'] ?? 'No disponible';
    final idTransaccion = transaccion['direccion_salida'] ?? 'No disponible';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Detalles de la Transacción',
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Descripción: $descripcion',
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'Monto: Lps. $monto',
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'Fecha: $fecha',
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'Receptor: $receptor',
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'Emisor: $idTransaccion',
                style: const TextStyle(color: Colors.black45),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        );
      },
    );
  }
}