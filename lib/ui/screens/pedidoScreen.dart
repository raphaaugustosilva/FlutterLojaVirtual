import 'package:flutter/material.dart';

class PedidoScreen extends StatelessWidget {
  final String pedidoId;

  PedidoScreen(this.pedidoId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido relizado"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,          
          children: <Widget>[
            Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
              size: 80,
            ),
            Text("Pedido realizado com sucesso!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("Código do pedido: $pedidoId", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
