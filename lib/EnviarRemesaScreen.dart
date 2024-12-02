import 'package:flutter/material.dart';

class EnviarRemesaScreen extends StatefulWidget {
  const EnviarRemesaScreen({super.key});

  @override
  _EnviarRemesaScreenState createState() => _EnviarRemesaScreenState();
}

class _EnviarRemesaScreenState extends State<EnviarRemesaScreen> {
  String _selectedCurrency = 'Seleccionar Moneda';

  void _showCurrencySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Selecciona tu Moneda',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Tether (USDT)'),
                onTap: () {
                  setState(() {
                    _selectedCurrency = 'Tether (USDT)';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('USDC (USDC)'),
                onTap: () {
                  setState(() {
                    _selectedCurrency = 'USDC (USDC)';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Dolares (USD)'),
                onTap: () {
                  setState(() {
                    _selectedCurrency = 'Dolares (USD)';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Euro (EU)'),
                onTap: () {
                  setState(() {
                    _selectedCurrency = 'Euro (EU)';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Enviar Remesa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        hintText: 'Value',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                        hintText: 'Value',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        hintText: 'Value',
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    ElevatedButton(
                      onPressed: () => _showCurrencySelectionDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.settings, color: Colors.white),
                          Text(_selectedCurrency),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Enviar'),
                    ),
                  ],
                ),
              ),
            ),
      
            Container(
              color: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                   
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () {
              
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                    
                    },
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
