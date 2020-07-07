import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {

  final VoidCallback onPressed;
  final Icon icon;
  final String label;
  final Color color;


  ButtonWithIcon({@required this.onPressed,this.icon,this.label,this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:25.0),
      child: SizedBox(
        width: double.infinity,
        height: 45.0,
        child: RaisedButton.icon(
            onPressed: onPressed,
            icon: icon,
            label: Text(label,style: TextStyle(fontSize: 18.0),),
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            color: color,
        ),
      ),
    );
  }
}


