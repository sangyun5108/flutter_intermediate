import 'package:flutter/material.dart';

import '../layout/default_layout.dart';

class RootTap extends StatelessWidget {
  const RootTap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      backgroundColor: null,
      child:Center(
        child: Text('Root Tap'),
    ),
    );
  }
}
