import 'package:flutter/material.dart';
import 'package:loja_virtual/model/usuario.dart';
import 'package:scoped_model/scoped_model.dart';

class CriarContaScreen extends StatefulWidget {
  @override
  _CriarContaScreenState createState() => _CriarContaScreenState();
}

class _CriarContaScreenState extends State<CriarContaScreen> {
  final _controladorNome = TextEditingController();
  final _controladorEmail = TextEditingController();
  final _controladorSenha = TextEditingController();
  final _controladorEndereco = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<Usuario>(
        builder: (context, child, model) {
          if (model.estaCarregando)
            return Center(child: CircularProgressIndicator());

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                TextFormField(
                  controller: _controladorNome,
                  decoration: InputDecoration(hintText: "Nome completo"),
                  validator: (texto) {
                    if (texto.isEmpty) return "Nome inválido!";
                  },
                ),
                SizedBox(height: 16),
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
                      return "Preencha a senha com no mínimo 3 caracteres!";
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _controladorEndereco,
                  decoration: InputDecoration(hintText: "Endereço"),
                  validator: (texto) {
                    if (texto.isEmpty) return "Endereço inválido!";
                  },
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    child: Text("Criar Conta", style: TextStyle(fontSize: 18)),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> dadosUsuario = {
                          "nome": _controladorNome.text,
                          "email": _controladorEmail.text,
                          "endereco": _controladorEndereco.text,
                        };

                        model.cadastrar(
                          dadosUsuario: dadosUsuario,
                          senha: _controladorSenha.text,
                          sucessoCallback: _usuarioCriadoSucesso,
                          falhaCallback: _falhaAoCriarUsuario,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _usuarioCriadoSucesso() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuário criado com sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _falhaAoCriarUsuario() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao criar usuário!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
