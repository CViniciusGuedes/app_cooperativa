import 'package:app_cooperativa/formularios/usuario_cadastro.dart';
import 'package:app_cooperativa/screens/propriedade_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PainelWidget extends StatefulWidget {
  const PainelWidget({super.key});

  @override
  State<PainelWidget> createState() => _PainelWidgetState();
}

class _PainelWidgetState extends State<PainelWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          crossAxisCount: 3,
          children: <Widget>[
            SizedBox(
              height: 150,
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: SvgPicture.asset(
                            'assets/images/soy.svg',
                            width: 45,
                            colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      Text(
                        'Produção',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropriedadeList(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: SvgPicture.asset(
                            'assets/images/farm.svg',
                            width: 40,
                            colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      Text(
                        'Gerenciar Propriedades',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroUsuario(
                        id: '',
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: SvgPicture.asset(
                            'assets/images/farmer.svg',
                            width: 40,
                            colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      Text(
                        'Cooperados',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Icon(
                            CupertinoIcons.cloud_sun_bolt_fill,
                            color: Colors.green,
                            size: 35,
                          ),
                        ),
                      ),
                      Text(
                        'Meteorologia',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Icon(
                            // Icons.request_page_outlined,
                            Icons.price_change,
                            color: Colors.green,
                            size: 35,
                          ),
                        ),
                      ),
                      Text(
                        'Cotações',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Icon(
                            Icons.picture_as_pdf_rounded,
                            color: Colors.green,
                            size: 35,
                          ),
                        ),
                      ),
                      Text(
                        'Relatórios',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
