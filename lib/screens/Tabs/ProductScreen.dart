import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopappadmin/blocs/ProductBloc.dart';
import 'package:shopappadmin/validators/ProductValidator.dart';
import 'package:shopappadmin/widgets/ImagesWidget.dart';
import 'package:shopappadmin/widgets/ProductSizes.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {
  final ProductBloc _productBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProductScreenState(categoryId, product)
      : _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    final fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );

    InputDecoration fieldDecoration(label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey));
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? 'Editar Produto' : 'Criar Produto');
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
              initialData: false,
              stream: _productBloc.outCreated,
              builder: (context, snapshot) {
                if (snapshot.data)
                  return StreamBuilder<bool>(
                      initialData: false,
                      stream: _productBloc.outLoading,
                      builder: (context, snapshot) {
                        return IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: snapshot.data
                              ? null
                              : () {
                                  _productBloc.deleteProduct();
                                  Navigator.of(context).pop();
                                },
                        );
                      });
                else
                  return Container();
              }),
          StreamBuilder<bool>(
              initialData: false,
              stream: _productBloc.outLoading,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : saveProduct,
                );
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _productBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(10),
                    children: <Widget>[
                      Text(
                        'Imagens',
                        style: TextStyle(color: Colors.grey),
                      ),
                      ImagesWidget(
                          context: context,
                          initialValue: snapshot.data['images'],
                          onSaved: _productBloc.saveImages,
                          validator: validateImage),
                      TextFormField(
                        initialValue: snapshot.data['title'],
                        style: fieldStyle,
                        decoration: fieldDecoration("Título"),
                        onSaved: _productBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data['description'],
                        style: fieldStyle,
                        decoration: fieldDecoration("Descrição"),
                        maxLines: 6,
                        onSaved: _productBloc.saveDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                        initialValue: snapshot.data['price'],
                        style: fieldStyle,
                        decoration: fieldDecoration("Preço"),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: _productBloc.savePrice,
                        validator: validatePrice,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Tamanhos',
                        style: TextStyle(color: Colors.grey),
                      ),
                      ProductSizes(
                        context: context,
                        initialValue: snapshot.data['sizes'],
                        onSaved: (s) {},
                        validator: (s) {
                          if (s.isEmpty) return 'Adicione um tamanho!';
                        },
                      )
                    ],
                  );
                }),
          ),
          StreamBuilder(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IgnorePointer(
                ignoring: !snapshot.data,
                child: Stack(
                  children: <Widget>[
                    Container(
                      color:
                          snapshot.data ? Colors.black54 : Colors.transparent,
                    ),
                    snapshot.data
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Container(),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      print(_scaffoldKey.currentState);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text('Salvando produto...', style: TextStyle(color: Colors.white)),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.pink,
      ));

      bool success = await _productBloc.saveProduct();
      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            success ? 'Produto salvo com sucesso!' : 'Erro ao salvar produto!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
        duration: Duration(minutes: 1),
      ));
    }
  }
}
