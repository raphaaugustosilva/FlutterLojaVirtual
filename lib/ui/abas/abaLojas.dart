import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/ui/tiles/lojaTile.dart';

class AbaLojas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("lojas").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else {
          return ListView(
            children: snapshot.data.documents.map((loja) => LojaTile(loja)).toList(),
          );
        }
      },
    );
  }
}
