import 'package:flutter/material.dart';

class ItemMenuDrawer extends StatelessWidget {
  final IconData icone;
  final String texto;
  final PageController controladorPaginaPrincipal;
  final int idPageItemMenu;

  ItemMenuDrawer(this.icone, this.texto, this.controladorPaginaPrincipal,
      this.idPageItemMenu);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          controladorPaginaPrincipal.jumpToPage(idPageItemMenu);
        },
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Icon(
                icone,
                size: 32,
                color: controladorPaginaPrincipal.page.round() == idPageItemMenu
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              SizedBox(width: 32),
              Text(
                texto,
                style: TextStyle(
                  fontSize: 16,
                  color:
                      controladorPaginaPrincipal.page.round() == idPageItemMenu
                          ? Theme.of(context).primaryColor
                          : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
