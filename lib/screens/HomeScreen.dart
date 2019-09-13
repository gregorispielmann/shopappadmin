import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:shopappadmin/blocs/ClientsBloc.dart';
import 'package:shopappadmin/screens/Tabs/ClientsTab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController;
  
  ClientsBloc _clientBloc = ClientsBloc();

  int _page = 0;

  @override
  void initState() { 
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() { 
    _pageController.dispose();
    _clientBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink,
        unselectedItemColor: Colors.white38,
        selectedItemColor: Colors.white,
        onTap: (p){
          _pageController.animateToPage(p, duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Clientes')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Pedidos')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Produtos')
          ),
        ],
      ),
      body: BlocProvider(
          bloc: _clientBloc,
          child: PageView(
          onPageChanged: (p){
            setState(() {
            _page = p;
            });
          },
          controller: _pageController,
          children: <Widget>[
            ClientsTab(),
            Container(color: Colors.yellow,),
            Container(color: Colors.blue,),
          ],
        ),
      ),
    );
  }
}