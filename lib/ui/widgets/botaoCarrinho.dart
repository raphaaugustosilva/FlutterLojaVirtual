import 'package:flutter/material.dart';
import 'package:loja_virtual/ui/screens/carrinhoScreen.dart';

class BotaoCarrinho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CarrinhoScreen()));
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
