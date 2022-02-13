import 'package:flutter/material.dart';

class NavBarCustom extends StatelessWidget implements PreferredSizeWidget {

   @override
  Size get preferredSize => const Size.fromHeight(60);

  final String? title;
  NavBarCustom(this.title);

  @override
  Widget build(BuildContext context) {

    String imagenAppBar = "assets/background2.jpg";

    return AppBar(
      title: Text(this.title!),
      centerTitle: true,
      actions: [],
      flexibleSpace: Container(
          child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.0),
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
            topRight: Radius.circular(0.0)),
        child: Container(
          child: Image.asset(
            imagenAppBar,
            fit: BoxFit.cover,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[500]!, Colors.blue[400]!],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      )),
      elevation: 20,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
    );
  }
}