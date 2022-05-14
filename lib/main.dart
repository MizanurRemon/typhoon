// ignore_for_file: camel_case_types, unused_import, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Typhoon",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Icon(Icons.cloud),
              )
            ],
            backgroundColor: Colors.red,
          ),
          body: const HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var temp;
  var description;
  var humidity;
  var windspeed;
  var APIKey = "55a80c7d0b44c5583829f23d7046f251";
  var location = "boston";
  var results;
  var url = ("https://api.openweathermap.org/data/2.5/weather?");

  Future getWeather() async {
    try {
      http.Response response =
          await http.get(Uri.parse(url + "q=" + location + "&appid=" + APIKey));
      results = jsonDecode(response.body);
    } catch (err) {
      return "$err";
    }

    setState(() {
      //temp = results['main']['temp'];
      temp = results['main']['temp'] - 273.15;
      windspeed = results['wind']['speed'];
      humidity = results['main']['humidity'];
      location = results['name'];
      description = results['weather'][0]['description'];
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var degreeSign = "\u00B0";
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: height / 4,
            width: width,
            color: const Color.fromARGB(255, 54, 54, 54),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.yellow,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        location,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    temp.toStringAsFixed(1) + degreeSign,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.thermostat),
                  title: const Text("Temperature"),
                  trailing: Text(temp.toStringAsFixed(1) + degreeSign),
                ),
                const ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text("Weather"),
                  trailing: FaIcon(FontAwesomeIcons.cloudRain),
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.wind),
                  title: const Text("Wind Speed"),
                  trailing: Text(windspeed.toString()),
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.sun),
                  title: const Text("Humidity"),
                  trailing: Text(humidity.toString()),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
