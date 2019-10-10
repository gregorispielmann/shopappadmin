import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shopappadmin/blocs/ClientsBloc.dart';
import 'package:shopappadmin/blocs/OrdersBloc.dart';
import 'package:shopappadmin/screens/Tabs/ClientsTab.dart';
import 'package:shopappadmin/screens/Tabs/OrdersTab.dart';
import 'package:shopappadmin/screens/Tabs/ProductsTabs.dart';
import 'package:shopappadmin/widgets/CategoryDialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;

  ClientsBloc _clientBloc = ClientsBloc();
  OrdersBloc _ordersBloc = OrdersBloc();

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
        onTap: (p) {
          _pageController.animateToPage(p,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Clientes')),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text('Pedidos')),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text('Produtos')),
        ],
      ),
      body: BlocProvider(
        bloc: _clientBloc,
        child: BlocProvider(
          bloc: _ordersBloc,
          child: PageView(
            onPageChanged: (p) {
              setState(() {
                _page = p;
              });
            },
            controller: _pageController,
            children: <Widget>[ClientsTab(), OrdersTab(), ProductsTab()],
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch (_page) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pink,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(Icons.arrow_downward, color: Colors.pink),
                backgroundColor: Colors.white,
                label: 'Concluídos Abaixo',
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrder(SortFilter.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Colors.pink),
                backgroundColor: Colors.white,
                label: 'Concluídos Acima',
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrder(SortFilter.READY_FIRST);
                }),
          ],
        );
      case 2:
        return FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.pink,
            onPressed: () {
              showDialog(
                  context: context, builder: (context) => CategoryDialog());
            });
    }
  }
}
