import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PedidoTile extends StatelessWidget {
  final String pedidoId;
  PedidoTile(this.pedidoId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection("pedidos")
              .document(pedidoId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else {
              int statusPedido = snapshot.data["status"];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Código do pedido: ${snapshot.data.documentID}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(_constroiTextoProdutos(snapshot.data)),
                  SizedBox(height: 4),
                  Text("Status do pedido:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _constroiCirculoStatusPedido(
                          "1", "Preparação", statusPedido, 1),
                      Container(height: 1, width: 40, color: Colors.grey[500]),
                      _constroiCirculoStatusPedido(
                          "2", "Transporte", statusPedido, 2),
                      Container(height: 1, width: 40, color: Colors.grey[500]),
                      _constroiCirculoStatusPedido(
                          "3", "Entrega", statusPedido, 3),
                    ],
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _constroiTextoProdutos(DocumentSnapshot snapshot) {
    String retorno = "Descrição:\n";
    for (LinkedHashMap produto in snapshot.data["produtos"]) {
      retorno +=
          "${produto["quantidade"]} x ${produto["produtoResumido"]["titulo"]} (R\$ ${produto["produtoResumido"]["preco"].toStringAsFixed(2)})\n";
    }
    retorno += "Total: R\$ ${snapshot.data["totalPedido"]}";

    return retorno;
  }

  Widget _constroiCirculoStatusPedido(
      String titulo, String subtitulo, int status, int thisStatus) {
    Color corFundo;
    Widget conteudo;

    if (status < thisStatus) {
      corFundo = Colors.grey[500];
      conteudo = Text(titulo, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) {
      corFundo = Colors.blue;
      conteudo = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(titulo, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
        ],
      );
    } else {
      corFundo = Colors.green;
      conteudo = Icon(Icons.check, color: Colors.white,);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(radius: 20, backgroundColor: corFundo, child: conteudo),
        Text(subtitulo),
      ],
    );
  }
}
