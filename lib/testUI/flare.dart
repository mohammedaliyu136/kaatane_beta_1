import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class FlareDemo extends StatefulWidget {
  @override
  _FlareDemoState createState() => _FlareDemoState();
}

class _FlareDemoState extends State<FlareDemo> {
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return FlareActor("assets/flare/logo_loading.flr", alignment:Alignment.center, fit:BoxFit.contain, animation: "Untitled",);
  }
}