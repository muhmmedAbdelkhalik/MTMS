import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mtms_task/model/cities.dart';
import 'package:mtms_task/model/place.dart';
import 'package:mtms_task/view/destination.dart';
import 'package:mtms_task/view/source.dart';
import 'package:mtms_task/widget/custom_drawer.dart';
import 'package:mtms_task/widget/map.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // A key for scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Place location = Place();
  Cities city = Cities();

  // Controller for text field
  final TextEditingController _controllerLocation = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();

  Future<void> _showMyDialog(double value) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Distance'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Distance between two point is'),
                Text('$value Km'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: FloatingActionButton(
          onPressed: () async {
            if (location.name != null && city.name != null) {
              double _distanceInMeters =
                  Geolocator.distanceBetween(location.latitude!, location.longitude!, double.parse(city.lat!), double.parse(city.lng!));
              _showMyDialog(_distanceInMeters / 1000);
            } else {
              const snackBar = SnackBar(content: Text('Please select source/destination'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          child: const Text(
            'REQUEST RD',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          backgroundColor: Colors.blue[800],
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      drawer: const CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          // Map widget
          const Map(),
          // Box of Destination
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.12,
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(12))),
              padding: const EdgeInsets.only(bottom: 8),
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu icon button
                  IconButton(
                      onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                      icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.menu, color: Colors.grey))),
                  // Location text field
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                        readOnly: true,
                        onTap: () async {
                          final Place _place = await Navigator.push(context, MaterialPageRoute(builder: (context) => const SourcePage()));
                          setState(() {
                            location = _place;
                            _controllerLocation.text = location.name!;
                          });
                        },
                        controller: _controllerLocation,
                        decoration: const InputDecoration(
                            hintText: 'Your location', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none)),
                  ),
                  // Destination text field
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                        readOnly: true,
                        onTap: () async {
                          final Cities _cities =
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => const DestinationPage()));
                          setState(() {
                            city = _cities;
                            _controllerCity.text = city.name!;
                          });
                        },
                        controller: _controllerCity,
                        decoration: const InputDecoration(
                            hintText: 'Destination', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
