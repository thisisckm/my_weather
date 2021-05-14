import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Weather',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(title: 'My Weather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String location = "Chennai";
  String countryCode = "IN";
  Image weatherImage =
      Image.network("https://openweathermap.org/img/w/10d.png");
  String temp = "40";

  Future<Map<String, dynamic>> fetchWeather(searchLocation) async {
    var queryParameters = {
      'appid': 'ff35c79ba8fd76af58257883666ba163',
      'q': searchLocation,
      'units': 'metric'
    };

    final response = await http.get(Uri.https(
        'api.openweathermap.org', 'data/2.5/weather', queryParameters));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
      return null;
    }
  }

  void _searchLocation(text) {
    fetchWeather(text).then((value) {
      setState(() {
        if (value != null) {
          location = value['name'];
          String iconID = value['weather'][0]['icon'];
          weatherImage =
              Image.network("https://openweathermap.org/img/w/$iconID.png");
          temp = value['main']['temp'].toString();
          countryCode = value['sys']['country'];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(hintText: 'eg: Chennai'),
              onSubmitted: (text) => _searchLocation(text),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '$location,',
                      style: new TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '$countryCode',
                      style: new TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    weatherImage,
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "$temp°C",
                      style: new TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _searchLocation(location);
        },
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
