import 'package:cloud_firestore/cloud_firestore.dart';

extension FirestoreExtention on FirebaseFirestore {
  CollectionReference favBookRef(String userId) =>
      collection("favourites").doc(userId).collection("favBooks");
}
