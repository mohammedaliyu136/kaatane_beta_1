import 'package:firebase_auth/firebase_auth.dart';

Future getCurrentUser() async {
  FirebaseUser _user = await FirebaseAuth.instance.currentUser();
  //print("User: ${_user.displayName ?? "None"}");
  return _user;}