import 'package:app_cooperativa/widgets/painel_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coperativa Agrícola',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Image.asset(
          'assets/images/coop_logo.png',
          scale: 8,
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: PainelWidget(),
      ),
    );
  }
}
