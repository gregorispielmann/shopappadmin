import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopappadmin/widgets/OrderHeader.dart';

class OrderTile extends StatelessWidget {

  final order;

  final status = ['', 'Em preparação', 'Em transporte', 'Aguardando entrega', 'Entregue'];

  OrderTile(this.order);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Card(
        child: ExpansionTile(
          key: Key(order.documentID),
          title: Text('#${order.documentID} - ${status[order['status']]}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: 
          order['status'] != 4 ? Colors.grey : Colors.green
          ),),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                OrderHeader(order),
                SizedBox(height: 20),
                Container(child: Text('Itens do pedido', style: TextStyle(fontSize: 12,color: Colors.black45))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: order.data['products'].map<Widget>((p){
                    return ListTile(
                      title: Text('${p['product']['title']} ${p['size']}'),
                      subtitle: Text('${p['category']}/${p['pid']}'),
                      trailing: Text(p['quantity'].toString()),
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        Firestore.instance.collection('users').document(order['clientId']).collection('orders').document(order.documentID).delete();
                        order.reference.delete();
                      },
                      textColor: Colors.red,
                      child: Text('Excluir'),
                    ),
                    FlatButton(
                      onPressed: order['status'] > 1 ? (){
                        order.reference.updateData({'status': order.data['status'] - 1});
                      } : null,
                      textColor: Colors.grey[700],
                      child: Text('Regredir'),
                    ),
                    FlatButton(
                      onPressed: order['status'] < 4 ? (){
                        order.reference.updateData({'status': order.data['status'] + 1});
                      } : null,
                      textColor: Colors.green,
                      child: Text('Avançar'),
                    ),
                  ],
                )
            ],),
          )
        ],
        ),
      )
    );
  }
}