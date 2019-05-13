import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Usuario extends Model {
  FirebaseAuth _autenticador = FirebaseAuth.instance;

  FirebaseUser usuarioFirebase;
  Map<String, dynamic> dadosUsuario = Map();

  bool estaCarregando = false;

  static Usuario of(BuildContext context) => ScopedModel.of<Usuario>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _carregaUsuarioAtual();
  }

  //usuario atual
  void cadastrar(
      {@required Map<String, dynamic> dadosUsuario,
      @required String senha,
      @required VoidCallback sucessoCallback,
      @required VoidCallback falhaCallback}) async {
    estaCarregando = true;
    notifyListeners();

    _autenticador
        .createUserWithEmailAndPassword(
            email: dadosUsuario["email"], password: senha)
        .then((usuario) async {
      usuarioFirebase = usuario;

      await _salvaDadosUsuario(dadosUsuario);

      sucessoCallback();

      estaCarregando = false;
      notifyListeners();
    }).catchError((erro) {
      falhaCallback();
      estaCarregando = false;
      notifyListeners();
    });
  }

  void efetuarLogin(
      {@required String email,
      @required String senha,
      @required VoidCallback sucessoCallback,
      @required VoidCallback falhaCallback}) async {
    estaCarregando = true;
    notifyListeners();

    await _autenticador
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((usuario) async {
      usuarioFirebase = usuario;
      
      await _carregaUsuarioAtual();

      sucessoCallback();

      estaCarregando = false;
      notifyListeners();
    }).catchError((erro) {
      falhaCallback();
      estaCarregando = false;
      notifyListeners();
    });
  }

  void efetuarLogout() async {
    await _autenticador.signOut();

    dadosUsuario = Map();
    usuarioFirebase = null;

    notifyListeners();
  }

  void recuperarSenha(String email) {
    _autenticador.sendPasswordResetEmail(email: email);
  }

  bool estaLogado() {
    return usuarioFirebase != null;
  }

  Future<Null> _salvaDadosUsuario(Map<String, dynamic> dadosUsuario) async {
    this.dadosUsuario = dadosUsuario;
    await Firestore.instance
        .collection("usuarios")
        .document(usuarioFirebase.uid)
        .setData((dadosUsuario));
  }

  Future<Null> _carregaUsuarioAtual() async {
    if (usuarioFirebase == null)
      usuarioFirebase = await _autenticador.currentUser();

    if (usuarioFirebase != null) {
      if (dadosUsuario["nome"] == null) {
        DocumentSnapshot documentUsuario = await Firestore.instance
            .collection("usuarios")
            .document(usuarioFirebase.uid)
            .get();
        dadosUsuario = documentUsuario.data;
      }      
    }

    notifyListeners();
  }
}
