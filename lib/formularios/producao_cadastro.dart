import 'package:app_cooperativa/database/database_helper.dart';
import 'package:app_cooperativa/database/http_sync/producao_http_sync.dart';
import 'package:app_cooperativa/database/producaoDB.dart';
import 'package:app_cooperativa/database/producao_repository.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import '../widgets/snackbar_notification.dart';

const String LOGGER_NAME = 'mobile.coop';

class ProducaoCadastro extends StatefulWidget {
  const ProducaoCadastro({super.key, required this.id}) : update = id != null;

  final String? id;
  final bool update;

  @override
  State<ProducaoCadastro> createState() => _ProducaoCadastroState();
}

class _ProducaoCadastroState extends State<ProducaoCadastro> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController precoController = TextEditingController();
  TextEditingController tipoController = TextEditingController();

  final dropValue = ValueNotifier('');
  final dropTipo = [
    'Grão',
    'Farelo',
    'Líquido',
    'Ração',
    'Silagem',
  ];

  Producao _getFormData() {
    final String id = idController.text;
    final String nome = nomeController.text;
    final String descricao = descricaoController.text;
    final String preco = precoController.text;
    final String tipo = tipoController.text;

    return Producao(id: id == '' ? null : id, nome: nome, descricao: descricao, preco: preco, tipo: tipo);
  }

  Future<Producao> _saveProducao(Producao producao) async {
    await ProducaoRepository(DatabaseHelper.instance).add(producao);
    return producao;
  }

  void _loadProducao(String? id) async {
    if (id == null) {
      return;
    }
    Producao? producao = await ProducaoRepository(DatabaseHelper.instance).findById(id);

    if (producao != null) {
      idController.text = producao.id!;
      nomeController.text = producao.nome;
      descricaoController.text = producao.descricao;
      precoController.text = producao.preco;
      tipoController.text = producao.tipo;
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadProducao(widget.id);
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Produção',
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
                      'Dados da Produção',
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
                          return 'Nome Inválido';
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
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (text) {
                        final exp = RegExp(r'^[a-zA-Z\s]+$');
                        if (!exp.hasMatch(text ?? '')) {
                          return 'Descrição Inválida';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      controller: descricaoController,
                      textCapitalization: TextCapitalization.words,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descrição',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (text) {
                        final exp = RegExp(r'^[1-9]\d{0,2}(?:,?\d{3})*(?:\.\d{2})?$');

                        if (!exp.hasMatch(text ?? '')) {
                          return 'Preço inválido';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: precoController,
                      textCapitalization: TextCapitalization.words,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Preço',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder(
                        valueListenable: dropValue,
                        builder: (BuildContext context, String value, _) {
                          return SizedBox(
                            child: DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecione um Tipo';
                                }
                                return null;
                              },
                              isExpanded: true,
                              hint: const Text(
                                'Tipo',
                                textAlign: TextAlign.center,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              value: (value.isEmpty) ? null : value,
                              onChanged: (escolha) {
                                dropValue.value = escolha.toString();
                                tipoController.text = escolha.toString();
                              },
                              items: dropTipo
                                  .map((op) => DropdownMenuItem(
                                        value: op,
                                        child: Text(op),
                                      ))
                                  .toList(),
                            ),
                          );
                        }),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      dev.log('actions.save', name: LOGGER_NAME);

                      final Producao producao = _getFormData();

                      if (widget.update) {
                        final Producao producaoAtualizada = await ProducaoHttpSync.put(producao: producao);
                        dev.log('Atualizando (API)...: $producaoAtualizada', name: LOGGER_NAME);
                      } else {
                        final Producao producaoInserida = await ProducaoHttpSync.post(producao: producao);
                        dev.log('Inserido (API)...:$producaoInserida', name: LOGGER_NAME);
                      }

                      await _saveProducao(producao);

                      dev.log('${widget.update}');

                      if (widget.update) {
                        SnackbarNotificationWidget.info(context, 'Ok', 'Produção atualizada com sucesso!');
                      } else {
                        SnackbarNotificationWidget.info(context, 'Ok', 'Produção inserida com sucesso!');
                      }

                      dev.log('$producao', name: LOGGER_NAME);
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
          )),
        ),
      ),
    );
  }
}
