import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleWeather extends StatefulWidget {
  final int index;

  const SingleWeather({Key? key,required this.index}) : super(key: key);


  @override
  _SingleWeatherState createState() => _SingleWeatherState();
}

class _SingleWeatherState extends State<SingleWeather> {
  var n;
  Future<Map<String,dynamic>>? weatherInfo;
  var city ,savedCity;
  var dateTime=DateFormat.yMMMMEEEEd().format(DateTime.now());
  var savedTime;
  var temp,savedTemp;
  var weather,savedWeather;
  var icon;
  var wind,savedWind;
  var rain;
  var humidity,savedHum;
  var img,savedImg;



  Future<Map<String,dynamic>>getWeather(val)async{

    SharedPreferences pref=await SharedPreferences.getInstance();

    var response;

    try {
      if (val == 0) {
        response =await
        http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=Lattakia,syria&units=metric&APPID=urId'));

      }
      else if (val == 1) {
        response =await
        http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=Damascus,syria&units=urID'));

      }
      else if (val == 2) {
        response =await
        http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=Aleppo,syria&units=urID'));

      }
      else {
        response =await
        http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=Homs,syria&units=metric&APPID=urID'));
      }
    }
    catch(e){
          print (e);
        }
    var data = jsonDecode(response.body);

    if (response.body!=null) {
      await pref.setInt('val', val);

      await pref.setString('time', dateTime);

      city = data['name'];
      await pref.setString('city', city);

      temp = '${(data['main']['temp']).round()}\u2103';
      await pref.setString('temp', temp.toString());


      weather = data['weather'][0]['main'];
      await pref.setString('weather', weather);

      icon = data['weather'][0]['icon'];
      wind = data['wind']['deg'];
      await pref.setString('wind', wind.toString());

      if (weather == 'Rain') {
        rain = data['rain']['1h'];
      }
      else {
        rain = 0;
      }
      humidity = data['main']['humidity'];
      await pref.setString('hum', humidity.toString());

      img = '${data['weather'][0]['main']}.jpg';
      await pref.setString('img', img);
    }
    return data;
  }

  Future getInfo()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    savedCity = pref.get('city');
    savedTime = pref.get('time');
    savedTemp= pref.get('temp');
    savedWeather= pref.get('weather');
    savedWind= pref.get('wind');
    savedHum= pref.get('hum');
    savedImg= pref.get('img');
    n= pref.get('val');
  }

  @override
  void initState() {
    weatherInfo= getWeather(widget.index);
    getInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: weatherInfo,
        builder:(context,AsyncSnapshot snapshot) {
          if(snapshot.connectionState != ConnectionState.done){
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasData||n==widget.index) {
            return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(img==null?'assets/$savedImg':'assets/$img'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(color: Colors.black38,),
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                      padding:const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   const SizedBox(height: 90,),
                                    Text(city==null?'$savedCity':'$city',
                                      style: GoogleFonts.lato(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                   const SizedBox(height: 5,),
                                    Text((snapshot.hasData)?dateTime:savedTime,
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(temp==null?'$savedTemp':'$temp',
                                      style: GoogleFonts.lato(
                                        fontSize: 51,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                       if(icon != null) Image.network(
                                          'http://openweathermap.org/img/wn/$icon.png',
                                          width: 31,
                                          height: 31,
                                        ),
                                        const SizedBox(width: 10,),
                                        Text(weather==null?'$savedWeather':'$weather',
                                          style: GoogleFonts.lato(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                margin:const EdgeInsets.symmetric(vertical: 21),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white30,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text('Wind',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(wind==null?'$savedWind':'$wind',
                                          style: GoogleFonts.lato(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text('km/h',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Rain',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text('0',
                                          style: GoogleFonts.lato(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text('%',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Humidity',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(humidity==null?'$savedHum':'$humidity',
                                          style: GoogleFonts.lato(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text('%',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
            );
          }
          return const Center(
              child: Text("Error: check your internet",style:TextStyle(fontSize: 17,color: Colors.red),
              )
          );
        }
    );
  }
}
