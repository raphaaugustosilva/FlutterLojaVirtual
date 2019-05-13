import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/tipoVisualizacao.dart';
import 'package:loja_virtual/model/produto.dart';
import 'package:loja_virtual/ui/tiles/produtoTile.dart';

class CategoriaScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoriaScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["titulo"]),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.grid_on),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("produtos")
              .document(snapshot.documentID)
              .collection("itens")
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  GridView.builder(
                    padding: EdgeInsets.all(4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, indice) {
                      Produto produto =
                          Produto.fromDocument(snapshot.data.documents[indice]);
                          produto.categoria = this.snapshot.documentID;

                      return ProdutoTile(TipoVisualizacao.grid, produto);
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(4),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, indice) {
                      Produto produto =
                          Produto.fromDocument(snapshot.data.documents[indice]);
                          produto.categoria = this.snapshot.documentID;

                      return ProdutoTile(TipoVisualizacao.lista, produto);
                    },
                  )
                ],
              );
          },
        ),
      ),
    );
  }
}
