import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/ui/tiles/categoriaTile.dart';

class AbaProdutos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("produtos").getDocuments(),
      builder: (contexto, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          
          //Linha de divisão entre cada item da listview
          var tilesDivididos = ListTile.divideTiles(
                  tiles: snapshot.data.documents.map((documento) {
                    return CategoriaTile(documento);
                  }).toList(),
                  color: Colors.grey[500])
              .toList();

          return ListView(children: tilesDivididos);
        }
      },
    );
  }
}
