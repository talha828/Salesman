import 'package:flutter/material.dart';
import 'package:salesmen_app_new/others/style.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key key,
     this.width,
     this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        color: Colors.white.withOpacity(0.5),
        child: Center(child: CircularProgressIndicator(color: themeColor1,)));
  }
}