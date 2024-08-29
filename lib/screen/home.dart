import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/Data/imagepath.dart';
import 'package:weatherapp/ser/loc_provider.dart';
import 'package:weatherapp/ser/weather_ser_pro.dart';
import 'package:weatherapp/utilites/text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      locationProvider.determinePosition().then((_) {
        if (locationProvider.currentLocationName != null) {
          var city = locationProvider.currentLocationName!.locality;
          if (city != null) {
            Provider.of<WeatherServiceProvider>(context, listen: false)
                .fetchWeatherDataByCity(city);
          }
        }
      });
    });
  }

  TextEditingController _cityController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final locationProvider = Provider.of<LocationProvider>(context);
    final weatherProvider = Provider.of<WeatherServiceProvider>(context);

    int sunriseTimestamp = weatherProvider.weather?.sys?.sunrise ?? 0;
    int sunsetTimestamp = weatherProvider.weather?.sys?.sunset ?? 0;
    
    DateTime sunriseDateTime = DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);

    String weatherCondition = weatherProvider.weather?.weather?[0].main ?? "N/A";
    String imagePath = images(weatherCondition) ?? "assets/cloudy.png";

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              weatherCondition == "Clear"
                  ? "assets/rainy.jpeg"
                  : weatherCondition == "Rain"
                      ? "assets/rainy.jpeg"
                      : "assets/sky.jpeg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Color.fromARGB(255, 162, 25, 25),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                data: locationProvider.currentLocationName?.administrativeArea ?? "Unknown Location",
                                color: Color.fromARGB(255, 11, 10, 10),
                                fw: FontWeight.w700,
                                size: 18,
                              ),
                              AppText(
                                data: DateFormat("hh:mm a").format(DateTime.now()),
                                color: const Color.fromARGB(179, 0, 0, 0),
                                fw: FontWeight.bold,
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  if (_isSearching)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Search by city",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            onPressed: () async {
                              String city = _cityController.text.trim();
                              if (city.isNotEmpty) {
                                await weatherProvider.fetchWeatherDataByCity(city);
                                setState(() {
                                  _isSearching = false;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.check,
                              size: 30,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 50),
                  Center(
                    child: Container(
                      height: 130,
                      width: 170,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AppText(
                    data: "${weatherProvider.weather?.main?.temp?.toStringAsFixed(0)}\u00B0 C",
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fw: FontWeight.bold,
                    size: 18,
                  ),
                  AppText(
                    data: weatherProvider.weather?.name ?? "N/A",
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fw: FontWeight.bold,
                    size: 16,
                  ),
                  AppText(
                    data: weatherCondition,
                    color: const Color.fromARGB(179, 0, 0, 0),
                    fw: FontWeight.bold,
                    size: 14,
                  ),
                  AppText(
                    data: DateFormat("hh:mm a").format(DateTime.now()),
                    color: const Color.fromARGB(179, 0, 0, 0),
                    fw: FontWeight.bold,
                    size: 14,
                  ),
                  SizedBox(height: size.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Image.asset("assets/high.png"),
                            height: size.height * 0.06,
                            width: size.height * 0.06,
                          ),
                          AppText(
                            data: "Temp Max",
                            fw: FontWeight.bold,
                            size: 16,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          AppText(
                            data: "${weatherProvider.weather?.main?.tempMax?.toStringAsFixed(0)}\u00b0 C",
                            color: const Color.fromARGB(179, 0, 0, 0),
                            fw: FontWeight.bold,
                            size: 14,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            child: Image.asset("assets/low.png"),
                            height: size.height * 0.06,
                            width: size.height * 0.06,
                          ),
                          AppText(
                            data: "Temp Min",
                            fw: FontWeight.bold,
                            size: 16,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          AppText(
                            data: "${weatherProvider.weather?.main?.tempMin?.toStringAsFixed(0) ?? "N/A"}\u00b0 C",
                            color: const Color.fromARGB(179, 0, 0, 0),
                            fw: FontWeight.bold,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Image.asset("assets/sunny.png"),
                            height: size.height * 0.06,
                            width: size.height * 0.06,
                          ),
                          AppText(
                            data: "Sunrise",
                            fw: FontWeight.bold,
                            size: 16,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          AppText(
                            data: formattedSunrise,
                            fw: FontWeight.bold,
                            size: 14,
                            color: const Color.fromARGB(179, 0, 0, 0),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            child: Image.asset("assets/moon.png"),
                            height: size.height * 0.06,
                            width: size.height * 0.06,
                          ),
                          AppText(
                            data: "Sunset",
                            fw: FontWeight.bold,
                            size: 16,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          AppText(
                            data: formattedSunset,
                            fw: FontWeight.bold,
                            size: 14,
                            color: const Color.fromARGB(179, 0, 0, 0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
