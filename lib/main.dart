import 'package:flutter/material.dart';
import 'register_screen.dart'; 



class LoginScreen extends StatelessWidget {
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
          // Título
          Text(
            'Bienvenido',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
         
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Usuario'),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Usuario',
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
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text('+ Crear Cuenta'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
       
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/LoginPic.jpg'), 
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
         
          Container(
            color: Color(0xFF71C3A7), 
            height: 50,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
