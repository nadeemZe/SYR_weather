import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import '../widgets/buildin_transform.dart';
import '../widgets/single_weather.dart';
import '../widgets/slider_dot.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int _currentPage = 0;

   _onPageChanged(int? index) {
    setState(() {
      _currentPage = index!;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:const Text('By  <* NZ *>'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          TransformerPageView(
            scrollDirection: Axis.horizontal,
            transformer: ScaleAndFadeTransformer(),
            viewportFraction: 3,
            onPageChanged: _onPageChanged,
            itemCount: 4,
            itemBuilder: (ctx, i) => SingleWeather(index: i,),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/8
              ,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 0; i<4; i++)
                  if( i == _currentPage )
                    const SliderDot( isActive: true,)
                  else
                    const SliderDot(isActive: false,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
