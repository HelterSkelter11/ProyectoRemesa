import 'package:flutter/material.dart';
import 'apis/user_api.dart';

class EnviarRemesaScreen extends StatefulWidget {
  const EnviarRemesaScreen({super.key});

  @override
  _EnviarRemesaScreenState createState() => _EnviarRemesaScreenState();
}

class _EnviarRemesaScreenState extends State<EnviarRemesaScreen> {
  final String infuraUrl = 'https://arbitrum-sepolia.infura.io/v3/2f155a88717a4361b1e7bbb652e91d87';
  final String contractAddress = '0xC7b9De8bF52a2eb0a7248e16149Ab9d5D96Ebe6F';

  String _selectedCurrency = 'Seleccionar Moneda';
  double _conversionRate = 1.0; // Tasa de conversión inicial
  String _convertedAmount = ''; // Monto convertido dinámicamente
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  // Mapeo de tasas de cambio (simuladas)
  final Map<String, double> conversionRates = {
    'Tether (USDT)': 0.041,
    'USDC (USDC)': 0.041,
    'Dolares (USD)': 0.041,
    'Euro (EU)': 0.038,
  };

  void _updateConversion(String input) {
    final cantidad = double.tryParse(input) ?? 0.0;

    setState(() {
      if (_selectedCurrency == 'Seleccionar Moneda' || cantidad <= 0) {
        _convertedAmount = '';
      } else {
        final convertedValue = cantidad * _conversionRate;
        _convertedAmount = '${convertedValue.toStringAsFixed(2)} $_selectedCurrency';
      }
    });
  }

  void _showCurrencySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona tu Moneda'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: conversionRates.keys.map((currency) {
              return ListTile(
                title: Text(currency),
                onTap: () {
                  setState(() {
                    _selectedCurrency = currency;
                    _conversionRate = conversionRates[currency]!;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> agregarTransaccion() async {
    final direccion = direccionController.text;
    final cantidad = double.tryParse(cantidadController.text) ?? 0.0;
    final descripcion = descripcionController.text;

    if (direccion.isEmpty || cantidad <= 0 || descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, llena todos los campos correctamente.")),
      );
      return;
    }

    try {
      final userApi = UserApi();
      await userApi.agregarTransaccion(
        direccionDestino: direccion,
        monto: cantidad,
        descripcion: descripcion,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transacción agregada correctamente")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al agregar transacción: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Enviar Remesa', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: direccionController,
                          decoration: InputDecoration(
                            labelText: 'Dirección',
                            hintText: 'Introduce la dirección',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: cantidadController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Cantidad (Lempiras)',
                            hintText: 'Introduce la cantidad',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: _updateConversion,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _convertedAmount.isNotEmpty
                                ? 'Equivalente: $_convertedAmount'
                                : 'Selecciona una moneda para ver la conversión',
                            style: TextStyle(
                              fontSize: 14,
                              color: _convertedAmount.isNotEmpty ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: descripcionController,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            hintText: 'Introduce una descripción',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _showCurrencySelectionDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.attach_money, color: Colors.white),
                  label: Text(_selectedCurrency),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: agregarTransaccion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Enviar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
