import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/core/providers/call_provider.dart';
import '../ContactListScreen/ContactListScreen.dart';
import '../../core/providers/contact_provider.dart';

class ContactListIndex extends StatefulWidget {
  final funct;
  final CallProvider callProvider;
  const ContactListIndex({Key key, this.funct, this.callProvider}) : super(key: key);

  @override
  _ContactListIndexState createState() => _ContactListIndexState();
}

class _ContactListIndexState extends State<ContactListIndex> {
  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider(create: (context) => ContactProvider(), child: ContactListScreen());
    
  // }
  @override
 Widget build(BuildContext context) {
   
 return MultiProvider( providers: [
 ChangeNotifierProvider(create: (context) => ContactProvider()), 
 ChangeNotifierProvider(create: (context) => CallProvider()), 
 
 ],
 child: ContactListScreen(funct: widget.funct,calllProvider:widget.callProvider)
 );
 
 }
}
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vdkFlutterChat/src/core/providers/call_provider.dart';
// import '../ContactListScreen/ContactListScreen.dart';
// import '../../core/providers/contact_provider.dart';

// class ContactListIndex extends StatefulWidget {
//   final VoidCallback callbackfunction;
//   const ContactListIndex({Key key, this.callbackfunction}) : super(key: key);

//   @override
//   _ContactListIndexState createState() => _ContactListIndexState();
// }

// class _ContactListIndexState extends State<ContactListIndex> {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(providers: [
//       ChangeNotifierProvider(create: (context) => ContactProvider()),
//     //  ChangeNotifierProvider(create: (context) => CallProvider()),
//     ], child: ContactListScreen(callbackfunction:widget.callbackfunction));
//   }
// }
