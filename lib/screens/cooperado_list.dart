import 'package:app_cooperativa/database/cadastro_cooperadoDB.dart';
import 'package:app_cooperativa/database/cadastro_cooperado_repository.dart';
import 'package:app_cooperativa/database/database_helper.dart';
import 'package:app_cooperativa/database/http_sync/cooperado_http_sync.dart';
import 'package:app_cooperativa/formularios/cooperado_cadastro.dart';
import 'package:app_cooperativa/widgets/alert_dialog.dart';
import 'package:app_cooperativa/widgets/snackbar_notification.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

const String LOGGER_NAME = 'mobile.coop';

class CooperadoList extends StatefulWidget {
  const CooperadoList({super.key});

  @override
  State<CooperadoList> createState() => _CooperadoListState();
}

class _CooperadoListState extends State<CooperadoList> {
  List<Cooperado> _cooperado = [];
  bool _cooperadosCarregados = false;

  @override
  void initState() {
    super.initState();
    if (!_cooperadosCarregados) {
      _loadCooperados();
      _cooperadosCarregados = true;
    }
  }

  void _syncCooperados() async {
    try {
      final List<Cooperado> cooperados = await CooperadoHttpSync.get();

      await CooperadoRepository(DatabaseHelper.instance).deleteAll();
      await CooperadoRepository(DatabaseHelper.instance).addAll(cooperados);
      _refreshCooperados();
    } catch (e) {
      dev.log('Error $e', name: LOGGER_NAME);
    }
  }

  void _loadCooperados() async {
    final List<Cooperado> cachedCooperados = [
      // Cooperado(
      //   nome: 'Carlos Guedes',
      //   cpf: '11122233344',
      //   email: 'carlos@gmail.com',
      //   celular: '18996818637',
      //   cep: '19822108',
      //   estado: 'SP',
      //   cidade: 'Taruma',
      //   logradouro: 'Jatoba',
      //   numero: '109',
      //   bairro: 'Arvores',
      // ),
    ];

    await CooperadoRepository(DatabaseHelper.instance).addAll(cachedCooperados);
    _refreshCooperados();
  }

  void _refreshCooperados() async {
    final List<Cooperado> cooperados = await CooperadoRepository(DatabaseHelper.instance).findAll();
    setState(() {
      _cooperado = cooperados;
      dev.log('$cooperados', name: LOGGER_NAME);
    });
  }

  void _editById(String id) async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => CadastroCooperado(
              id: id,
            ),
          ),
        )
        .then((_) => _refreshCooperados());
  }

  void _deleteById(String id) async {
    AlertDialogWidget.show(
      context,
      'Atenção',
      'Confirma Exclusão do Cooperado?',
      onConfirm: () async {
        try {
          dev.log('Remoção de Cooperado Confirmada...');
          final Cooperado? cooperado = await CooperadoRepository(DatabaseHelper.instance).findById(id);
          final Cooperado cooperadoRemovido = await CooperadoHttpSync.delete(cooperado!.cpf);
          dev.log('Removido (API)...: $cooperadoRemovido', name: LOGGER_NAME);
          await CooperadoRepository(DatabaseHelper.instance).deleteById(id);
          SnackbarNotificationWidget.error(context, 'Ok', 'Cooperado removido com sucesso!');

          _refreshCooperados();
        } catch (e) {
          dev.log('error $e', name: LOGGER_NAME);
        }
      },
      onCancel: () async {
        dev.log('Remoção de Cooperado Cancelada');
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Cooperados',
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              dev.log('actions.refresh', name: '');
              // _loadCooperados();
              _syncCooperados();
              _refreshCooperados();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              dev.log('actions.add', name: '');
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => CadastroCooperado(
                            id: null,
                          )))
                  .then(
                    (_) => _refreshCooperados(),
                  );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: GridView.builder(
          itemCount: _cooperado.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 300 / 310,
          ),
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {},
              child: Card(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 130,
                        width: 180,
                        decoration: BoxDecoration(
                          image: const DecorationImage(image: AssetImage('assets/images/agricultor.jpg'), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'Nome: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _cooperado[i].nome,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'CPF: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _cooperado[i].cpf,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'E-mail: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _cooperado[i].email,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'Celular: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _cooperado[i].celular,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'CEP: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _cooperado[i].cep,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'Estado: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _cooperado[i].estado,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'Cidade: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _cooperado[i].cidade,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'Logradouro: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _cooperado[i].logradouro,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'Número: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _cooperado[i].numero,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'Bairro: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _cooperado[i].bairro,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          width: 96,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  dev.log('actions.trash', name: LOGGER_NAME);
                                  await CooperadoRepository(DatabaseHelper.instance).deleteById(_cooperado[i].id!);
                                  _refreshCooperados();
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                              IconButton(
                                onPressed: () => _editById(_cooperado[i].id!),
                                icon: Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
