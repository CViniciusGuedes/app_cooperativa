import 'dart:convert';
import 'dart:developer' as dev;
import 'package:app_cooperativa/database/cadastro_cooperadoDB.dart';
import 'package:app_cooperativa/database/cadastro_cooperado_repository.dart';
import 'package:app_cooperativa/database/database_helper.dart';
import 'package:app_cooperativa/database/http_sync/cooperado_http_sync.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../widgets/snackbar_notification.dart';

const String LOGGER_NAME = 'mobile.coop';

class CadastroCooperado extends StatefulWidget {
  const CadastroCooperado({
    super.key,
    required this.id,
  }) : update = id != null;

  final String? id;
  final bool update;

  @override
  State<CadastroCooperado> createState() => _CadastroCooperadoState();
}

class _CadastroCooperadoState extends State<CadastroCooperado> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController logradouroController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();

  Cooperado _getFormData() {
    final String id = idController.text;
    final String nome = nameController.text;
    final String cpf = cpfController.text;
    final String email = emailController.text;
    final String celular = phoneController.text;
    final String cep = cepController.text;
    final String estado = estadoController.text;
    final String cidade = cidadeController.text;
    final String logradouro = logradouroController.text;
    final String numero = numeroController.text;
    final String bairro = bairroController.text;

    return Cooperado(
      id: id == '' ? null : id,
      nome: nome,
      cpf: cpf,
      email: email,
      celular: celular,
      cep: cep,
      estado: estado,
      cidade: cidade,
      logradouro: logradouro,
      numero: numero,
      bairro: bairro,
    );
  }

  Future<Cooperado> _saveCooperado(Cooperado cooperado) async {
    await CooperadoRepository(DatabaseHelper.instance).add(cooperado);
    return cooperado;
  }

  void _loadCooperado(String? id) async {
    if (id == null) {
      return;
    }
    Cooperado? cooperado = await CooperadoRepository(DatabaseHelper.instance).findById(id);

    if (cooperado != null) {
      idController.text = cooperado.id!;
      nameController.text = cooperado.nome;
      cpfController.text = cooperado.cpf;
      emailController.text = cooperado.email;
      phoneController.text = cooperado.celular;
      cepController.text = cooperado.cep;
      estadoController.text = cooperado.estado;
      cidadeController.text = cooperado.cidade;
      logradouroController.text = cooperado.logradouro;
      numeroController.text = cooperado.numero;
      bairroController.text = cooperado.bairro;
    }
  }

  String resultado = 'Cep';

  // void buscaCep() async {
  //   String cep = cepController.text;
  //   String url = "https://viacep.com.br/ws/$cep/json/";

  //   Uri uri = Uri.parse(url);

  //   http.Response response;
  //   response = await http.get(uri);

  //   print("Resposta: " + response.body);
  //   print("Status Code: " + response.statusCode.toString());

  //   Map<String, dynamic>? dados = json.decode(response.body);

  //   if (dados != null) {
  //     String logradouro = dados["logradouro"] ?? ""; // Usando "logradouro" em vez de "logradouro"
  //     String bairro = dados["bairro"] ?? "";
  //     String localidade = dados["localidade"] ?? "";
  //     String uf = dados["uf"] ?? "";

  //     String endereco = "O endereço é: $localidade";

  //     setState(() {
  //       resultado = endereco;
  //       bairroController.text = bairro;
  //       estadoController.text = uf;
  //       cidadeController.text = localidade;
  //       logradouroController.text = logradouro;
  //     });
  //   } else {
  //     // Tratar o caso em que os dados são nulos
  //     print("Dados de endereço nulos");
  //   }
  // }

  void buscaCep() async {
    String cep = cepController.text;
    String url = "https://viacep.com.br/ws/$cep/json/";

    Uri uri = Uri.parse(url);

    http.Response response;
    response = await http.get(uri);

    print("Resposta: " + response.body);
    print("Status Code: " + response.statusCode.toString());

    Map<String, dynamic> dados = json.decode(response.body);

    String logradouro = dados["logradouro"];
    String bairro = dados["bairro"];
    String localidade = dados["localidade"];
    String uf = dados["uf"];

    String endereco = "O endereço é: $localidade";

    setState(() {
      resultado = endereco;
      bairroController.text = bairro;
      estadoController.text = uf;
      cidadeController.text = localidade;
      logradouroController.text = logradouro;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadCooperado(widget.id);
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Cadastro de Cooperado',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: SafeArea(
            child: Container(
              height: 750,
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                      child: Text(
                        'Dados Cadastrais',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                        controller: nameController,
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
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '###.###.###-##',
                            filter: {'#': RegExp(r'[0-9xX]')},
                            type: MaskAutoCompletionType.lazy,
                          ),
                        ],
                        validator: (text) {
                          final exp = RegExp(r"(\d{3})+\.?(\d{3})+\.?(\d{3})+-?([\dxX]{1,2})+");
                          if (!exp.hasMatch(text ?? '')) {
                            return 'CPF Inválido';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: cpfController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CPF',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          final exp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!exp.hasMatch(text ?? '')) {
                            return 'E-mail Inválido';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'E-mail',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '(##) #####-#####',
                            filter: {'#': RegExp(r'[0-9]')},
                            type: MaskAutoCompletionType.lazy,
                          ),
                        ],
                        // validator: (text) {
                        //   final exp = RegExp(r"^\([1-9]{2}\) (?:[2-8]|9[0-9])[0-9]{3}\-[0-9]{4}$");
                        //   if (!exp.hasMatch(text ?? '')) {
                        //     return 'Telefone Inválido';
                        //   }
                        //   return null;
                        // },
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Celular',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: cepController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CEP',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '#####-###',
                            filter: {'#': RegExp(r'[0-9]')},
                            type: MaskAutoCompletionType.lazy,
                          ),
                        ],
                        // validator: (text) {
                        //   final exp = RegExp(r'^\d{5}-\d{3}$');
                        //   if (!exp.hasMatch(text ?? '')) {
                        //     return 'CEP Inválido';
                        //   }
                        //   return null;
                        // },
                        onChanged: (text) {
                          if (text.length == 9) {
                            buscaCep();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return 'Insira o Estado';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: estadoController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Estado',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return 'Insira a Cidade';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: cidadeController,
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
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return 'Insira o Logradouro';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: logradouroController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Logradouro',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return 'Insira o Número';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: numeroController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Número',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return 'Insira o Bairro';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: bairroController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Bairro',
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     dev.log('actions.save', name: LOGGER_NAME);

                    //     final Cooperado cooperado = _getFormData();

                    //     if (widget.update) {
                    //       final Cooperado CooperadoAtualizado = await CooperadoHttpSync.put(cooperado: cooperado);
                    //       dev.log('Atualizando (API)...: $CooperadoAtualizado', name: LOGGER_NAME);
                    //     } else {
                    //       final Cooperado cooperadoInserido = await CooperadoHttpSync.post(cooperado: cooperado);
                    //       dev.log('Inserido (API)...: $cooperadoInserido', name: LOGGER_NAME);
                    //     }

                    //     await _saveCooperado(cooperado);

                    //     dev.log('${widget.update}');

                    //     if (widget.update) {
                    //       SnackbarNotificationWidget.info(context, 'Ok', 'Cooperado atualizada com sucesso!');
                    //     } else {
                    //       SnackbarNotificationWidget.info(context, 'Ok', 'Cooperado inserida com sucesso!');
                    //     }

                    //     dev.log('$cooperado', name: LOGGER_NAME);
                    //     Navigator.of(context).pop();
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.green,
                    //   ),
                    //   child: Text(
                    //     'Salvar',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () async {
                        dev.log('actions.save', name: LOGGER_NAME);

                        final Cooperado cooperado = _getFormData();

                        if (widget.update) {
                          final Cooperado cooperadoAtualizado = await CooperadoHttpSync.put(cooperado: cooperado);
                          dev.log('Atualizando (API)...: $cooperadoAtualizado', name: LOGGER_NAME);
                        } else {
                          final Cooperado cooperadoInserido = await CooperadoHttpSync.post(cooperado: cooperado);
                          dev.log('Inserido (API)...: $cooperadoInserido', name: LOGGER_NAME);
                        }

                        await _saveCooperado(cooperado);
                        dev.log('${widget.update}');

                        if (widget.update) {
                          SnackbarNotificationWidget.info(context, 'Ok', 'Cooperado Atualizado com sucesso!');
                        } else {
                          SnackbarNotificationWidget.info(context, 'Ok', 'Cooperado inserido com sucesso!');
                        }

                        dev.log('$cooperado', name: LOGGER_NAME);
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
                      .map((widget) => Padding(
                            padding: EdgeInsets.all(8.0),
                            child: widget,
                          ))
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
