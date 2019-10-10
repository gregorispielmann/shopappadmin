import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:shopappadmin/blocs/ClientsBloc.dart';

class OrderHeader extends StatelessWidget {

  final order;

  OrderHeader(this.order);

  @override
  Widget build(BuildContext context) {

    final _clientsBloc = BlocProvider.of<ClientsBloc>(context);

    final client = _clientsBloc.getClient(order['clientId']);

    return Row(

      children: <Widget>[
        Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${client['name']}', style: TextStyle(fontWeight: FontWeight.bold),),
              Text('${client['address']}'),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('Produtos R\$${order['productsPrice'].toStringAsFixed(2).replaceAll('.',',')}'),
            Text('Total R\$${order['totalPrice'].toStringAsFixed(2).replaceAll('.',',')}'),
          ],
        )
      ],
    );
  }
}