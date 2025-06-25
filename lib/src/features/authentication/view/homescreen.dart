import 'package:flutter/material.dart';

/// The Home Screen of the App
class HomeScreen extends StatefulWidget {
  /// Constructor
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Home screen')));
}
