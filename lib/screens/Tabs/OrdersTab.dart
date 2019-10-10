import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:shopappadmin/blocs/OrdersBloc.dart';

import 'OrderTile.dart';

class OrdersTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final _ordersBloc = BlocProvider.of<OrdersBloc>(context);

    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: StreamBuilder<List>(
              stream: _ordersBloc.outOrders,
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),);
                } else if(snapshot.data.length == 0){
                  return Center(child: Text('Nenhum pedido encontrado!', style: TextStyle(color: Colors.white),),);
                } else {
                  return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    return OrderTile(snapshot.data[index]);
                  },
                );
                }
              }
            )
      ),
    );
  }
}