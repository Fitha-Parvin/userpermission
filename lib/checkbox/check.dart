import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button, Checkbox, and Label Example',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String displayText = '';
  bool isChecked = false;

  void showMessage() {
    if (isChecked) {
      setState(() {
        displayText = 'Hello World';
      });
    } else {
      setState(() {
        displayText = 'Please check the box first!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button, Label, and Checkbox'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text Label
            Text(
              displayText,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),

            // Checkbox
            CheckboxListTile(
              title: const Text('Check this box'),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
            ),
            const SizedBox(height: 20),

            // Button
            ElevatedButton(
              onPressed: showMessage,
              child: const Text('Click Me'),
            ),
          ],
        ),
      ),
    );
  }
}
