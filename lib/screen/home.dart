// ignore_for_file: unused_local_variable, prefer_final_fields, prefer_typing_uninitialized_variables, avoid_print, avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace

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
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServiceProvider>(context, listen: false)
              .fetchWeatherDataByCity(city);
        }
      }
    });

    super.initState();
  }

  TextEditingController _cityController = TextEditingController();
  var city;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final locationProvider = Provider.of<LocationProvider>(context);

    final weatherProvider = Provider.of<WeatherServiceProvider>(context);

    int sunriseTimestamp = weatherProvider.weather?.sys?.sunrise ?? 0;
    int sunsetTimestamp = weatherProvider.weather?.sys?.sunset ?? 0;
// Convert the timestamp to a DateTime object
    DateTime sunriseDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);
    return Scaffold(
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.only(top: 50, left: 20),
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: const [
                Color.fromARGB(255, 192, 198, 202),
                Color.fromARGB(255, 148, 155, 155)
              ], begin: Alignment.center, end: Alignment.bottomCenter)),
              child: Column(children: [
                Container(
                  height: 50,
                  child: Consumer<LocationProvider>(
                      builder: (context, locationProvider, child) {
                    var locationCity;
                    if (locationProvider.currentLocationName != null) {
                      locationCity = locationProvider
                          .currentLocationName!.administrativeArea;
                    } else {
                      locationCity = "Unknown Location";
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    data: locationCity,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fw: FontWeight.w700,
                                    size: 18,
                                  ),
                                  AppText(
                                    data: DateFormat("hh:mm a")
                                        .format(DateTime.now()),
                                    color:
                                        const Color.fromARGB(255, 10, 10, 10),
                                    fw: FontWeight.bold,
                                    size: 14,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 200,
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      clicked = !clicked;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.search,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    size: 30,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 10),
                clicked == true
                    ? SizedBox(
                        width: 370,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // IconButton(
                            //     onPressed: () {
                            //       setState(() {
                            //         clicked = !clicked;
                            //       });

                            //       print(_cityController.text);
                            //       weatherProvider.fetchWeatherDataByCity(
                            //           _cityController.text);
                            //     },
                            //     icon: const Icon(
                            //       Icons.search,
                            //       size: 30,
                            //       color: Colors.white,
                            //     )),
                            IconButton(
                                onPressed: () async {
                                  print(_cityController.text);
                                  await weatherProvider.fetchWeatherDataByCity(
                                      _cityController.text);
                                },
                                icon: const Icon(
                                  Icons.search,
                                  size: 30,
                                  color: Colors.white,
                                )),
                            Container(
                              child: Expanded(
                                child: TextFormField(
                                  controller: _cityController,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  decoration: InputDecoration(
                                    hintText: " search by city",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 2, 2, 2)),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 80,
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        width: 170,
                        child: Image.asset(images(
                                weatherProvider.weather?.weather![0].main ??
                                    "N/A") ??
                            "assets/cloudy.png"),
                      ),
                    ],
                  ),
                ),
                AppText(
                  data:
                      "${weatherProvider.weather?.main?.temp?.toStringAsFixed(0)}\u00B0 C",
                  color: Color.fromARGB(255, 11, 11, 11),
                  fw: FontWeight.bold,
                  size: 18,
                ),
                AppText(
                  data: weatherProvider.weather?.name ?? "N/A",
                  color: Color.fromARGB(255, 2, 2, 2),
                  fw: FontWeight.bold,
                  size: 16,
                ),
                AppText(
                  data: weatherProvider.weather?.weather![0].main ?? "N/A",
                  color: const Color.fromARGB(255, 13, 13, 13),
                  fw: FontWeight.bold,
                  size: 14,
                ),
                AppText(
                  data: DateFormat("hh:mm a").format(DateTime.now()),
                  color: const Color.fromARGB(255, 7, 7, 7),
                  fw: FontWeight.bold,
                  size: 14,
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 70, left: 25),
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 70,
                                      decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/high.png",
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    AppText(
                                      data: "Temp max",
                                      fw: FontWeight.bold,
                                      size: 16,
                                      color: const Color.fromARGB(255, 8, 8, 8),
                                    ),
                                    AppText(
                                      data:
                                          "${weatherProvider.weather?.main!.tempMax!.toStringAsFixed(0)}\u00b0 C",
                                      color: const Color.fromARGB(255, 6, 6, 6),
                                      fw: FontWeight.bold,
                                      size: 14,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 70,
                                      decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/low.png",
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    AppText(
                                      data: "Temp Min",
                                      fw: FontWeight.bold,
                                      size: 16,
                                      color: const Color.fromARGB(255, 4, 4, 4),
                                    ),
                                    AppText(
                                      data:
                                          "${weatherProvider.weather?.main!.tempMin!.toStringAsFixed(0) ?? "N/A"}\u00b0 C",
                                      color: const Color.fromARGB(255, 1, 1, 1),
                                      fw: FontWeight.bold,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ])
                        ])),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 25),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 60,
                                width: 90,
                                decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/sunny.png",
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              AppText(
                                data: "Sunrise",
                                fw: FontWeight.bold,
                                size: 16,
                                color: const Color.fromARGB(255, 17, 17, 17),
                              ),
                              AppText(
                                data: "${formattedSunrise} AM",
                                fw: FontWeight.bold,
                                size: 14,
                                color: const Color.fromARGB(255, 8, 8, 8),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 60,
                                width: 70,
                                decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/moon.png",
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              AppText(
                                data: "Sunset",
                                fw: FontWeight.bold,
                                size: 16,
                                color: const Color.fromARGB(255, 4, 4, 4),
                              ),
                              AppText(
                                data: "${formattedSunset} PM",
                                fw: FontWeight.bold,
                                size: 14,
                                color: const Color.fromARGB(255, 5, 5, 5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ])),
        ],
      ),
    );
  }
}
