import 'package:appli_flutter/ui/screens/qrCodeScanner.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piction.ia.ry',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontSize: 30),
          titleSmall: TextStyle(fontSize: 20),
          titleLarge: TextStyle(fontSize: 40),
        ),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(Colors.red),
            foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
            // Fontsize
            textStyle: WidgetStatePropertyAll<TextStyle>(
                TextStyle(fontSize: 20)),
            padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(16)),
          ),
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(Colors.red),
            foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
            textStyle: WidgetStatePropertyAll<TextStyle>(
                TextStyle(fontSize: 20)),
            padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(16)),
          ),
        ),
        outlinedButtonTheme: const OutlinedButtonThemeData(
          style: ButtonStyle(
            side: WidgetStatePropertyAll<BorderSide>(
                BorderSide(color: Colors.red)),
            foregroundColor: WidgetStatePropertyAll<Color>(Colors.red),
            textStyle: WidgetStatePropertyAll<TextStyle>(
                TextStyle(fontSize: 20)),
            padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(16)),
          ),
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.red),
      ),
      // home: const Home(key: Key('home')),
      home: const QRCodeScannerPage()
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
        backgroundColor: Colors.red,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
