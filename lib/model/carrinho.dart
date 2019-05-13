import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/produtoCarrinho.dart';
import 'package:loja_virtual/model/usuario.dart';
import 'package:scoped_model/scoped_model.dart';

class Carrinho extends Model {
  Usuario usuario;

  List<ProdutoCarrinho> produtos = [];

  String cupomDesconto;
  int percentualDesconto = 0;

  bool estaCarregando = false;

  Carrinho(this.usuario) {
    if (usuario.estaLogado()) _carregarItensCarrinho();
  }

  static Carrinho of(BuildContext context) => ScopedModel.of<Carrinho>(context);

  void adicionarItemCarrinho(ProdutoCarrinho produtoCarrinho) {
    produtos.add(produtoCarrinho);

    Firestore.instance
        .collection("usuarios")
        .document(usuario.usuarioFirebase.uid)
        .collection("carrinho")
        .add(produtoCarrinho.toMap())
        .then((carrinhoCriado) {
      produtoCarrinho.carrinhoId = carrinhoCriado.documentID;
    });

    notifyListeners();
  }

  void removerItemCarrinho(ProdutoCarrinho produtoCarrinho) {
    Firestore.instance
        .collection("usuarios")
        .document(usuario.usuarioFirebase.uid)
        .collection("carrinho")
        .document(produtoCarrinho.carrinhoId)
        .delete();

    produtos.remove(produtoCarrinho);

    notifyListeners();
  }

  void decrementarQuantidade(ProdutoCarrinho produtoCarrinho) {
    produtoCarrinho.quantidade--;

    Firestore.instance
        .collection("usuarios")
        .document(usuario.usuarioFirebase.uid)
        .collection("carrinho")
        .document(produtoCarrinho.carrinhoId)
        .updateData(produtoCarrinho.toMap());

    notifyListeners();
  }

  void incrementarQuantidade(ProdutoCarrinho produtoCarrinho) {
    produtoCarrinho.quantidade++;

    Firestore.instance
        .collection("usuarios")
        .document(usuario.usuarioFirebase.uid)
        .collection("carrinho")
        .document(produtoCarrinho.carrinhoId)
        .updateData(produtoCarrinho.toMap());

    notifyListeners();
  }

  void aplicarCupomDesconto(String cupomDesconto, int percentualDesconto) {
    this.cupomDesconto = cupomDesconto;
    this.percentualDesconto = percentualDesconto;
  }

  void atualizarTotal() {
    notifyListeners();
  }

  double recuperarTotalProdutos() {
    double precoTotal = 0.0;
    for (ProdutoCarrinho produtoCarrinho in produtos) {
      if (produtoCarrinho.produto != null)
        precoTotal +=
            produtoCarrinho.quantidade * produtoCarrinho.produto.preco;
    }

    return precoTotal;
  }

  double recuperarTotalDesconto() {
    return recuperarTotalProdutos() * percentualDesconto / 100;
  }

  double recuperarTotalFrete() {
    return 9.99;
  }

  Future<String> finalizarPedido() async {
    if (produtos.length == 0) return null;

    estaCarregando = true;
    notifyListeners();

    double totalProdutos = recuperarTotalProdutos();
    double totalFrete = recuperarTotalFrete();
    double totalDesconto = recuperarTotalDesconto();

    DocumentReference pedidoCriado =
        await Firestore.instance.collection("pedidos").add({
      "usuarioId": usuario.usuarioFirebase.uid,
      "produtos":
          produtos.map((produtoCarrinho) => produtoCarrinho.toMap()).toList(),
      "totalProdutos": totalProdutos,
      "totalFrete": totalFrete,
      "totalDesconto": totalDesconto,
      "totalPedido": totalProdutos - totalDesconto + totalFrete,
      "status": 1
    });

    await Firestore.instance
        .collection("usuarios")
        .document(usuario.usuarioFirebase.uid)
        .collection("pedidos")
        .document(pedidoCriado.documentID)
        .setData({"pedidoId": pedidoCriado.documentID});

    QuerySnapshot produtosCarrinhoDoPedidoCriado = await Firestore.instance
        .collection("usuarios")
        .document(usuario.usuarioFirebase.uid)
        .collection("carrinho")
        .getDocuments();

    for (DocumentSnapshot produtoCarrinho
        in produtosCarrinhoDoPedidoCriado.documents) {
      await produtoCarrinho.reference.delete();
    }

    produtos.clear();

    cupomDesconto = null;
    percentualDesconto = 0;

    estaCarregando = false;
    notifyListeners();

    return pedidoCriado.documentID;
  }

  void _carregarItensCarrinho() async {
    QuerySnapshot itensCarrinho = await Firestore.instance
        .collection("usuarios")
        .document(usuario.usuarioFirebase.uid)
        .collection("carrinho")
        .getDocuments();

    produtos = itensCarrinho.documents
        .map((itemCarrinho) => ProdutoCarrinho.fromDocument(itemCarrinho))
        .toList();

    notifyListeners();
  }
}
