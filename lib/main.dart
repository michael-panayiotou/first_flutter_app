import 'package:first_flutter_app/icons/mikes_icons_icons.dart';
import 'package:first_flutter_app/location/current_location_widget.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// View all icons here: https://fontawesome.com/icons?d=gallery

void main() => runApp(MyApp());

enum bodyViews {
  map,
  currentLocation,
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      home: MyHomePage(title: "Michael's First App"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bodyViews _view = bodyViews.map;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter--;
    });
  }

  SpeedDialChild _init_speed_dial_child(label, icon, press_action) {
    return SpeedDialChild(
        child: icon,
        backgroundColor: Colors.cyan,
        label: label,
        labelStyle: TextStyle(fontSize: 18.0),
        onTap: press_action,
    );
  }

  SpeedDial _init_main_action_button() {
    return SpeedDial(
      // both default to 16
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_home,
      animatedIconTheme: IconThemeData(color: Colors.indigoAccent, size: 30.0),
      // this is ignored if animatedIcon is non null
      // child: Icon(Icons.add),
      //visible: _dialVisible,
      // If true user is forced to close dial manually
      // by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      //onOpen: () => print('OPENING DIAL'), //TODO: hide location button
      //onClose: () => print('DIAL CLOSED'), //TODO: show location button
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        _init_speed_dial_child("Έργα", Icon(MikesIcons.traffic_cone),() {
          // check if view hasn't change for smoothness
          if (_view == bodyViews.map)
            return;
          setState(() {
            _view = bodyViews.map;
          });
        }),
        _init_speed_dial_child("Location", Icon(MikesIcons.airplanemode_active), () {
          if (_view == bodyViews.currentLocation)
            return;
          setState(() {
            _view = bodyViews.currentLocation;
          });
        }),

      ],
    );
  }


  Widget _buildBody() {
    switch (_view) {
      case bodyViews.map:
        return _mapBody();
      case bodyViews.currentLocation:
        return CurrentLocationWidget(androidFusedLocation: false);
      default:
        return _mapBody();
    }
  }

  Widget _mapBody() {
    return FlutterMap(
      options: new MapOptions(
        center: new LatLng(34.6917208,32.9580691),
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'ACCESS TOKEN HERE',
            'id': 'mapbox.streets',
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: _buildBody(),

      floatingActionButton: _init_main_action_button(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
