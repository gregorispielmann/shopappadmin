import 'package:flutter/material.dart';
import 'package:shopappadmin/widgets/AddSizeDialog.dart';

class ProductSizes extends FormField<List> {
  ProductSizes({
    BuildContext context,
    List initialValue,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
  }) : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              print(initialValue);
              return SizedBox(
                height: 35,
                child: GridView(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5),
                  children: state.value.map((s) {
                    print('s -> ' + s);
                    return GestureDetector(
                      onLongPress: () {
                        state.didChange(state.value..remove(s));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.pink, width: 3)),
                        alignment: Alignment.center,
                        child: Text(
                          s.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList()
                    ..add(
                      GestureDetector(
                          onTap: () async {
                            String size = await showDialog(
                                context: context,
                                builder: (context) => AddSizeDialog());
                            if (size != null && size != '')
                              state.didChange(state.value..add(size));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                border: Border.all(
                                    color: state.hasError
                                        ? Colors.red
                                        : Colors.pink,
                                    width: 3)),
                            alignment: Alignment.center,
                            child: Text(
                              '+',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                ),
              );
            });
}
