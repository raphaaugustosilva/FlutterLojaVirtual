import 'package:flutter/material.dart';
import 'package:loja_virtual/model/carrinho.dart';
import 'package:loja_virtual/model/usuario.dart';
import 'package:loja_virtual/ui/screens/paginaPrincipal.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<Usuario>(
        model: Usuario(),
        child: ScopedModelDescendant<Usuario>(
          builder: (context, child, model) {
            return ScopedModel<Carrinho>(
              model: Carrinho(model),
              child: MaterialApp(
                title: "Flutter's Clothing",
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    primaryColor: Color.fromARGB(255, 4, 125, 141)),
                debugShowCheckedModeBanner: false,
                home: PaginaPrincipal(),
              ),
            );
          },
        ));
  }
}
