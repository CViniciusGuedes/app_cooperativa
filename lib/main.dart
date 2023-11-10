import 'package:app_cooperativa/formularios/cooperado_cadastro.dart';
import 'package:app_cooperativa/screens/home_screen.dart';
import 'package:app_cooperativa/screens/propriedade_list.dart';
import 'package:app_cooperativa/widgets/painel_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
      // home: PainelWidget(),
      // home: CadastroUsuario(),
      // home: PropriedadeList(),
    );
  }
}
