import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../orders.dart';
import 'detail.dart';
import 'edit_profile.dart';
import 'profile.dart';
//import 'package:js/js.dart';

class AccountManager with ChangeNotifier {

  Map<int, int> _cart = {};

  Map<int, int> get cart => _cart;


  FirebaseUser _userFirebase;
  bool isLoading = false;
  bool isTerminated = false;
  String message = "";
  get userFirebase => _userFirebase;
  int _v1=1;
  int kkv1=1;
  get v1 => _v1;
  void set_v1(v) => _v1=v;

  void setUserFirebase(user) => _userFirebase==user;

  Future<void> signInWithEmailAndPassword(context, email, password) async {
    isLoading=true;
    if(isEmailValid(email, password)){
      try{
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email,
            password: password)
            .then((currentUser){
          print("000000000000000000000000000000");
          print("000000000000000000000000000000");
          print("000000000000000000000000000000");
          print(currentUser.user.displayName);
          _userFirebase=currentUser.user;
          isLoading=false;
          if(_userFirebase.displayName==null || _userFirebase.phoneNumber==null){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Orders()),//EditProfile
            );
          }else{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Detail()),
            );
          }

        })
            .catchError((err) {
          print(err.message);
          isTerminated=true;
          isLoading=false;
          message=err.message;
          notifyListeners();
        });
      }catch(e){
        print("000000000000000000000000000000");
        print("000000000000000000000000000000");
        print("000000000000000000000000000000");
        print(e.message);
        isTerminated=true;
        isLoading=false;
      }
      isTerminated=true;
    }else{
      isLoading=false;
      isTerminated=true;
      message="Email/Password entered is invalid";
      notifyListeners();
    }
    isLoading=false;

  }

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://kaatane-vendor2.appspot.com');
  Future<String> uploadImage(var imageFile ) async {
    String filePath = 'images/${DateTime.now()}.png';

    StorageUploadTask _uploadTask = _storage.ref().child(filePath).putFile(imageFile);

    notifyListeners();

    _uploadTask.events.forEach(
        (event){
          var progressPercent = event != null
              ? event.snapshot.bytesTransferred / event.snapshot.totalByteCount
              : 0;
          progressPercent=(progressPercent*100).round();
          message = "Uploading "+progressPercent.toString()+"% done.";
          notifyListeners();
        }
    );

    var dowurl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    var url = dowurl.toString();
    notifyListeners();

    return url;
  }

  isEmailValid(email, password){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

    if(emailValid && password!=null && password.trim!=''){
      return true;
    }else{
      return false;
    }
  }

  not(){
    notifyListeners();
  }


  void clear(index) {
    if (_cart.containsKey(index)) {
      _cart.remove(index);
      notifyListeners();
    }
  }
}
