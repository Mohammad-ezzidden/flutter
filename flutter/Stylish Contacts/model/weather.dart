import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'as convert;



class Weather {

  String condition,minTemp,maxTemp;

  Weather({this.condition,this.maxTemp,this.minTemp});

  Weather.fromJson(dynamic json){
     Weather(condition: json['weather_state_name'],maxTemp: json['max_temp'],minTemp: json['min_temp']);
  }
  

var d=DateTime.now();
}

Future<Weather> getWeather()async{
var d=DateTime.now().toString();
final response=await http.get('https://www.metaweather.com/api/location/1947122/2019/2/27/');
if(response.statusCode==200){
  var resulte=convert.jsonDecode(response.body);
  var model=Weather.fromJson(resulte);
  return model;
}else{
  throw Exception('failed to get weather');
}



}


class weatherWidget extends StatefulWidget {
  _weatherWidgetState createState() => _weatherWidgetState();
}

class _weatherWidgetState extends State<weatherWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          home: Scaffold(
                      body: Container(
         child: FutureBuilder<Weather>(future: getWeather(),builder: (context,snapshot){
             if(snapshot.hasData){
               return Text(snapshot.data.condition+''+snapshot.data.maxTemp);
             }else{
               return CircularProgressIndicator();
             }
         },),
      ),
          ),
    );
  }
}