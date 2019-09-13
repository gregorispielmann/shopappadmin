import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';

class ClientsBloc extends BlocBase {
  
  final _clientsController = BehaviorSubject();

  Stream get outClients => _clientsController.stream;

  Map<String, Map<String, dynamic>> _clients = {};

  Firestore _firestore = Firestore.instance;

  ClientsBloc(){
    _addClientsListener();

  }
  
  void _addClientsListener(){
    _firestore.collection('users').snapshots().listen((onData){
      onData.documentChanges.forEach((f){
        String uid = f.document.documentID;

        switch(f.type){
          case DocumentChangeType.added:
            _clients[uid] = f.document.data;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _clients[uid].addAll(f.document.data);
            _clientsController.add(_clients.values.toList());
            break;
          case DocumentChangeType.removed:
            _clients.remove(uid);
            _unsubscribeToOrders(uid);
            _clientsController.add(_clients.values.toList());
            break;
        }
      });
    });
  }

  void _subscribeToOrders(uid){

    _clients[uid]["subscription"] = _firestore.collection('users').document(uid).collection('orders').snapshots().listen((orders) async {
      int numOrders = orders.documents.length;
      double money = 0.0;

      for(DocumentSnapshot d in orders.documents){
        
        DocumentSnapshot order = await _firestore.document(d.documentID).get();

        if(order.data == null) continue;
        money += order.data['totalPrice'];

      }

      _clients[uid].addAll(
        {"money": money, "orders": numOrders}
      );

      _clientsController.add(_clients.values.toList());

    });
  }

  void _unsubscribeToOrders(uid){
    _clients[uid]["subscription"].cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _clientsController.close();
  }



}