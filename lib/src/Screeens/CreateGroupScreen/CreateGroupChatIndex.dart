import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/core/providers/call_provider.dart';
import '../CreateGroupScreen/CreateGroupChatScreen.dart';
import '../../core/providers/contact_provider.dart';

class CreateGroupChatIndex extends StatefulWidget {
  final funct;
  const CreateGroupChatIndex({Key key, this.funct}) : super(key: key);
  
  @override
  _CreateGroupChatIndexState createState() => _CreateGroupChatIndexState();
}

class _CreateGroupChatIndexState extends State<CreateGroupChatIndex> {
  @override
  Widget build(BuildContext context) {
  
    

return MultiProvider( providers: [
ChangeNotifierProvider(create: (context) => ContactProvider()), 
ChangeNotifierProvider(create: (context) => CallProvider()), 


    ], child: CreateGroupChatScreen(funct:widget.funct));
  }
}
