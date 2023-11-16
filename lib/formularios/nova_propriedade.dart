import 'package:app_cooperativa/database/database_helper.dart';
import 'package:app_cooperativa/database/propriedadeDB.dart';
import 'package:app_cooperativa/database/propriedade_repository.dart';
import 'package:app_cooperativa/widgets/snackbar_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

const String LOGGER_NAME = 'mobile.coop';

class NovaPropriedade extends StatefulWidget {
  const NovaPropriedade({super.key, required this.id}) : update = id != null;

  final String? id;
  final bool update;

  @override
  State<NovaPropriedade> createState() => _NovaPropriedadeState();
}

class _NovaPropriedadeState extends State<NovaPropriedade> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController ufController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  // TextEditingController tipoSoloController = TextEditingController();

  Propriedade _getFormData() {
    final String id = idController.text;
    final String nome = nomeController.text;
    final String endereco = enderecoController.text;
    final String bairro = bairroController.text;
    final String cidade = cidadeController.text;
    final String uf = ufController.text;
    final String area = areaController.text;
    // final String tipoSolo = tipoSoloController.text;

    return Propriedade(id: id == '' ? null : id, nome: nome, endereco: endereco, bairro: bairro, cidade: cidade, uf: uf, area: area);
  }

  Future<Propriedade> _savePropriedade(Propriedade propriedade) async {
    await PropriedadeRepository(DatabaseHelper.instance).add(propriedade);
    return propriedade;
  }

  void _loadPropriedade(String? id) async {
    if (id == null) {
      return;
    }
    Propriedade? propriedade = await PropriedadeRepository(DatabaseHelper.instance).findById(id);

    if (propriedade != null) {
      idController.text = propriedade.id!;
      nomeController.text = propriedade.nome;
      enderecoController.text = propriedade.endereco;
      bairroController.text = propriedade.bairro;
      cidadeController.text = propriedade.cidade;
      ufController.text = propriedade.uf;
      areaController.text = propriedade.area;
      // tipoSoloController.text = propriedade.tipoSolo;
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadPropriedade(widget.id);

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Propriedade',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: SafeArea(
            child: SizedBox(
              height: 750,
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Dados da Propriedade',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          final exp = RegExp(r'^[a-zA-Z\s]+$');
                          if (!exp.hasMatch(text ?? '')) {
                            return 'Nome Inválida';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: nomeController,
                        textCapitalization: TextCapitalization.words,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nome',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (text) {
                        //   final exp = RegExp(r'^[a-zA-Z\s]+$');
                        //   if (!exp.hasMatch(text ?? '')) {
                        //     return 'Modelo Inválido';
                        //   }
                        //   return null;
                        // },
                        keyboardType: TextInputType.text,
                        controller: enderecoController,
                        textCapitalization: TextCapitalization.words,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Endereço',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (text) {
                        //   final exp = RegExp(r'^[a-zA-Z\s]+$');
                        //   if (!exp.hasMatch(text ?? '')) {
                        //     return 'Modelo Inválido';
                        //   }
                        //   return null;
                        // },
                        keyboardType: TextInputType.text,
                        controller: bairroController,
                        textCapitalization: TextCapitalization.words,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Bairro',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (text) {
                        //   final exp = RegExp(r'^[a-zA-Z\s]+$');
                        //   if (!exp.hasMatch(text ?? '')) {
                        //     return 'Modelo Inválido';
                        //   }
                        //   return null;
                        // },
                        keyboardType: TextInputType.text,
                        controller: cidadeController,
                        textCapitalization: TextCapitalization.words,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cidade',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (text) {
                        //   final exp = RegExp(r'^[a-zA-Z\s]+$');
                        //   if (!exp.hasMatch(text ?? '')) {
                        //     return 'Modelo Inválido';
                        //   }
                        //   return null;
                        // },
                        keyboardType: TextInputType.text,
                        controller: ufController,
                        textCapitalization: TextCapitalization.words,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'UF',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (text) {
                        //   final exp = RegExp(r'^[a-zA-Z\s]+$');
                        //   if (!exp.hasMatch(text ?? '')) {
                        //     return 'Modelo Inválido';
                        //   }
                        //   return null;
                        // },
                        keyboardType: TextInputType.number,
                        controller: areaController,
                        textCapitalization: TextCapitalization.words,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Area',
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: TextFormField(
                    //     autovalidateMode: AutovalidateMode.onUserInteraction,
                    //     // validator: (text) {
                    //     //   final exp = RegExp(r'^[a-zA-Z\s]+$');
                    //     //   if (!exp.hasMatch(text ?? '')) {
                    //     //     return 'Modelo Inválido';
                    //     //   }
                    //     //   return null;
                    //     // },
                    //     keyboardType: TextInputType.text,
                    //     controller: tipoSoloController,
                    //     textCapitalization: TextCapitalization.words,
                    //     textAlign: TextAlign.start,
                    //     decoration: const InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       labelText: 'Tipo Solo',
                    //     ),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () async {
                        final Propriedade propriedade = _getFormData();

                        await _savePropriedade(propriedade);

                        dev.log('${widget.update}');

                        if (widget.update) {
                          SnackbarNotificationWidget.info(context, 'Ok', 'Propriedade atualizada com sucesso!');
                        } else {
                          SnackbarNotificationWidget.info(context, 'Ok', 'Propriedade inserida com sucesso!');
                        }

                        dev.log('$propriedade', name: LOGGER_NAME);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ]
                      .map(
                        (widget) => Padding(
                          padding: EdgeInsets.all(8.0),
                          child: widget,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
