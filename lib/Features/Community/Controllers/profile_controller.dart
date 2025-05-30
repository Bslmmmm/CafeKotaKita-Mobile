import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUserProfile(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }
}
