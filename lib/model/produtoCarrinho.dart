import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/model/produto.dart';

class ProdutoCarrinho {
  String carrinhoId;
  
  String categoria;  
  String produtoId;

  int quantidade;
  String plataforma;

  Produto produto;

  ProdutoCarrinho();

  ProdutoCarrinho.fromDocument(DocumentSnapshot documento) {
    carrinhoId = documento.documentID;
    categoria = documento.data["categoria"];
    produtoId = documento.data["produtoId"];
    quantidade = documento.data["quantidade"];
    plataforma = documento.data["plataforma"];
  }

  Map<String, dynamic> toMap() {
    return {
      "categoria": categoria,
      "produtoId": produtoId,
      "quantidade": quantidade,
      "plataforma": plataforma,
      "produtoResumido": produto.toMapResumido()
    };
  }
}