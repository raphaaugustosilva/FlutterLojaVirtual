import 'package:flutter/material.dart';
import 'package:loja_virtual/model/carrinho.dart';
import 'package:loja_virtual/model/usuario.dart';
import 'package:loja_virtual/ui/screens/loginScreen.dart';
import 'package:loja_virtual/ui/screens/pedidoScreen.dart';
import 'package:loja_virtual/ui/tiles/carrinhoTile.dart';
import 'package:loja_virtual/ui/widgets/descontoCard.dart';
import 'package:loja_virtual/ui/widgets/freteCard.dart';
import 'package:loja_virtual/ui/widgets/precoCarrinho.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 8),
              child: ScopedModelDescendant<Carrinho>(
                builder: (context, child, model) {
                  int tamanhoLista = model.produtos.length;
                  return Text(
                    "${tamanhoLista ?? 0} ${tamanhoLista == 1 ? "ITEM" : "ITENS"}",
                    style: TextStyle(fontSize: 17),
                  );
                },
              ))
        ],
      ),
      body: ScopedModelDescendant<Carrinho>(
        builder: (context, child, model) {
          if (model.estaCarregando && Usuario.of(context).estaLogado())
            return Center(child: CircularProgressIndicator());
          else if (!Usuario.of(context).estaLogado()) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart,
                      size: 80, color: Theme.of(context).primaryColor),
                  SizedBox(height: 16),
                  Text("Faça o login para adicionar produtos",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  SizedBox(height: 16),
                  RaisedButton(
                    child: Text("Entrar", style: TextStyle(fontSize: 18)),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                  ),
                ],
              ),
            );
          } else if (model.produtos == null || model.produtos.length == 0) {
            return Center(
                child: Text("Nenhum produto no carrinho",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center));
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.produtos.map((produto) {
                    return CarrinhoTile(produto);
                  }).toList(),
                ),
                DescontoCard(),
                FreteCard(),
                PrecoCarrinho(() async {
                  String pedidoId = await model.finalizarPedido();

                  if (pedidoId != null)
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PedidoScreen(pedidoId)));
                        
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
