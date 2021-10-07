import 'package:flutter/material.dart';

class Edit extends StatelessWidget {
  static final routeName = 'Edit';

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)?.settings.arguments;

    print(id);

    return Container();
  }
}
