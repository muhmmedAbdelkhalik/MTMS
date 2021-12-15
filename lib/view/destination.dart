import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mtms_task/model/cities.dart';
import 'package:http/http.dart' as http;

class DestinationPage extends StatefulWidget {
  const DestinationPage({Key? key}) : super(key: key);

  @override
  _DestinationPageState createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  late List<Cities> _allCites = [];

  // This list holds the data for the list view
  List<Cities> _foundCities = [];

  // Loading
  bool isLoading = false;

  @override
  initState() {
    // at the beginning, all Cities are shown
    _foundCities = _allCites;
    initScreen();
    super.initState();
  }

  initScreen() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/lutangar/cities.json/master/cities.json'));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      setState(() {
        _allCites = List<Cities>.from(parsed.map((x) => Cities.fromJson(x)));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load album');
    }
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Cities> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all Cities
      results = _allCites;
    } else {
      results = _allCites.where((cities) => cities.name!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundCities = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.blue[800], title: const Text('Destination')),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                    child: _foundCities.isNotEmpty
                        ? ListView.builder(
                            itemCount: _foundCities.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.pop(context, _foundCities[index]);
                              },
                              child: Card(
                                key: ValueKey(_foundCities[index]),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(title: Text(_foundCities[index].name!), subtitle: Text(_foundCities[index].country!)),
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
