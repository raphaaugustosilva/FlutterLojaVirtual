import 'package:flutter/material.dart';
import 'package:loja_virtual/ui/abas/abaHome.dart';
import 'package:loja_virtual/ui/abas/abaLojas.dart';
import 'package:loja_virtual/ui/abas/abaPedidos.dart';
import 'package:loja_virtual/ui/abas/abaProdutos.dart';
import 'package:loja_virtual/ui/widgets/botaoCarrinho.dart';
import 'package:loja_virtual/ui/widgets/drawerCustomizado.dart';

class PaginaPrincipal extends StatefulWidget {
  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  final _controladorPaginaPrincipal = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controladorPaginaPrincipal,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: AbaHome(),
          drawer: DrawerCustomizado(_controladorPaginaPrincipal),
          floatingActionButton: BotaoCarrinho(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: DrawerCustomizado(_controladorPaginaPrincipal),
          body: AbaProdutos(),
          floatingActionButton: BotaoCarrinho(),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Lojas"), centerTitle: true),
          body: AbaLojas(),
          drawer: DrawerCustomizado(_controladorPaginaPrincipal),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Meus Pedidos"), centerTitle: true),
          body: AbaPedidos(),
          drawer: DrawerCustomizado(_controladorPaginaPrincipal),
        ),
      ],
    );
  }
}
