import 'dart:developer' as dev;
import 'package:app_cooperativa/database/database_helper.dart';
import 'package:app_cooperativa/database/http_sync/propriedade_http_sync.dart';
import 'package:app_cooperativa/database/propriedade_repository.dart';
import 'package:app_cooperativa/formularios/nova_propriedade.dart';
import 'package:app_cooperativa/widgets/alert_dialog.dart';
import 'package:app_cooperativa/widgets/snackbar_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../database/propriedadeDB.dart';

const String LOGGER_NAME = 'mobile.coop';

class PropriedadeList extends StatefulWidget {
  const PropriedadeList({super.key});

  @override
  State<PropriedadeList> createState() => _PropriedadeListState();
}

class _PropriedadeListState extends State<PropriedadeList> {
  List<Propriedade> _propriedade = [];
  bool _propriedadesCarregados = false;

  @override
  void initState() {
    super.initState();
    if (!_propriedadesCarregados) {
      _loadPropriedades();
      _propriedadesCarregados = true;
    }
  }

  void _syncPropriedades() async {
    try {
      final List<Propriedade> propriedades = await PropriedadeHttpSync.get();

      await PropriedadeRepository(DatabaseHelper.instance).deleteAll();
      await PropriedadeRepository(DatabaseHelper.instance).addAll(propriedades);
      _refreshPropriedades();
    } catch (e) {
      dev.log('Error $e', name: LOGGER_NAME);
    }
  }

  void _loadPropriedades() async {
    final List<Propriedade> cachedPropriedades = [
      // Propriedade(
      //   nome: 'Fazenda Guedes',
      //   endereco: 'Estrada Vicinal 400',
      //   bairro: 'Bairro Dourados',
      //   cidade: 'Tarumã',
      //   uf: 'SP',
      //   area: '4.000²',
      //   // tipoSolo: 'Arenoso',
      // ),
      // Propriedade(
      //   nome: 'Fazenda Nova America',
      //   endereco: 'Estrada Vicinal 300',
      //   bairro: 'Aguá da Aldeia',
      //   cidade: 'Tarumã',
      //   uf: 'SP',
      //   area: '5.000²',
      //   // tipoSolo: 'Terra Roxa',
      // ),
      // Propriedade(
      //   nome: 'Sitio Moreira',
      //   endereco: 'Estrada Maracaí',
      //   bairro: 'Anhumas',
      //   cidade: 'Maracaí',
      //   uf: 'SP',
      //   area: '8.000²',
      //   // tipoSolo: 'Solo Arenoso',
      // )
    ];

    await PropriedadeRepository(DatabaseHelper.instance).addAll(cachedPropriedades);
    _refreshPropriedades();
  }

  void _refreshPropriedades() async {
    final List<Propriedade> propriedades = await PropriedadeRepository(DatabaseHelper.instance).findAll();

    setState(() {
      _propriedade = propriedades;
      dev.log('$propriedades', name: LOGGER_NAME);
    });
  }

  void _editById(String id) async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => NovaPropriedade(
              id: id,
            ),
          ),
        )
        .then((_) => _refreshPropriedades());
  }

  void _deleteById(String id) async {
    AlertDialogWidget.show(
      context,
      'Atenção',
      'Confirma Exclusão da Propriedade?',
      onConfirm: () async {
        try {
          dev.log('Remoção de Propriedade Confirmada...');
          final Propriedade? propriedade = await PropriedadeRepository(DatabaseHelper.instance).findById(id);
          final Propriedade propriedadeRemovida = await PropriedadeHttpSync.delete(propriedade!.nome);
          dev.log('Removido (API)...: $propriedadeRemovida', name: LOGGER_NAME);
          await PropriedadeRepository(DatabaseHelper.instance).deleteById(id);
          SnackbarNotificationWidget.error(context, 'Ok', 'Propriedade removida com sucesso!');
          _refreshPropriedades();
        } catch (e) {
          dev.log('error $e', name: LOGGER_NAME);
        }
      },
      onCancel: () async {
        dev.log('Remoção de Propriedade Cancelada');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Propriedades',
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
              // _loadPropriedades();
              _syncPropriedades();
              _refreshPropriedades();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              dev.log('actions.add', name: '');
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => NovaPropriedade(
                            id: null,
                          )))
                  .then(
                    (_) => _refreshPropriedades(),
                  );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: GridView.builder(
          itemCount: _propriedade.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 300 / 240,
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
                          image: const DecorationImage(image: AssetImage('assets/images/fazenda.jpg'), fit: BoxFit.cover),
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
                                  _propriedade[i].nome,
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
                                  'Endereço: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _propriedade[i].endereco,
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
                                  _propriedade[i].bairro,
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
                                  _propriedade[i].cidade,
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
                                  'UF: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _propriedade[i].uf,
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
                                  'Area: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _propriedade[i].area,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Row(
                        //       children: [
                        //         const Text(
                        //           'Tipo Solo: ',
                        //           style: TextStyle(
                        //             fontSize: 13,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //         Text(
                        //           _propriedade[i].tipoSolo,
                        //           style: const TextStyle(
                        //             fontSize: 13,
                        //             fontWeight: FontWeight.normal,
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        const Divider(),
                        SizedBox(
                          width: 96,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  dev.log('actions.trash', name: LOGGER_NAME);
                                  await PropriedadeRepository(DatabaseHelper.instance).deleteById(_propriedade[i].id!);
                                  _refreshPropriedades();
                                },
                              ),
                              IconButton(
                                onPressed: () => _editById(_propriedade[i].id!),
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                        )
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
