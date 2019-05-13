import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/usuario.dart';
import 'package:loja_virtual/ui/screens/loginScreen.dart';
import 'package:loja_virtual/ui/tiles/pedidoTile.dart';

class AbaPedidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Usuario.of(context).estaLogado()) {
      String usuarioId = Usuario.of(context).usuarioFirebase.uid;
      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("usuarios")
            .document(usuarioId)
            .collection("pedidos")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else {
            return ListView(
              children: snapshot.data.documents.map((pedido) => PedidoTile(pedido.documentID)).toList().reversed.toList(),
            );
          }
        },
      );
    } else {
      var raisedButton = RaisedButton(
        child: Text("Entrar", style: TextStyle(fontSize: 18)),
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        },
      );
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list,
                size: 80, color: Theme.of(context).primaryColor),
            SizedBox(height: 16),
            Text("Faça o login para acompanhar!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            SizedBox(height: 16),
            raisedButton,
          ],
        ),
      );
    }
  }
}
