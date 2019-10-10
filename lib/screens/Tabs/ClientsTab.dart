import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:shopappadmin/blocs/ClientsBloc.dart';
import 'package:shopappadmin/screens/Tabs/ClientTile.dart';

class ClientsTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final _clientBloc = BlocProvider.of<ClientsBloc>(context);

    return SafeArea(
        child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Pesquisar',
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.search, color: Colors.white,),
                border: InputBorder.none
              ),
              onChanged: _clientBloc.onChangedSearch,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _clientBloc.outClients,
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.pink),),);
                } else if (snapshot.data.length == 0){
                  return Center(child: Text('Nenhum usuário encontrado!', style: TextStyle(color: Colors.white),),);
                } else {
                  return ListView.separated(
                    itemBuilder: (context, index){
                      return ClientTile(snapshot.data[index]);
                    },
                    separatorBuilder: (context, index){
                      return Divider();
                    },
                    itemCount: snapshot.data.length,
                  );
                }
              }
            ),
          )
        ],
      ),
    );
  }
}