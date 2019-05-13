import 'package:flutter/material.dart';
import 'package:loja_virtual/model/usuario.dart';
import 'package:loja_virtual/ui/screens/loginScreen.dart';
import 'package:loja_virtual/ui/tiles/itemMenuDrawer.dart';
import 'package:scoped_model/scoped_model.dart';

class DrawerCustomizado extends StatelessWidget {
  final PageController controladorPaginaPrincipal;

  DrawerCustomizado(this.controladorPaginaPrincipal);

  @override
  Widget build(BuildContext context) {
    Widget _constroiBackgroundDoDrawer() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 203, 236, 241),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _constroiBackgroundDoDrawer(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        "Rapha Games \nStore",
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: ScopedModelDescendant<Usuario>(
                          builder: (context, child, model) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Olá, ${!model.estaLogado() ? "" : model.dadosUsuario["nome"]}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  child: Text(
                                    !model.estaLogado()
                                        ? "Entre ou cadastre-se >"
                                        : "Sair",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    if (!model.estaLogado())
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (contexto) =>
                                                  LoginScreen()));
                                    else
                                      model.efetuarLogout();
                                  },
                                ),
                              ],
                            );
                          },
                        ))
                  ],
                ),
              ),
              Divider(),
              ItemMenuDrawer(
                  Icons.home, "Início", controladorPaginaPrincipal, 0),
              ItemMenuDrawer(
                  Icons.list, "Produtos", controladorPaginaPrincipal, 1),
              ItemMenuDrawer(
                  Icons.location_on, "Lojas", controladorPaginaPrincipal, 2),
              ItemMenuDrawer(Icons.playlist_add_check, "Meus Pedidos",
                  controladorPaginaPrincipal, 3),
            ],
          ),
        ],
      ),
    );
  }
}
