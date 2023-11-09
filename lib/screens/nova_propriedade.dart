import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NovaPropriedade extends StatefulWidget {
  const NovaPropriedade({super.key});

  @override
  State<NovaPropriedade> createState() => _NovaPropriedadeState();
}

class _NovaPropriedadeState extends State<NovaPropriedade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Propriedade'),
        centerTitle: true,
      ),
    );
  }
}
