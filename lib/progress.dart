import 'package:flutter/material.dart';


class ProgressWidget extends StatefulWidget{
  final bool progress;

  ProgressWidget(this.progress);

  ProgressState createState() => new ProgressState();
}

class ProgressState extends State<ProgressWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.progress){
      return new Container(
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.all(10.0),
        child: new CircularProgressIndicator(),
      );
    }
    return new Container();
  }

}