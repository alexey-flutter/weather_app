import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_app/models/weather_forecast_daily.dart';
import 'package:weather_app/api/weather_api.dart';
import 'package:weather_app/screens/city_screen.dart';
import 'package:weather_app/widgets/bottom_list_view.dart';
import 'package:weather_app/widgets/city_view.dart';
import 'package:weather_app/widgets/detail_view.dart';
import 'package:weather_app/widgets/temp_view.dart';

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({Key? key, this.locationWeather})
      : super(key: key);

  final locationWeather;

  @override
  _WeatherForecastScreenState createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late Future<WeatherForecast> forecastObject;
  String _cityName = 'London';

  @override
  void initState() {
    super.initState();
    forecastObject = WeatherApi().fetchWeatherForecast(cityName: _cityName);
  }

  //   // forecastObject.then((weather) {
  //   //   print(weather.list[0].weather[0].main);
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Погода'),
        backgroundColor: Colors.black26,
        centerTitle: true,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //     onPressed: () {
        //       //   setState(() {
        //       //     forecastObject = WeatherApi().fetchWeatherForecast();
        //       //   });
        //     },
        //     icon: Icon(Icons.my_location)),
        actions: [
          IconButton(
              onPressed: () async {
                var tappedName = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return const CityScreen();
                }));

                if (tappedName != null) {
                  setState(() {
                    _cityName = tappedName;
                    forecastObject =
                        WeatherApi().fetchWeatherForecast(cityName: _cityName);
                  });
                }
              },
              icon: const Icon(Icons.location_city))
        ],
      ),
      body: ListView(
        children: [
          Container(
            child: FutureBuilder<WeatherForecast>(
              future: forecastObject,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      CityView(snapshot: snapshot),
                      SizedBox(
                        height: 50,
                      ),
                      TempView(snapshot: snapshot),
                      SizedBox(
                        height: 50,
                      ),
                      DetailView(snapshot: snapshot),
                      SizedBox(
                        height: 50,
                      ),
                      BottomListView(snapshot: snapshot),
                    ],
                  );
                } else {
                  return Center(
                    child: SpinKitDoubleBounce(
                      color: Colors.blue,
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
