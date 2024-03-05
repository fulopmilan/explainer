import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addOrUpdateUserEntry(
  String userEmail,
  String entryId,
  String entryName,
  String text,
) async {
  await _updateUserEntryList(userEmail, entryId, entryName);
  await _addEntryData(entryId, text);
}

Future<void> _updateUserEntryList(
    String userEmail, String entryId, String entryName) async {
  final CollectionReference userEntryCollection =
      FirebaseFirestore.instance.collection('UserEntryList');

  try {
    QuerySnapshot querySnapshot =
        await userEntryCollection.where('email', isEqualTo: userEmail).get();

    if (querySnapshot.docs.isEmpty) {
      await _createUserEntryList(
          userEntryCollection, userEmail, entryId, entryName);
    } else {
      await _updateExistingUserEntry(
          userEntryCollection, querySnapshot, entryId, entryName);
    }
  } catch (e) {
    print('error adding/updating user entry list: $e');
  }
}

Future<void> _createUserEntryList(CollectionReference userEntryCollection,
    String userEmail, String entryId, String entryName) async {
  await userEntryCollection.add({
    'email': userEmail,
    'entries': {
      {
        'entryId': entryId,
        'entryName': entryName,
      }
    },
  });
}

Future<void> _updateExistingUserEntry(CollectionReference userEntryCollection,
    QuerySnapshot querySnapshot, String entryId, String entryName) async {
  final DocumentReference userDocRef = querySnapshot.docs.first.reference;
  await userDocRef.update({
    'entries': FieldValue.arrayUnion(
      [
        {
          'entryId': entryId,
          'entryName': entryName,
        }
      ],
    ),
  });
}

Future<void> _addEntryData(String entryId, String text) async {
  final CollectionReference entryDataCollection =
      FirebaseFirestore.instance.collection('EntryData');

  try {
    await entryDataCollection.add({
      'entryId': entryId,
      'chatHistory': [text],
    });
  } catch (e) {
    print('error adding entry data: $e');
  }
}
