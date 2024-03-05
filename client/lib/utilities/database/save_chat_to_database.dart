import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveChatToDatabase(
    List<dynamic> chatHistory, String entryId) async {
  final CollectionReference entryDataCollection =
      FirebaseFirestore.instance.collection('EntryData');

  try {
    final querySnapshot =
        await entryDataCollection.where('entryId', isEqualTo: entryId).get();

    if (querySnapshot.docs.isNotEmpty) {
      final documentSnapshot = querySnapshot.docs.first;

      await documentSnapshot.reference.update({
        'chatHistory': chatHistory,
      });
    } else {
      print('document with entryId $entryId not found');
    }
  } catch (e) {
    print('error updating entry data: $e');
  }
}
