import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopappadmin/screens/Tabs/ProductScreen.dart';
import 'package:shopappadmin/widgets/CategoryDialog.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot category;

  CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
          child: ExpansionTile(
            leading: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => CategoryDialog(
                          category: category,
                        ));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  category.data['icon'],
                ),
                backgroundColor: Colors.white,
              ),
            ),
            title: Text(
              category.data['title'],
              style: TextStyle(
                  color: Colors.grey[850], fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              FutureBuilder<QuerySnapshot>(
                future: category.reference.collection('items').getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return Column(
                      children: snapshot.data.documents.map((doc) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductScreen(
                                  product: doc,
                                  categoryId: category.documentID,
                                )));
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doc.data['images'][0]),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(doc.data['title']),
                      trailing:
                          Text("R\$ ${doc.data['price'].replaceAll('.', ',')}"),
                    );
                  }).toList()
                        ..add(ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.add,
                              color: Colors.pink,
                            ),
                          ),
                          title: Text('Adicionar'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                      product: null,
                                      categoryId: category.documentID,
                                    )));
                          },
                        )));
                },
              )
            ],
          ),
        ));
  }
}
