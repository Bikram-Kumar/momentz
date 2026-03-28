import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
const NotificationsScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Your Notifications will appear here."),
        ],
      ),
    );
  }
}