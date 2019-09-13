import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shopappadmin/validators/LoginValidators.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidators {

  final _userController = BehaviorSubject<String>();
  final _passController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outUser => _userController.stream.transform(validateUser);
  Stream<String> get outPass => _passController.stream.transform(validatePassword);
  Stream<LoginState> get outState => _stateController.stream; 

  Stream<bool> get outSubmitvalid => Observable.combineLatest2(outUser, outPass,  (a, b) => true);

  Function(String) get changeUser => _userController.sink.add;
  Function(String) get changePassword => _passController.sink.add;

  StreamSubscription _streamSubscription;

  //LOGIN BLOC
  LoginBloc(){

    // FirebaseAuth.instance.signOut();

    _streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if(user != null){
        if(await verifyPrivileges(user)){
          _stateController.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          print(_stateController);
          _stateController.add(LoginState.FAIL);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }
  ////

  Future<bool> verifyPrivileges(user) async {
    //para retornar a função
    return await Firestore.instance.collection('admin').document(user.uid).get().then((doc){
      if(doc.data != null){
        return true;
      } else {
        return false;
      }
    }).catchError((e){
      return false;
    });
  }

  void submit(){
    final email = _userController.value;
    final password = _passController.value;

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
    .catchError((e) {
      _stateController.add(LoginState.FAIL);
    });

  }
  
  @override
  void dispose() {
    _userController.close();
    _passController.close();
    _stateController.close();
    _streamSubscription.cancel();
  }



}