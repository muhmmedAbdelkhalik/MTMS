import 'package:flutter/material.dart';
import 'package:mtms_task/model/place.dart';
import 'package:mtms_task/utils/database.dart';

class SourcePage extends StatefulWidget {
  const SourcePage({Key? key}) : super(key: key);

  @override
  _SourcePageState createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  final List<Place> _allPlaces = [];

  // This list holds the data for the list view
  List<Place> _foundPlaces = [];

  @override
  initState() {
    // at the beginning, all place are shown
    _foundPlaces = _allPlaces;
    initScreen();
    super.initState();
  }

  initScreen() async {
    List<dynamic> result = await Database.getData();
    for (var element in result) {
      _allPlaces.add(Place.fromJson(element));
    }
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Place> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all place
      results = _allPlaces;
    } else {
      results = _allPlaces.where((place) => place.name!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundPlaces = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.blue[800], title: const Text('Your location')),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(labelText: 'Search', border: InputBorder.none, suffixIcon: Icon(Icons.search)),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _foundPlaces.isNotEmpty
                  ? ListView.builder(
                      itemCount: _foundPlaces.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.pop(context, _foundPlaces[index]);
                        },
                        child: Card(
                          key: ValueKey(_foundPlaces[index]),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(title: Text(_foundPlaces[index].name!)),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
