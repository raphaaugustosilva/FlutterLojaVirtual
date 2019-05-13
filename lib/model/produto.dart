import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  
  Produto.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    titulo = snapshot.data["titulo"];
    descricao = snapshot.data["descricao"];
    preco = snapshot.data["preco"];
    imagens = snapshot.data["imagens"];
    plataformas = snapshot.data["plataformas"];
  }

  String categoria;
  String id;

  String titulo;
  String descricao;

  double preco;

  List imagens;
  List plataformas;

  Map<String, dynamic> toMapResumido() {
    return {
      "titulo": titulo,
      "descricao": descricao,
      "preco": preco,
    };
  }
}


