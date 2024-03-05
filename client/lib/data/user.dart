import 'package:firebase_auth/firebase_auth.dart';

User? _user;

User? get currentUser => _user;

void setUser(User? user) {
  _user = user;
}
