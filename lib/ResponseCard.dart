import 'package:flutter/material.dart';
import 'package:ml_rest_flut/response.dart';

class ResponseCard extends StatefulWidget {
  final Response result;

  const ResponseCard({Key key, this.result}) : super(key: key);

  _ResponseState createState() => new _ResponseState();
}

class _ResponseState extends State<ResponseCard> {

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding:EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: new Card(
        child: new Container(
          height: 140.0,
          child: new ListView(
            shrinkWrap: false,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(8.0),
            children: new List.generate(widget.result.map.length, (int index) {
              Widget child;
              if (index == 0) {
                child =  new Container(
                  padding: EdgeInsets.fromLTRB(2.0, 1.0, 0.0, 1.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        width: 150.0,
                        margin: EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                        child: new Column(
                          children: <Widget>[
                            new Text(widget.result.map.keys.toList()[index][0].toUpperCase() + widget.result.map.keys.toList()[index].substring(1),
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0
                            ),),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      new Flexible(
                          child:new Container(
                            margin: EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                            child: new LinearProgressIndicator(
                              value: widget.result.map.values.toList()[index],
                            ),
                            width: 100.0,
                          )
                      ),
                      new Container(
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                        child: new Text((widget.result.map.values.toList()[index]*100.0).toString().substring(0, 4) + "%"),
                      )

                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  ),
                );
              }else {
                child = new Container(
                  padding: EdgeInsets.fromLTRB(2.0, 1.0, 0.0, 1.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        width: 150.0,
                        margin: EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                        child: new Column(
                          children: <Widget>[
                            new Text(widget.result.map.keys.toList()[index][0].toUpperCase() + widget.result.map.keys.toList()[index].substring(1)),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      new Flexible(
                          child: new Container(
                            margin: EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                            child: new LinearProgressIndicator(
                              value: widget.result.map.values.toList()[index],
                            ),
                            width: 100.0,
                          )
                      ),
                      new Container(
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                        child: new Text(
                            (widget.result.map.values.toList()[index] * 100.0)
                                .toString()
                                .substring(0, 4) + "%"),
                      )

                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  ),
                );
              }
              return child;
            }).toList(),
          ),
        ),
      ),
    );
  }

}