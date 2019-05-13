import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/tipoVisualizacao.dart';
import 'package:loja_virtual/model/produto.dart';
import 'package:loja_virtual/ui/screens/produtoScreen.dart';

class ProdutoTile extends StatelessWidget {
  final TipoVisualizacao tipoVisualizacao;
  final Produto produto;

  ProdutoTile(this.tipoVisualizacao, this.produto);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProdutoScreen(produto)));
      },
      child: Card(
        child: tipoVisualizacao == TipoVisualizacao.grid
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(
                      produto.imagens[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Text(
                            produto.titulo,
                            style: TextStyle(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                            softWrap: false,
                          ),
                          Text(
                            "R\$ ${produto.preco.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Image.network(
                      produto.imagens[0],
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            produto.titulo,
                            style: TextStyle(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                            softWrap: false,
                          ),
                          Text(
                            "R\$ ${produto.preco.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
