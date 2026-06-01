import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather Forecast",
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const UserPage(),
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final String apiKey = "3d31bd1b3cbb478ca9ccc6fe765ee759";

  final TextEditingController cityController =
      TextEditingController();

  final TextEditingController countryController =
      TextEditingController();

  bool isLoading = false;

  String cityName = "";
  String temperature = "";
  String humidity = "";
  String description = "";
  String weatherIcon = "";

  Future<void> getWeather() async {
    if (cityController.text.trim().isEmpty ||
        countryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter both city and country",
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather"
          "?q=${cityController.text.trim()},${countryController.text.trim()}"
          "&appid=$apiKey"
          "&units=metric",
        ),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          cityName = data["name"];
          temperature = "${data["main"]["temp"]}°C";
          humidity = "${data["main"]["humidity"]}%";
          description = data["weather"][0]["description"];
          weatherIcon = data["weather"][0]["icon"];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["message"] ?? "City not found",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3C72),
              Color(0xFF2A5298),
              Color(0xFF4A90E2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                Icon(
                  Icons.wb_sunny_rounded,
                  size: 90,
                  color: Colors.amber.shade300,
                ),

                const SizedBox(height: 15),

                Text(
                  "Weather Forecast",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "Check weather anywhere in the world",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 35),

                TextField(
                  controller: cityController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter City",
                    prefixIcon: const Icon(
                      Icons.location_city,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: countryController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter Country Code (GB, NG, US)",
                    prefixIcon: const Icon(Icons.flag),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: getWeather,
                    icon: const Icon(Icons.search),
                    label: Text(
                      "Get Weather",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:
                          const Color(0xFF1E3C72),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                if (isLoading)
                  Column(
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Fetching weather...",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                if (!isLoading &&
                    cityName.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(0.18),
                      borderRadius:
                          BorderRadius.circular(30),
                      border: Border.all(
                        color:
                            Colors.white.withOpacity(0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.network(
                          "https://openweathermap.org/img/wn/$weatherIcon@4x.png",
                          height: 120,
                        ),

                        Text(
                          cityName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          temperature,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          description.toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.water_drop,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Humidity: $humidity",
                              style:
                                  GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}