import 'package:flutter/material.dart';

import 'auth/login.dart';
import 'auth/register.dart';
import 'components/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}


// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PorkProsper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define the routes
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const MyHomePage(title: 'PorkProsper Home'),
      },
      // Set the initial route
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.network(
                        'https://thumbs.wbm.im/pw/medium/d17b77057c499b425aa01dfb560b8e5c.avif', // Replace with your image URL
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        'Welcome to PorkProsper!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'This is an application for managing pig farms. You can login or register to start using the app.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.network(
                        'https://www.agriculture.com/thmb/BGpLAmq0y5L6MPqKDPFlAkt9Izw=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Caretaker20With20Finisher20Pigs-2000-3a3819e0f5e94ae4a0847bb4d4fa9d10.jpg',
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        'Proper Housing Design and Ventilation.',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Learn about proper design, housing and ventilation for your pigs to ensure their health and productivity.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(

                    children: [
                      Image.network(
                        'https://plus.unsplash.com/premium_photo-1679086008007-dded8f7d26a5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D' ,
                        fit: BoxFit.cover,),
                      const Text(
                        'Alerts System Based on Ambient Variables',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Get alerts when drastic changes in ambient variables occur to ensure the well-being of your pigs.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {

                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {

                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}