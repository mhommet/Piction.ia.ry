import 'package:flutter/material.dart';

class Identification extends StatelessWidget {
  Identification({required Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN PAGE'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Welcome to Piction.ia.ry',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Please enter your username',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  key: const Key('username'),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, perform your action here
                    }
                  },
                  child: const Text(
                    'Save',
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
