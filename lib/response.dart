import 'package:ml_rest_flut/prediction.dart';
import 'dart:convert';

class Response {
  String time;
  Map<String, dynamic> map;


  Response({this.time, this.map});

  factory Response.fromJson(Map<String, dynamic> json) {
    return new Response(
      time: json['time'],
      map: json['prediction']
    );
  }


  static Response getResponseFromJson(String j) {
    var jsonResult = json.decode(j);
    var response = new Response();
    var predict = jsonResult['prediction'];
    print(predict);
    return response;
  }
}