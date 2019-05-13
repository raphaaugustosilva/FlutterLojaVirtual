import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/carrinho.dart';

class DescontoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.card_giftcard),
        //trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite seu cupom"),
              initialValue: Carrinho.of(context).cupomDesconto ?? "",
              onFieldSubmitted: (cupomDigitado) {
                Firestore.instance
                    .collection("cupons")
                    .document(cupomDigitado)
                    .get()
                    .then((cupomRetornado) {
                  if (cupomRetornado.data != null) {
                    Carrinho.of(context).aplicarCupomDesconto(cupomDigitado, cupomRetornado.data["percentual"]);

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Desconto de ${cupomRetornado.data["percentual"]}% aplicado!"),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  } else {
                    Carrinho.of(context).aplicarCupomDesconto(null, 0);

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Cupom não existente!"),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
