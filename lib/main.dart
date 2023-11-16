import 'dart:developer' as dev;
import 'package:app_cooperativa/formularios/cooperado_cadastro.dart';
import 'package:app_cooperativa/formularios/producao_cadastro.dart';
import 'package:app_cooperativa/screens/home_screen.dart';
import 'package:app_cooperativa/screens/propriedade_list.dart';
import 'package:app_cooperativa/widgets/painel_widget.dart';
import 'package:flutter/material.dart';

import 'config/constants.dart';
import 'config/messages.dart';

const String LOGGER_NAME = 'mobile.fema';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    dev.log('constants.api_url....: ${Constants.API_URL}', name: LOGGER_NAME);
    dev.log('messages.app_name....: ${Messages.APP_NAME}', name: LOGGER_NAME);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.light()),
      home: HomeScreen(),
    );
  }
}
