import 'package:flutter/material.dart';
import 'package:loja_virtual/model/carrinho.dart';
import 'package:loja_virtual/model/produto.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:loja_virtual/model/produtoCarrinho.dart';
import 'package:loja_virtual/model/usuario.dart';
import 'package:loja_virtual/ui/screens/carrinhoScreen.dart';
import 'package:loja_virtual/ui/screens/loginScreen.dart';

class ProdutoScreen extends StatefulWidget {
  final Produto produto;

  ProdutoScreen(this.produto);

  @override
  _ProdutoScreenState createState() => _ProdutoScreenState(produto);
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  final Produto produto;
  String plataformaSelecionada;
  _ProdutoScreenState(this.produto);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(produto.titulo),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: produto.imagens.map((urlImagem) {
                return NetworkImage(urlImagem);
              }).toList(),
              dotSize: 4,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  produto.titulo,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${produto.preco.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(height: 16),
                Text(
                  "Plataformas",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.5),
                    children: produto.plataformas.map((plataforma) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            plataformaSelecionada = plataforma;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color: plataforma == plataformaSelecionada
                                      ? primaryColor
                                      : Colors.grey[500])),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(plataforma,
                              style: TextStyle(
                                  color: plataforma == plataformaSelecionada
                                      ? primaryColor
                                      : Colors.grey[500])),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: plataformaSelecionada != null
                        ? () {
                            if (Usuario.of(context).estaLogado()) {
                              //Adicionar ao carrinho
                              ProdutoCarrinho produtoCarrinho = ProdutoCarrinho();
                              produtoCarrinho.plataforma = plataformaSelecionada;
                              produtoCarrinho.quantidade = 1;
                              produtoCarrinho.produtoId = produto.id;
                              produtoCarrinho.categoria = produto.categoria;
                              produtoCarrinho.produto = produto;

                              Carrinho.of(context).adicionarItemCarrinho(produtoCarrinho);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CarrinhoScreen()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            }
                          }
                        : null,
                    child: Text(
                        Usuario.of(context).estaLogado()
                            ? "Adicionar ao carrinho"
                            : "Entre para comprar",
                        style: TextStyle(fontSize: 18)),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  produto.descricao,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
