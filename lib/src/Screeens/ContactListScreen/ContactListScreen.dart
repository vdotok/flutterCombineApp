import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/home/CustomAppBar.dart';
import 'package:vdkFlutterChat/src/Screeens/home/NoChatScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/home/home.dart';
import 'package:vdkFlutterChat/src/Screeens/splash/splash.dart';
import 'package:vdkFlutterChat/src/constants/constant.dart';
import 'package:vdkFlutterChat/src/core/models/GroupModel.dart';
import 'package:vdkFlutterChat/src/core/providers/call_provider.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import '../../core/models/contact.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/contact_provider.dart';
import '../../core/providers/groupListProvider.dart';

bool isOneToOne = false;

class ContactListScreen extends StatefulWidget {
  final VoidCallback callbackfunction;
  final funct;
  final CallProvider calllProvider;
  const ContactListScreen(
      {Key key, this.callbackfunction, this.funct, this.calllProvider})
      : super(key: key);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  ContactProvider contactProvider;
  GroupListProvider groupListProvider;
  AuthProvider authProvider;
  CallProvider callProvider;
  int count = 0;
  var changingvaalue;
  List<Contact> _selectedContacts = [];
  final _groupNameController = TextEditingController();
  final _searchController = TextEditingController();
  List<Contact> _filteredList = [];
  bool notmatched = false;
  Emitter emitter;
  GlobalKey<ScaffoldState> scaffoldKey;
  bool loading = false;

  //bool isLoading = false;
  @override
  void initState() {
    // widget.callbackfunction();
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    contactProvider.getContacts(authProvider.getUser.auth_token);
    callProvider = Provider.of<CallProvider>(context, listen: false);
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    emitter = Emitter.instance;
  }

  onSearch(value) {
    List temp;

    temp = contactProvider.contactList.users.where((element) {
      return element.full_name.toLowerCase().startsWith(value.toLowerCase());
    }).toList();

    setState(() {
      if (temp.isEmpty) {
        notmatched = true;
        print("Here in true not matched");
      } else {
        print("Here in false matched");
        notmatched = false;
        _filteredList = temp;
      }
    });
    print("this is filtered list ${_filteredList[0].full_name}  ");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ContactProvider, AuthProvider, CallProvider>(builder:
        (context, contactListProvider, authProvider, callProvider, child) {
      if (contactListProvider.contactState == ContactStates.Loading)
        return SplashScreen();
      else if (contactListProvider.contactState == ContactStates.Success) {
        if (contactListProvider.contactList.users.length == 0)
          return NoChatScreen(
            emitter: emitter,
            groupListProvider: groupListProvider,
            presentCheck: false,
          );
        else
          return GestureDetector(
              onTap: () {
                FocusScopeNode currentFous = FocusScope.of(context);
                if (!currentFous.hasPrimaryFocus) {
                  currentFous.unfocus();
                }
              },
              child: Scaffold(
                appBar: CustomAppBar(
                    lead: true,
                    ischatscreen: false,
                    title: "New Chat",
                    succeedingIcon: '',
                    groupListProvider: groupListProvider),
                body: SafeArea(
                    child: Column(
                  children: [
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 21, right: 21),
                      child: TextFormField(
//textAlign: TextAlign.center,
                        controller: _searchController,
                        onChanged: (value) {
                          onSearch(value);
                        },
                        validator: (value) =>
                            value.isEmpty ? "Field cannot be empty." : null,
                        decoration: InputDecoration(
                          fillColor: refreshTextColor,
                          filled: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              'assets/SearchIcon.svg',
                              width: 20,
                              height: 20,
                              fit: BoxFit.fill,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: searchbarContainerColor)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: searchbarContainerColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: searchbarContainerColor)),
                          hintText: "Search",
                          hintStyle: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: searchTextColor,
                              fontFamily: secondaryFontFamily),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        print("in gesture detector");
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                left: 13,
                                right: 13,
                              ),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  SvgPicture.asset('assets/GroupChatIcon.svg'),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/createGroup',
                                    arguments: {
                                      "groupListProvider": groupListProvider,
                                      // "callProvider": callProvider,
                                      "funct": widget.funct
                                      // "callbackfunction": _startCall
                                    });
                              },
                              child: SizedBox(
                                width: 236,
                                child: Text(
                                  "Add Group Chat",
                                  style: TextStyle(
                                    color: addGroupChatColor,
                                    fontSize: 16,
                                    fontFamily: primaryFontFamily,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 370,
                      child: Divider(
                        thickness: 1,
                        color: listdividerColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Contacts",
                            style: TextStyle(
                                color: contactColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: secondaryFontFamily)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: Scrollbar(
                        child: notmatched == true
                            ? Text("No data Found")
                            : ListView.separated(
                                shrinkWrap: true,
                                //  padding: const EdgeInsets.only(top: 5),
                                itemCount: _searchController.text.isEmpty
                                    ? contactProvider.contactList.users.length
                                    : _filteredList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var test = _searchController.text.isEmpty
                                      ? contactProvider.contactList.users[index]
                                      : _filteredList[index];
                                  var groupIndex = groupListProvider
                                      .groupList.groups
                                      .indexWhere((element) =>
                                          element.group_title ==
                                          authProvider.getUser.full_name +
                                              test.full_name);

                                  return Column(
                                    children: [
                                      ListTile(
                                          // onTap: () {
                                          //   if (_selectedContacts.indexWhere(
                                          //           (contact) =>
                                          //               contact.user_id ==
                                          //               element.user_id) !=
                                          //       -1) {
                                          //     setState(() {
                                          //       _selectedContacts.remove(element);
                                          //     });
                                          //   } else {
                                          //     setState(() {
                                          //       _selectedContacts.add(element);
                                          //     });
                                          //   }
                                          // },
                                          leading: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: SvgPicture.asset(
                                                'assets/User.svg'),
                                          ),
                                          title: Text(
                                            "${test.full_name}",
                                            // "hello",
                                            style: TextStyle(
                                              color: contactNameColor,
                                              fontSize: 16,
                                              fontFamily: primaryFontFamily,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    print("onTap called.");
                                                    signalingClient
                                                        .startCallonetoone(
                                                            from: authProvider
                                                                .getUser.ref_id,
                                                            to: [test.ref_id],
                                                            meidaType:
                                                                CallMediaType
                                                                    .audio,
                                                            callType: CAllType
                                                                .one2one,
                                                            sessionType:
                                                                SessionType
                                                                    .call);
                                                    // widget.funct(
                                                    //     [test.ref_id],
                                                    //     CallMediaType.audio,
                                                    //     CAllType.one2one,
                                                    //     SessionType.call);
                                                    setState(() {
                                                      callTo = test.full_name;
                                                      meidaType =
                                                          CallMediaType.audio;
                                                      isOneToOne = true;

                                                      print(
                                                          "this is callTo $callTo");
                                                    });
                                                    iscalloneto1 = true;
                                                    print(
                                                        "TJIS IS WIDGET>CALL DDFDD ${widget.calllProvider}");
                                                    widget.calllProvider
                                                        .callDial();
                                                    //  callProvider.callDial();
                                                    print(
                                                        "three dot icon pressed");
                                                    callTo = test.full_name
                                                        .toString();
                                                    // widget.funct([test.ref_id.toString()], CallMediaType.audio,
                                                    //       CAllType.one2one, SessionType.call);
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 15),
                                                    child: SvgPicture.asset(
                                                        'assets/call.svg'),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    print("onTap called.");

                                                    signalingClient
                                                        .startCallonetoone(
                                                            from: authProvider
                                                                .getUser.ref_id,
                                                            to: [test.ref_id],
                                                            meidaType:
                                                                CallMediaType
                                                                    .video,
                                                            callType: CAllType
                                                                .one2one,
                                                            sessionType:
                                                                SessionType
                                                                    .call);
                                                    // _startCall(
                                                    //     [test.ref_id],
                                                    //     CallMediaType.video,
                                                    //     CAllType.one2one,
                                                    //     SessionType.call);
                                                    // setState(() {
                                                    //   callTo = test.full_name;
                                                    //   meidaType =
                                                    //       CallMediaType.video;
                                                    //   print(
                                                    //       "this is callTo $callTo");
                                                    // });
                                                    iscalloneto1 = true;
                                                    setState(() {
                                                      callTo = test.full_name;
                                                      meidaType =
                                                          CallMediaType.video;

                                                      print(
                                                          "this is callTo $callTo");
                                                    });
                                                    print(
                                                        "TJIS IS WIDGET>CALL DDFDD ${widget.calllProvider}");
                                                    widget.calllProvider
                                                        .callDial();
                                                    print(
                                                        "three dot icon pressed");
                                                    callTo = test.full_name
                                                        .toString();
                                                    // widget.funct([test.ref_id.toString()], CallMediaType.video,
                                                    //       CAllType.one2one, SessionType.call);
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 16),
                                                    child: SvgPicture.asset(
                                                        'assets/videocallicon.svg'),
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: loading == false
                                                        ? () async {
                                                            groupListProvider
                                                                .handleCreateChatState();
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            _selectedContacts
                                                                .add(test);
                                                            print(
                                                                "the selected contacts:${test.full_name}");
                                                            var res = await contactProvider.createGroup(
                                                                authProvider
                                                                        .getUser
                                                                        .full_name +
                                                                    _selectedContacts[
                                                                            0]
                                                                        .full_name,
                                                                _selectedContacts,
                                                                authProvider
                                                                    .getUser
                                                                    .auth_token);
                                                            // var getGroups=await

                                                            print(
                                                                "this is already created index ${res["is_already_created"]}");
                                                            GroupModel
                                                                groupModel =
                                                                GroupModel
                                                                    .fromJson(res[
                                                                        "group"]);
                                                            print(
                                                                "this is group index $groupIndex");
                                                            print(
                                                                "this is response of createGroup ${groupModel.participants[0].full_name}, ${groupModel.participants[1].full_name}");

                                                            int channelIndex =
                                                                0;
                                                            if (res[
                                                                "is_already_created"]) {
                                                              channelIndex = groupListProvider
                                                                  .groupList
                                                                  .groups
                                                                  .indexWhere((element) =>
                                                                      element
                                                                          .channel_key ==
                                                                      res["group"]
                                                                          [
                                                                          "channel_key"]);

                                                              print(
                                                                  "this is already created index $channelIndex");
                                                            } else {
                                                              groupListProvider
                                                                  .addGroup(
                                                                      groupModel);
                                                              groupListProvider
                                                                  .subscribeChannel(
                                                                      groupModel
                                                                          .channel_key,
                                                                      groupModel
                                                                          .channel_name);
                                                              groupListProvider
                                                                  .subscribePresence(
                                                                      groupModel
                                                                          .channel_key,
                                                                      groupModel
                                                                          .channel_name,
                                                                      true,
                                                                      true);
                                                            }

                                                            publishMessage(
                                                                key,
                                                                channelname,
                                                                sendmessage) {
                                                              print(
                                                                  "The key:$key....$channelname...$sendmessage");
                                                              emitter.publish(
                                                                  key,
                                                                  channelname,
                                                                  sendmessage);
                                                            }

                                                            Navigator.pushNamed(
                                                                context,
                                                                "/chatScreen",
                                                                arguments: {
                                                                  "index":
                                                                      channelIndex,
                                                                  "publishMessage":
                                                                      publishMessage,
                                                                  "groupListProvider":
                                                                      groupListProvider,
                                                                  "callProvider":
                                                                      callProvider,
                                                                  "funct":
                                                                      widget
                                                                          .funct
                                                                });
                                                            _selectedContacts
                                                                .clear();
                                                            groupListProvider
                                                                .handleCreateChatState();
                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          }
                                                        : () {},
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 15),
                                                      child: SvgPicture.asset(
                                                          'assets/messageicon.svg'),
                                                    )),
                                              ]))
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Divider(
                                      thickness: 1,
                                      color: listdividerColor,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                )),
              ));
      } else {
        return Scaffold(
          backgroundColor: chatRoomBackgroundColor,
          appBar: CustomAppBar(
            groupListProvider: groupListProvider,
            title: "New Chat",
            lead: true,
            succeedingIcon: '',
            ischatscreen: false,
          ),
          body: Center(
              child: Text(
            "${contactProvider.errorMsg}",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          )),
        );
      }
    });
  }
}
