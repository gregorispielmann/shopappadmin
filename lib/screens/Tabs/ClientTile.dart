import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ClientTile extends StatelessWidget {
  final Map<String, dynamic> client;

  ClientTile(this.client);

  final textStyle = TextStyle(color: Colors.white, fontSize: 12);

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
          Text('Total de Pedidos R\$ ${client['money'] != null ? client['money'].toStringAsFixed(2).replaceAll('.',',') : '0,00'}', style: textStyle,)
        ],
      ),
    );


    } else {
    
    
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
        width: 100,
        height: 10,
        child: Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.white,
                    child: Container(color: Colors.white,)),
              ),
    );
    }
  }
}
