import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'package:image_picker/image_picker.dart';
import 'package:ml_rest_flut/ResponseCard.dart';
import 'package:ml_rest_flut/progress.dart';
import 'package:ml_rest_flut/response.dart';
import 'package:path/path.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _controller;
  File _image;
  String snap;
  bool _showProgress = false;
  int radioValue = 0;
  Response result;
  String url;
  Color color = new Color(0xFFE91E63);

  static const List<IconData> icons = const [ Icons.camera, Icons.image];

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  Widget build(BuildContext context) {
    Color backgroundColor = Theme
        .of(context)
        .cardColor;
    Color foregroundColor = Theme
        .of(context)
        .accentColor;

    Column fab = new Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(icons.length, (int index) {
        Widget child = new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve: new Interval(
                  0.0,
                  1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut
              ),
            ),
            child: new FloatingActionButton(
              backgroundColor: backgroundColor,
              mini: true,
              child: new Icon(icons[index], color: color),
              onPressed: () async {
                var image;
                if (index == 0) {
                  image =
                  await ImagePicker.pickImage(source: ImageSource.camera);
                } else {
                  image =
                  await ImagePicker.pickImage(source: ImageSource.gallery);
                }
                setState(() {
                  _image = image;
                });
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(
                      _controller.value * 0.5 * math.PI),
                  alignment: FractionalOffset.center,
                  child: new Icon(
                      _controller.isDismissed ? Icons.share : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
            backgroundColor: color,
          ),
        ),
    );

    Column body = new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Center(
            child: _image != null ? new Container(
              height: 150.0,
              width: 150.0,
              margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                      image: new FileImage(_image)
                  )
                ),
            ):
            new Container(
              height: 150.0,
                width: 150.0,
                child: new Icon(Icons.contacts))
        ),new Container(
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
          child:new Column(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(value: 0, groupValue: radioValue, onChanged: handleRadioValueChanged),
                        new Text("Dog")
                      ],
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Radio(value: 1, groupValue: radioValue, onChanged: handleRadioValueChanged),
                        new Text("Dessert")
                      ],
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Radio(value: 2, groupValue: radioValue, onChanged: handleRadioValueChanged),
                        new Text("Flower")
                      ],
                    ),
                  ],
                )
              ],
            ),
        ),
        new RaisedButton(
          child: new Text("send"),
          onPressed:upload
        ),

        new Container(
          child: snap !=null
            ?new ResponseCard(result: this.result,)
            :new ProgressWidget(_showProgress),
        )
      ],

    );
    return new Scaffold(
        appBar: new AppBar(title: new Text('ML Rest'), backgroundColor: color,),
        body: body,
        floatingActionButton: fab,
    );
  }

  upload() async {
    var imageFile = _image;
    setState(() {
      snap = null;
      _showProgress = true;
      result = null;

    });
      var stream = new http.ByteStream(
          DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri = Uri.parse(url);
      print(uri.port);

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));

      request.files.add(multipartFile);
      print(request.files);
      var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      setState(() {
        snap = value;
        result = Response.fromJson(json.decode(value));
        print(result.map.keys.toList()[0]);
        _showProgress = false;
      });
    });
  }
  void handleRadioValueChanged(int value) {
    setState(() {
      if (value == 0) {
        color = new Color(0xFFE91E63);
        url = 'http://192.168.43.223:5000/a0c03cb6-8c9c-4f2a-ad37-f094ad1a6d98/label';
      }
      else if (value == 1) {
        color = new Color(0xFF673AB7);
        url='http://192.168.43.223:5000/0052ba7e-c9e7-4954-ba26-1e6a28ec1b4f/label';
      }
      else{
        color = new Color(0xFF8BC34A);
        url= 'http://192.168.43.223:5000/ac89ed7c-ddd6-4338-8796-a1361f4b7525/label';
      }
      radioValue = value;
    });
  }
}