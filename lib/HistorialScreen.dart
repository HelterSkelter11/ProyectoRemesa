import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  List<Map<String, dynamic>> get transaccionesFiltradas {
    List<Map<String, dynamic>> filtradas = widget.recentTransactions;

    
    if (!filtrarRecibidos) {
      filtradas = filtradas
          .where((t) => t['transaccion']['tipo'] != 'recibido')
          .toList();
    }
    if (!filtrarEnviados) {
      filtradas = filtradas
          .where((t) => t['transaccion']['tipo'] != 'enviado')
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
          'Historial:',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
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

          
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _seleccionarFechaDesde,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      fechaDesde != null
                          ? DateFormat('dd/MM/yyyy').format(fechaDesde!)
                          : 'Desde',
                      style: const TextStyle(color: Colors.teal),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _seleccionarFechaHasta,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      fechaHasta != null
                          ? DateFormat('dd/MM/yyyy').format(fechaHasta!)
                          : 'Hasta',
                      style: const TextStyle(color: Colors.teal),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

          
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
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Icon(
                              transaccion['transaccion']['tipo'] == 'recibido'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: transaccion['transaccion']['tipo'] ==
                                      'recibido'
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
    final receptor = transaccion['receptor'] ?? 'No disponible';
    final idTransaccion = transaccion['transaccion']['id'] ?? 'Sin ID';

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
                'ID Transacción: $idTransaccion',
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
