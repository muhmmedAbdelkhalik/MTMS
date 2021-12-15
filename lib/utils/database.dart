import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _fireStore.collection('Source');

class Database {
  static Future<void> addItem({
    required String name,
    required double latitude,
    required double longitude,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc();
    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "latitude": latitude,
      "longitude": longitude,
    };
    await documentReferencer.set(data).whenComplete(() => print("Source item added to the database")).catchError((e) => print(e));
  }

  static Future<dynamic> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _mainCollection.get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }
}
