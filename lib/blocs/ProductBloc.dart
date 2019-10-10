import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/subjects.dart';

class ProductBloc extends BlocBase {
  //controlador
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  //stream
  Stream get outData => _dataController.stream;
  Stream get outLoading => _loadingController.stream;
  Stream get outCreated => _createdController.stream;

  String categoryId;
  DocumentSnapshot product;

  Map<String, dynamic> unsavedData;

  ProductBloc({this.categoryId, this.product}) {
    if (product != null) {
      unsavedData = Map.of(product.data);
      unsavedData['images'] = List.of(product.data['images']);
      unsavedData['sizes'] = List.of(product.data['sizes']);

      _createdController.add(true);
    } else {
      unsavedData = {
        "title": null,
        "description": null,
        "price": null,
        "images": [],
        "sizes": []
      };
    }

    _dataController.add(unsavedData);
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }

  void saveImages(images) {
    unsavedData['images'] = images;
  }

  void saveTitle(title) {
    unsavedData['title'] = title;
  }

  void saveDescription(description) {
    unsavedData['description'] = description;
  }

  void savePrice(price) {
    unsavedData['price'] = price;
  }

  Future<bool> saveProduct() async {
    _loadingController.add(true);
    _createdController.add(false);

    try {
      if (product != null) {
        await _uploadImages(product.documentID);
        await product.reference.updateData(unsavedData);
      } else {
        DocumentReference dr = await Firestore.instance
            .collection('products')
            .document(categoryId)
            .collection('items')
            .add(Map.from(unsavedData)..remove('images'));
        await _uploadImages(dr.documentID);
        await dr.updateData(unsavedData);
      }
      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e) {
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(productId) async {
    for (int i = 0; i < unsavedData['images'].length; i++) {
      if (unsavedData['images'][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoryId)
          .child(productId)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsavedData['images'][i]);

      StorageTaskSnapshot s = await uploadTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();

      unsavedData['images'][i] = downloadUrl;
    }
  }

  void deleteProduct() {
    product.reference.delete();
  }
}
