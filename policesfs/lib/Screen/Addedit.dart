import 'package:flutter/material.dart';
import 'package:policesfs/Screen/AddProduct.dart';
import 'package:policesfs/Screen/drawner.dart';

class Addedit extends StatelessWidget {
  static const routeName = '/edit-product';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width < 700
          ? AppBar(
              backgroundColor: Colors.pink[900],
              title: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: TextButton(onPressed: () {}, child: Text('Logout'))))
          : null,
      drawer: width < 700 ? drawerwidget() : null,
      body: Row(
        children: [
          if (width > 700)
            Flexible(
              flex: 2,
              child: Container(
                child: drawerwidget(),
              ),
            ),
          Expanded(
            flex: 6,
            child: Container(width: double.infinity, child: AddProductScreen()),
          ),
        ],
      ),
    );
  }
}
