import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/models/session_model.dart';
import 'package:best_flutter_ui_templates/src/providers/session_provider.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
export 'package:flutter_svg/flutter_svg.dart';

// Da - Dev Apps
// ignore: must_be_immutable
class DaMainAppBar extends StatelessWidget with PreferredSizeWidget {
  SessionProvider prov = new SessionProvider();
  SessionModel user = new SessionModel();

  @override
  final Size preferredSize;

  final String? title;
  // final Widget icon;
  final Widget? avatar;
  final List<String>? actions;
  final Function(String, BuildContext)? onSelected;

  DaMainAppBar({
    this.title,
    // this.icon,
    this.avatar,
    this.actions,
    this.onSelected,
    Key? key,
  })  : preferredSize = Size.fromHeight(76.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    user = prov.session;

    return Material(
      elevation: 5.0,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              elevation: 0,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: SvgPicture.asset('assets/minLogo.svg', height: 30.0),
                    //icon,
                  ),
                  Text(this.title!),
                ],
              ),
              actions: <Widget>[
                Container(
                  child: (avatar == null)
                      ? CircleAvatar(
                          child: Text(user.username!.substring(0, 1)),
                          backgroundColor: Theme.of(context).accentColor,
                        )
                      : Center(
                          child: avatar,
                        ),
                ),
                PopupMenuButton<String>(
                  itemBuilder: _actionsBuilder(context),
                  onSelected: (val) => (onSelected == null)
                      ? _defSelected(val, context)
                      : onSelected!(val, context),
                ),
              ],
              automaticallyImplyLeading: false,
            ),
          ],
        ),
      ),
    );
  }

  _actionsBuilder(BuildContext context) {
    final List<String> newActions = (this.actions) ?? <String>[];
    newActions.add('Cerrar Sesión');

    return (context) {
      return newActions.map((String choice) {
        return PopupMenuItem<String>(
          value: choice,
          child: Text(choice),
        );
      }).toList();
    };
  }

  Future<void> _defSelected(String value, BuildContext context) async {
    switch (value) {
      case 'Cerrar Sesión':
        final httpProv = new HttpProvider();
        await httpProv.logOut();
        prov.reset();
        Navigator.pushReplacementNamed(context, 'login');
        break;
    }
  }
}

class DAInput extends StatelessWidget {
  DAInput({
    this.tipo,
    this.label,
    this.controller,
    this.onSaved,
    this.padding,
  });

  final String? tipo;
  final String? label;
  final TextEditingController? controller;
  final Function(String?)? onSaved;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: (this.padding) ?? 20.0),
      child: _getInputType(context),
    );
  }

  _getInputType(BuildContext context) {
    switch (this.tipo) {
      //   case "text":
      //     return _default(context, controller);
      //     break;
      case "email":
        return _email(context);
        break;
      case "url":
        return _url(context);
        break;
      case "password":
        return _password(context);
        break;
      default:
        return _email(context);
        break;
    }
  }

  TextFormField _email(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon:
            Icon(Icons.alternate_email, color: Theme.of(context).primaryColor),
        hintText: 'ejemplo@intelisis.com',
        labelText: this.label ?? 'Correo Electrónico',
        counterText: this.controller!.text,
        errorText: null,
      ),
      onSaved: this.onSaved,
      validator: (value) {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = new RegExp(pattern as String);
        if (regExp.hasMatch(value!)) {
          return null;
        } else {
          return 'Email incorrecto';
        }
      },
    );
  }

  TextFormField _url(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        icon: Icon(Icons.link, color: Theme.of(context).primaryColor),
        hintText: 'http://127.0.0.1',
        labelText: this.label ?? 'Url',
        counterText: this.controller!.text,
        errorText: null,
      ),
      onSaved: this.onSaved,
      validator: (value) {
        Pattern pattern = r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+';
        RegExp regExp = new RegExp(pattern as String);
        if (regExp.hasMatch(value!)) {
          return null;
        } else {
          return 'url inválida';
        }
      },
    );
  }

  TextFormField _password(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      obscureText: true,
      //keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        icon: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
        hintText: '',
        labelText: this.label ?? 'Contraseña',
        counterText: this.controller!.text.length.toString(),
        errorText: null,
      ),
      onSaved: this.onSaved,
      validator: (value) {
        if (value!.length >= 3) {
          return null;
        } else {
          return 'Requiere mas de 3 caracteres';
        }
      },
    );
  }
}

// ignore: must_be_immutable
class DaFloatingForm extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final String? title;
  final List<Widget>? children;
  final double? spacing;

  DaFloatingForm({
    this.title,
    this.formKey,
    this.children,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //this.children.insert(0, Text(this.title, style: TextStyle(fontSize: 20.0)));
    //this.children.insert(1, SizedBox(height: 35.0));

    return SingleChildScrollView(
      child: Form(
        key: this.formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 180.0, width: double.infinity),
            SafeArea(
              child: Container(
                width: size.width * 0.85,
                padding: EdgeInsets.symmetric(vertical: 50.0),
                margin: EdgeInsets.symmetric(vertical: (this.spacing) ?? 50.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(children: this.children!),
              ),
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}

class DaBackground extends StatelessWidget {
  final List<Color>? background;
  final Color? bubble;
  final String? label;
  final Widget? image;
  final double? size;

  DaBackground({
    this.background,
    this.bubble,
    this.label,
    this.image,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    // Color Fondo
    final colors = (this.background) ??
        <Color>[
          Theme.of(context).primaryColor,
          Theme.of(context).accentColor,
        ];

    final bcolor = (this.bubble) ?? Color.fromRGBO(255, 255, 255, 0.05);

    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    final backColor = Container(
      height: h * ((this.size) ?? 0.4),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.55, 0.9),
          end: FractionalOffset(1.0, 1.0),
          colors: colors,
        ),
      ),
    );

    final circleMin = Container(
      width: w * 0.3,
      height: w * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: bcolor,
      ),
    );

    return Stack(
      children: <Widget>[
        backColor,
        Positioned(top: h * 0.15, left: w * 0.1, child: circleMin),
        Positioned(top: h * -0.04, right: w * -0.03, child: circleMin),
        Positioned(bottom: h * -0.1, right: w * -0.10, child: circleMin),
        Container(
          padding: EdgeInsets.only(
              top: h * ((this.size == null) ? 0.12 : (this.size! / 10))),
          child: Column(
            children: [
              this.image!,
              SizedBox(height: 12.0, width: double.infinity),
              //_defTitle(),
            ],
          ),
        ),
      ],
    );
  }

  _defTitle() {
    if (this.label == null) {
      return Container();
    } else {
      return Text(
        this.label!,
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      );
    }
  }
}

class DaScaffoldLoading extends StatelessWidget {
  final bool? isLoading;
  final List<Widget>? children;
  final GlobalKey<ScaffoldState>? keyLoading;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  DaScaffoldLoading({
    this.isLoading,
    this.children,
    this.keyLoading,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: (this.isLoading) ?? false,
      color: Colors.black,
      progressIndicator: CircularProgressIndicator(
        strokeWidth: 5,
      ),
      child: Scaffold(
        key: this.keyLoading,
        appBar: this.appBar,
        body: Stack(children: this.children!),
        floatingActionButton: this.floatingActionButton,
        floatingActionButtonLocation: this.floatingActionButtonLocation,
      ),
    );
  }
}

class DAButton extends StatelessWidget {
  final String? label;
  final Function()? onPressed;

  DAButton({
    this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text(this.label!),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 0.0,
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: this.onPressed,
    );
  }
}

class DAInputDialog extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? okText;
  final DAInput? input;
  final Function()? onPressed;

  DAInputDialog({
    this.title,
    this.subtitle,
    this.input,
    this.onPressed,
    this.okText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      title: Text(title!),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(subtitle!),
          ),
          SizedBox(height: 20.0),
          input!,
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text((okText) ?? 'Ok'),
          onPressed: this.onPressed,
        ),
      ],
    );
  }
}

// ignore: non_constant_identifier_names
void DAToast(GlobalKey<ScaffoldState> scaffoldKey, String mensaje) {
  scaffoldKey.currentState!.removeCurrentSnackBar();

  final snackbar = SnackBar(
    content: Text(
      mensaje,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.grey[900], //Theme.of(context).primaryColor,
    // behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 2),
  );

  scaffoldKey.currentState!.showSnackBar(snackbar);
}

void DAToastLong(GlobalKey<ScaffoldState> scaffoldKey, String mensaje) {
  scaffoldKey.currentState!.removeCurrentSnackBar();

  final snackbar = SnackBar(
    content: Text(
      mensaje,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.grey[900], //Theme.of(context).primaryColor,
    // behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 5),
  );

  scaffoldKey.currentState!.showSnackBar(snackbar);
}
