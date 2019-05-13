import 'package:flutter/material.dart';
import 'package:loja_virtual/model/usuario.dart';
import 'package:loja_virtual/ui/screens/criarContaScreen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controladorEmail = TextEditingController();
  final _controladorSenha = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text("CRIAR CONTA", style: TextStyle(fontSize: 15)),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (contexto) => CriarContaScreen()));
              },
            )
          ],
        ),
        body: ScopedModelDescendant<Usuario>(
          builder: (contexto, child, model) {
            if (model.estaCarregando)
              return Center(child: CircularProgressIndicator());
            else
              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    TextFormField(
                      controller: _controladorEmail,
                      decoration: InputDecoration(hintText: "E-mail"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (texto) {
                        if (texto.isEmpty || !texto.contains("@"))
                          return "E-mail inválido!";
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _controladorSenha,
                      decoration: InputDecoration(hintText: "Senha"),
                      obscureText: true,
                      validator: (texto) {
                        if (texto.isEmpty || texto.length < 3)
                          return "Senha inválida!";
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          if (_controladorEmail.text.isEmpty)
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Insira seu e-mail para redefinição de senha!"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          else {
                            model.recuperarSenha(_controladorSenha.text);
                            
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Confira seu e-mail!"),
                                backgroundColor: Theme.of(context).primaryColor,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Esqueci minha senha",
                          textAlign: TextAlign.right,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        child: Text("Entrar", style: TextStyle(fontSize: 18)),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            model.efetuarLogin(
                                email: _controladorEmail.text,
                                senha: _controladorSenha.text,
                                sucessoCallback: _usuarioLoginSucesso,
                                falhaCallback: _falhaAoLoginUsuario);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
          },
        ));
  }

  void _usuarioLoginSucesso() {
    Navigator.of(context).pop();
  }

  void _falhaAoLoginUsuario() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao entrar!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
