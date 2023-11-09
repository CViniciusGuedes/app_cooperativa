import 'dart:convert';
import 'dart:developer' as dev;
import 'package:app_cooperativa/database/cadastro_usuarioDB.dart';
import 'package:app_cooperativa/database/cadastro_usuario_repository.dart';
import 'package:app_cooperativa/database/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({
    super.key,
    required this.id,
  }) : update = id != null;

  final String? id;
  final bool update;

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
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

  Usuario _getFormData() {
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

    return Usuario(
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

  Future<Usuario> _saveUsuario(Usuario usuario) async {
    await UsuarioRepository(DatabaseHelper.instance).add(usuario);
    return usuario;
  }

  void _loadUsuario(String? id) async {
    if (id == null) {
      return;
    }
    Usuario? usuario = await UsuarioRepository(DatabaseHelper.instance).findById(id);

    if (usuario != null) {
      idController.text = usuario.id!;
      nameController.text = usuario.nome;
      cpfController.text = usuario.cpf;
      emailController.text = usuario.email;
      phoneController.text = usuario.celular;
      cepController.text = usuario.cep;
      estadoController.text = usuario.estado;
      cidadeController.text = usuario.cidade;
      logradouroController.text = usuario.logradouro;
      numeroController.text = usuario.numero;
      bairroController.text = usuario.bairro;
    }
  }

  String resultado = 'Cep';

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
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Cadastro de Usuário',
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
                        validator: (text) {
                          final exp = RegExp(r"^\([1-9]{2}\) (?:[2-8]|9[0-9])[0-9]{3}\-[0-9]{4}$");
                          if (!exp.hasMatch(text ?? '')) {
                            return 'Telefone Inválido';
                          }
                          return null;
                        },
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
                        validator: (text) {
                          final exp = RegExp(r'^\d{5}-\d{3}$');
                          if (!exp.hasMatch(text ?? '')) {
                            return 'CEP Inválido';
                          }
                          return null;
                        },
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
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        final Usuario usuario = _getFormData();
                        await _saveUsuario(usuario);
                        dev.log('${widget.update}');

                        if (widget.update) {
                          //snackbar
                        } else {
                          //snackbar
                        }

                        dev.log('$usuario', name: '');
                        Navigator.of(context).pop();
                      },
                      child: const Text(
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
