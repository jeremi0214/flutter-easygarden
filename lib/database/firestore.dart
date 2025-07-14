import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*

This database stores jobs that users have published in the app.
It is stored in a collection called 'Jobs' in Firebase

Each post contains:
- title
- description
- location
- budget
- contact

*/

class FirestoreDatabase {
  // current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  // get collection from firebase
  final CollectionReference jobs = FirebaseFirestore.instance.collection(
    'Jobs');

  final CollectionReference providers = FirebaseFirestore.instance.collection(
    'Providers');

  // post a job
  Future<void> postJob(
    String title, 
    String description, 
    String location, 
    String budget,
    String contact,
    List<String> tags,
    String? jobType,
    List<String> categories,
  ) async {
    await jobs.add({
      'title': title,
      'description': description,
      'location': location,
      'budget': budget,
      'contact': contact,
      'tags': tags,
      'jobType': jobType,
      'categories': categories,
      'timestamp': Timestamp.now(),
      'userId': user?.uid,
    });
  }

  // read jobs from firebase
  Stream<QuerySnapshot> getJobsStream() {
    return jobs.orderBy('timestamp', descending: true).snapshots();
  }

  // Get jobs by a single selected category
  Stream<QuerySnapshot> getJobsByCategory(String category) {
    return jobs
        .where('categories', arrayContains: category)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Get jobs matching any of multiple categories (max 10)
  Stream<QuerySnapshot> getJobsByMultipleCategories(List<String> selectedCategories) {
    return jobs
        .where('categories', arrayContainsAny: selectedCategories)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // register a gardener
  Future<void> registerGardener(
    String name, 
    String contact, 
    String email, 
    String location,
    String services,
    List<String> categories,
  ) {
    return providers.add({
      'name': name,
      'contact': contact,
      'email': email,
      'location': location,
      'services': services,
      'categories': categories,
      'timestamp': Timestamp.now(),
      'userId': user?.uid,
    });
  }

  // read providers from firebase
  Stream<QuerySnapshot> getProvidersStream() {
    return providers.orderBy('name').snapshots();
  }
}
