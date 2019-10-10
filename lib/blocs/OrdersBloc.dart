import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SortFilter { READY_FIRST, READY_LAST }

class OrdersBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List>();

  Stream get outOrders => _ordersController.stream;

  List<DocumentSnapshot> _orders = [];

  Firestore _firestore = Firestore.instance;

  SortFilter _criteria;

  //constructor
  OrdersBloc() {
    _addOrdersListener();
  }

  void _addOrdersListener() {
    _firestore.collection('orders').snapshots().listen((onData) {
      onData.documentChanges.forEach((f) {
        String oid = f.document.documentID;

        switch (f.type) {
          case DocumentChangeType.added:
            _orders.add(f.document);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.documentID == oid);
            _orders.add(f.document);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.documentID == oid);
            break;
        }
      });

      _ordersController.add(_orders);
    });
  }

  // ordenação
  void setOrder(criteria) {
    _criteria = criteria;
    _sort();
  }

  void _sort() {
    switch (_criteria) {
      case SortFilter.READY_FIRST:
        _orders.sort((a, b) {
          int sa = a.data["status"];
          int sb = b.data["status"];

          if (sa < sb)
            return 1;
          else if (sa > sb)
            return -1;
          else
            return 0;
        });
        break;

      case SortFilter.READY_LAST:
        _orders.sort((a, b) {
          int sa = a.data["status"];
          int sb = b.data["status"];

          if (sa > sb)
            return 1;
          else if (sa < sb)
            return -1;
          else
            return 0;
        });
        break;
    }
    _ordersController.add(_orders);
  }

  @override
  void dispose() {
    _ordersController.close();
  }
}
