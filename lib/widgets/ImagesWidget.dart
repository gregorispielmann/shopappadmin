import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ImageSourceSheet.dart';

class ImagesWidget extends FormField<List> {
  ImagesWidget({
    BuildContext context,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
    List initialValue,
    bool autoValidate = false,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autoValidate,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 120,
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: state.value.map<Widget>((i) {
                          return Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              child: i is String
                                  ? Image.network(i, fit: BoxFit.cover)
                                  : Image.file(i, fit: BoxFit.cover),
                              onLongPress: () {
                                state.value.remove(i);
                                state.didChange(state.value);
                              },
                            ),
                          );
                        }).toList()
                          ..add(GestureDetector(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Icon(Icons.camera_alt),
                              color: Colors.white.withAlpha(50),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => ImageSourceSheet(
                                        onImageSelected: (image) {
                                          state.value.add(image);
                                          state.didChange(state.value);
                                          Navigator.of(context).pop();
                                        },
                                      ));
                            },
                          ))),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container()
                ],
              );
            });
}
