import 'package:app_cooperativa/database/database_helper.dart';
import 'package:app_cooperativa/database/http_sync/producao_http_sync.dart';
import 'package:app_cooperativa/database/producaoDB.dart';
import 'package:app_cooperativa/database/producao_repository.dart';
import 'package:app_cooperativa/formularios/producao_cadastro.dart';
import 'package:app_cooperativa/widgets/alert_dialog.dart';
import 'package:app_cooperativa/widgets/snackbar_notification.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

const String LOGGER_NAME = 'mobile.coop';

class ProducaoList extends StatefulWidget {
  const ProducaoList({super.key});

  @override
  State<ProducaoList> createState() => _ProducaoListState();
}

class _ProducaoListState extends State<ProducaoList> {
  List<Producao> _producao = [];
  bool _producaoCarregados = false;

  @override
  void initState() {
    super.initState();
    if (!_producaoCarregados) {
      _loadProducao();
      _producaoCarregados = true;
    }
  }

  void _syncProducao() async {
    try {
      final List<Producao> producao = await ProducaoHttpSync.get();

      await ProducaoRepository(DatabaseHelper.instance).deleteAll();
      await ProducaoRepository(DatabaseHelper.instance).addAll(producao);
      _refreshProducao();
    } catch (e) {
      dev.log('error $e', name: LOGGER_NAME);
    }
  }

  void _loadProducao() async {
    final List<Producao> cachedProducao = [
      // Producao(
      //   nome: 'Cevada',
      //   descricao: 'Cevada Amarela',
      //   preco: '50',
      //   tipo: 'Grão',
      // ),
    ];

    await ProducaoRepository(DatabaseHelper.instance).addAll(cachedProducao);
    _refreshProducao();
  }

  void _refreshProducao() async {
    final List<Producao> producao = await ProducaoRepository(DatabaseHelper.instance).findAll();
    setState(() {
      _producao = producao;
      dev.log('$producao', name: LOGGER_NAME);
    });
  }

  void _editById(String id) async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => ProducaoCadastro(
              id: id,
            ),
          ),
        )
        .then(
          (_) => _refreshProducao(),
        );
  }

  void _deleteById(String id) async {
    AlertDialogWidget.show(
      context,
      'Atenção',
      'Confirma Exclusão da Produção?',
      onConfirm: () async {
        try {
          dev.log('Remoção de produção confirmada...');
          final Producao? producao = await ProducaoRepository(DatabaseHelper.instance).findById(id);
          final Producao producaoRemovida = await ProducaoHttpSync.delete(producao!.nome);
          dev.log('Removido (API)...:$producaoRemovida', name: LOGGER_NAME);
          await ProducaoRepository(DatabaseHelper.instance).deleteById(id);
          SnackbarNotificationWidget.error(context, 'Ok', 'Produção removida com sucesso!');
          _refreshProducao();
        } catch (e) {
          dev.log('error $e', name: LOGGER_NAME);
        }
      },
      onCancel: () async {
        dev.log('Remoção de Produção Cancelada');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Produção',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () async {
              dev.log('actions.refresh', name: LOGGER_NAME);
              // _loadProducao();
              _syncProducao();
              _refreshProducao();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              dev.log('actions.add', name: LOGGER_NAME);
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => ProducaoCadastro(
                            id: null,
                          )))
                  .then(
                    (_) => _refreshProducao(),
                  );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: GridView.builder(
          itemCount: _producao.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 200 / 220,
          ),
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {},
              child: Card(
                child: Column(
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 130,
                    //     width: 180,
                    //     decoration: BoxDecoration(image: Deco),
                    //   ),
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
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
                                  _producao[i].nome,
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
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'Descrição: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _producao[i].descricao,
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
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'Preço: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _producao[i].preco,
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
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text(
                                  'Tipo: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _producao[i].tipo,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        SizedBox(
                          width: 96,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  dev.log('actions.trash', name: LOGGER_NAME);
                                  await ProducaoRepository(DatabaseHelper.instance).deleteById(_producao[i].id!);
                                  _refreshProducao();
                                },
                              ),
                              IconButton(
                                onPressed: () => _editById(_producao[i].id!),
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
