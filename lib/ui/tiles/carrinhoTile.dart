import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/carrinho.dart';
import 'package:loja_virtual/model/produto.dart';
import 'package:loja_virtual/model/produtoCarrinho.dart';

class CarrinhoTile extends StatelessWidget {
  final ProdutoCarrinho produtoCarrinho;

  CarrinhoTile(this.produtoCarrinho);

  @override
  Widget build(BuildContext context) {
    Widget _constroiCarrinhoTile() {
      
      Carrinho.of(context).atualizarTotal();

      return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          width: 120,
          child: Image.network(produtoCarrinho.produto.imagens[0],
              fit: BoxFit.cover),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(produtoCarrinho.produto.titulo,
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                Text("Plataforma: ${produtoCarrinho.plataforma}",
                    style: TextStyle(fontWeight: FontWeight.w300)),
                Text("R\$: ${produtoCarrinho.produto.preco.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: produtoCarrinho.quantidade > 1 ? () {
                          Carrinho.of(context).decrementarQuantidade(produtoCarrinho);
                        } : null),
                    Text(produtoCarrinho.quantidade.toString()),
                    IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Carrinho.of(context).incrementarQuantidade(produtoCarrinho);
                        }),
                    FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: () {
                          Carrinho.of(context).removerItemCarrinho(produtoCarrinho);
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ]);
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: produtoCarrinho.produto == null
            ? FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection("produtos")
                    .document(produtoCarrinho.categoria)
                    .collection("itens")
                    .document(produtoCarrinho.produtoId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    produtoCarrinho.produto =
                        Produto.fromDocument(snapshot.data);
                    return _constroiCarrinhoTile();
                  } else {
                    return Container(
                        height: 70,
                        child: CircularProgressIndicator(),
                        alignment: Alignment.center);
                  }
                },
              )
            : _constroiCarrinhoTile());
  }
}
