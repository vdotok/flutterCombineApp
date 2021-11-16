import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/groupChatScreen/ChatScreen.dart';
import 'package:vdkFlutterChat/src/core/providers/auth.dart';
import 'package:vdkFlutterChat/src/core/providers/call_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import '../home/home.dart';
import '../../core/providers/groupListProvider.dart';

class ChatScreenIndex extends StatefulWidget {
  //bool state;
  final int index;
  final publishMessage;
  // final VoidCallback  callbackfunction;
  final CallProvider callProvider;
  final ContactProvider  contactprovider;
  final funct;
  final navigate;
  final pushCallback;
  ChatScreenIndex ({this.index, this.publishMessage,this.callProvider, this.funct, this.navigate, this.contactprovider, this.pushCallback});
  @override
  _ChatScreenIndexState createState() => _ChatScreenIndexState();
}

class _ChatScreenIndexState extends State<ChatScreenIndex> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // onPressed() {
  //   Provider.of<AuthProvider>(context).logout();
  // }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: ElevatedButton(onPressed: onPressed, child: Text("logout")),
  //   );
  // }
  // Widget build(BuildContext context) {
  //   return MultiProvider(providers: [
  //     ChangeNotifierProvider<GroupListProvider>(
  //       create: (context) => GroupListProvider(),
  //     )
  //   ], child: Home(widget.state));
  // }
  Widget build(BuildContext context) {
 return MultiProvider( providers: [
//  ChangeNotifierProvider<GroupListProvider>(
//  create: (context) => GroupListProvider()),
 ChangeNotifierProvider(create: (context) => ContactProvider()), 
 ChangeNotifierProvider(create: (context) => CallProvider()), 
 //ChangeNotifierProvider(create: (context) => GroupListProvider()),
 ////ChangeNotifierProvider(create: (context) => AuthProvider()), 
 //ChangeNotifierProvider(create: (context) => GroupListProvider()), 
 
 ],
 child: ChatScreen(
   index:widget.index,
 publishMessage:widget.publishMessage,
 callProvider: widget.callProvider,
 funct:widget.funct,
 navigate:widget.navigate,
  contactprovider:widget.contactprovider,
  pushCallback:widget.pushCallback
 )
 //callbackfunction:widget.callbackfunction)
 );
}
}
// class  extends StatefulWidget {
//   @override
//   _State createState() => _State();
// }

// class _State extends State<> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }
