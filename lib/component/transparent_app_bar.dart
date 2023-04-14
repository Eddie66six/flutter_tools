import 'package:flutter/material.dart';

class TransparentAppBar extends PreferredSize {
  final Function? onBack;
  TransparentAppBar({this.onBack}) : super(child: SizedBox(), preferredSize: Size.fromHeight(40));
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(onBack == null){
          Navigator.of(context).pop();
        }
        else{
          onBack!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.arrow_back)
          ],
        ),
      ),
    );
  }
}