import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ClientTile extends StatelessWidget {

  final Map<String, dynamic> client;

  ClientTile( this.client );

  final textStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    if(client.containsKey('money')){
      return ListTile(
        title: Text(client['name'], style: textStyle,),
        subtitle: Text(client['email'], style: textStyle,),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('Pedidos: ${client['orders'] != null && client['orders'] != 0 ? client['orders'] : 'Nenhum'}', style: textStyle,),
            Text('Total de Pedidos R\$ ${client['total'] != null ? client['total'].toStringAsFixed(2).replaceAll('.',',') : '0,00'}', style: textStyle,)
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(10),
        child: SizedBox(
          width: 200.0,
          height: 20.0,
          child: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.grey,
            child: Container(
              color: Colors.white.withAlpha(80)
            ),
          ),
        )
      );
    }
}
}