import 'package:flutter/material.dart';

class Identification extends StatelessWidget {
  const Identification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
	backgroundColor: Colors.grey,
	title: const Text('PICTION.IA.RY APP'),
      ),
      body: const Center(
	child: Column(
	  mainAxisAlignment: MainAxisAlignment.center,
	  children: <Widget>[
	      Text('Please enter your username'),
	      Expanded( 
		child: TextField(key: Key('username'),),
	      ),
	      // Button save 
	  ],
	),
      ),
    );
  }
}
