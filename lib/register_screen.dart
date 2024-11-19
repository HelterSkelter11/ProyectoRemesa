import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          
          Container(
            color: Color(0xFF71C3A7), 
            height: 100,
          ),
          SizedBox(height: 20),
        
          Text(
            'Crea tu Cuenta',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
       
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Usuario'),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Nombre',
                  ),
                ),
                SizedBox(height: 20),
                Text('Correo'),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ejemplo@gmail.com',
                  ),
                ),
                SizedBox(height: 20),
                Text('Contraseña'),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                  ),
                ),
                SizedBox(height: 20),
                Text('Confirmar Contraseña'),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirmar contraseña',
                  ),
                ),
                SizedBox(height: 30),
           
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                   
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF71C3A7),
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    ),
                    child: Text(
                      'Crear Cuenta',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); 
                    },
                    child: Text('Iniciar Sesión'),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0xFF71C3A7),
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
