import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/ContactListScreen/ContactListScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/groupChatScreen/ChatScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/home/streams/remoteStream.dart';
import 'package:vdkFlutterChat/src/constants/constant.dart';
import 'package:vdkFlutterChat/src/core/models/contactList.dart';
import 'package:vdkFlutterChat/src/core/providers/auth.dart';
import 'package:vdkFlutterChat/src/core/providers/call_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/groupListProvider.dart';
import 'package:vdkFlutterChat/src/shared_preference/shared_preference.dart';
import 'home/home.dart';

class CallStartScreen extends StatefulWidget {
  final mediaType;
  final remoteRenderer;
  final callTo;
  final incomingfrom;
  final groupName;
  final callingTo;
  // final onRemoteStream;
  //final pressDuration;
  final CallProvider callProvider;
  final AuthProvider authProvider;
  final ContactProvider contactProvider;
  final GroupListProvider groupListprovider;
  final localRenderer;
  final VoidCallback stopCall;
  // final SignalingClient signalingClient;
  final registerRes;
  final ContactList contactList;
  final VoidCallback popCallBAck;
  //final statsvalue;
  // final rendererListWithRefID;
  // final remoteVideoFlag;

  const CallStartScreen({
    Key key,
    this.mediaType,
    this.remoteRenderer,
    this.callTo,
    this.incomingfrom,
    // this.pressDuration,

    this.localRenderer,
    this.stopCall,
    // this.signalingClient,
    this.registerRes,
    this.callProvider,
    this.authProvider,
    this.contactProvider,
    this.contactList,
    this.popCallBAck,
    this.groupListprovider,
    this.groupName,
    this.callingTo,
    //this.statsvalue,
    // this.onRemoteStream,
    // this.rendererListWithRefID,
    // this.remoteVideoFlag,
  }) : super(key: key);

  @override
  _CallStartScreenState createState() => _CallStartScreenState();
}

class _CallStartScreenState extends State<CallStartScreen> {
  DateTime _time;
  Timer _ticker;
  int index = 0;
  bool isSmallScreen = false;
  SharedPref sharedPref = SharedPref();
  String _pressDuration = "00:00";
  String callername = "";
  var number;
  var number1;
  double upstream;
  double downstream;
  double statsval = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //  print("skfsdkfnsdkgndskfgndf ${widget.groupListprovider.statsvalue}");
    //        number= double.parse((widget.groupListprovider.statsvalue).toStringAsFixed(2));
    //Timer.periodic(Duration(seconds: 2), (Timer t) {
//   signalingClient.onCallstats=(timeStats){
// //    if(timeStats==null)
// // {
// //   print("in null value");
// // }
// // else{
//   print("NOT NULL  $timeStats");
//   setState(() {
//     number=timeStats;
//   });
// //  number=timeStats;
// //}    // statsval=timeStats;
//         //  setState(() {

//         //    number=  double.parse((timeStats).toStringAsFixed(2));
//         //    print(">>>>>>>> $timeStats");
//         // // number=timeStats;
//         //  });
//          // number= double.parse((timeStats).toStringAsFixed(2));
//         // statsvalue=timeStats/1024;
//         //groupListProvider.statsValue(timeStats);
//     };
    //});
    print("this is group name in call start screnn ${callTo}");
    print("this is time in Call Accept Screen $time");
    if (time == null) {
      _time = DateTime.now();
    } else {
      _time = time;
    }

    _updateTimer();
    _ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
    print("IS A INDEX ${widget.incomingfrom}");
    if (widget.incomingfrom != null) {
      index = widget.contactList.users
          .indexWhere((element) => element.ref_id == widget.incomingfrom);
      print("IS A INDEX $index");
      callername = widget.contactList.users[index].full_name;
      print("this is caller name in accept screen ${callername}");
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    if (twoDigitHours == "00")
      return "$twoDigitMinutes:$twoDigitSeconds";
    else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  void _updateTimer() {
    //_time = DateTime.now();
    final duration = DateTime.now().difference(_time);
    final newDuration = _formatDuration(duration);
    //if (mounted) {

    setState(() {
      // Your state change code goes here
      _pressDuration = newDuration;
      //number=  double.parse((statsval).toStringAsFixed(2));
      print("IN SET STATE SINGNALING CLIENT>PRESS DURATION $_time");

      //  sharedPref.save("Duration", _pressDuration);
    });
    //}
    //  setState(() {

    //   });
  }

  @override
  dispose() {
    _ticker.cancel();
    // widget.localRenderer.dispose();
    // widget.remoteRenderer.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    //  _groupListProvider.handlBacktoGroupList(index);
    //  Navigator.pop(context);
    widget.groupListprovider.duration("");
    setState(() {
      isCallinProgress = true;
      isCallinProgress1 = true;
      print("iscallingprogress $isCallinProgress");
    });

    widget.groupListprovider.callProgress(true);
    // pressDuration=_pressDuration;
    time = _time;
    // timee=_time;
    widget.popCallBAck();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));
    print("Hey ! i am in widget build of Call Accept Screen");
    signalingClient.onCallStatsuploads = (uploadstats) {
      var nummm = uploadstats;
      String dddi = nummm.toString();
      print("DFKMDKSDF//MNKSDFMDKS 0000000$dddi");

      double myDouble = double.parse(dddi);
      assert(myDouble is double);

      print("dfddfdfdfffffffffffffffff ${myDouble / 1024}"); // 123.45
      upstream = double.parse((myDouble / 1024).toStringAsFixed(2));
    };
    signalingClient.onCallstats = (timeStatsdownloads, timeStatsuploads) {
      //setState(() {
      print("NOT NULL  $timeStatsdownloads");
      // double d2=double.valueOf(timeStatsdownloads);
      number = timeStatsdownloads;
      String ddd = number.toString();
      print("DFKMDKSDFMNKSDFMDKS $ddd");

      double myDouble = double.parse(ddd);
      assert(myDouble is double);

      print("dfddfdfdf ${myDouble / 1024}"); // 123.45
      downstream = double.parse((myDouble / 1024).toStringAsFixed(2));

//    number1=timeStatsuploads;

//     String ddd1=number1.toString();
//     print("DFKMDKSDFMNKSDFMDKS $ddd1");

// double myDouble1 = double.parse(ddd1);
// assert(myDouble1 is double);

// print("dfddfdfdf ${myDouble1/1024}"); // 123.45
// upstream=  double.parse((myDouble1/1024).toStringAsFixed(2));

      // });
    };
//  print("skfsdkfnsdkgndskfgndf ${widget.groupListrovider.statsvalue}");
//          number= double.parse((widget.groupListprovider.statsvalue).toStringAsFixed(2));
    // print("THIS IS RENDERER LIST LENGTH1 ${widget.mediaType}");
    // print("DNJDNJDGNJDHGJDHGJ $callername");
    //  print("THIS IS RENDERER LIST LENGTH1/ ${rendererListWithRefID.first["remoteVideoFlag"]}....${widget.mediaType}");
//print("THIS IS SPEAKER STATE $RemoteStream.... ${forLargStream["rtcVideoRenderer"]}...$rendererListWithRefID");
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          // appBar: AppBar(
          //  backgroundColor:
          //   backgroundAudioCallDark,
          // // backgroundColor: Color.transparent,
          // elevation: 0.0,
          //   leading: new IconButton(
          //     icon: new Icon(Icons.arrow_back_ios_new_outlined),
          //     onPressed:() {
          //       widget.groupListprovider.duration("");
          //       setState(() {
          //         isCallinProgress=true;
          //         isCallinProgress1=true;
          //         print("iscallingprogress $isCallinProgress");
          //       });

          //       widget.groupListprovider.callProgress(true);

          //        time=_time;
          //       widget.popCallBAck();
          //       // setState(() {
          //       //   isSmallScreen=true;
          //       // });
          //       }
          //   ),
          // ),

          body: OrientationBuilder(builder: (context, orientation) {
            return Container(
                child: Stack(
              children: [
                onRemoteStream
                    ? forLargStream["remoteVideoFlag"] == 0
                        ? Container(
                            decoration:
                                BoxDecoration(color: backgroundAudioCallLight),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/userIconCall.svg',
                                  ),
                                  Text(widget
                                      .contactProvider
                                      .contactList
                                      .users[widget
                                          .contactProvider.contactList.users
                                          .indexWhere((element) =>
                                              element.ref_id ==
                                              forLargStream["refID"])]
                                      .full_name)
                                ],
                              ),
                            ),
                          )
                        : RemoteStream(
                            remoteRenderer: forLargStream["rtcVideoRenderer"],
                          )
                    : Container(
                        decoration:
                            BoxDecoration(color: backgroundAudioCallLight),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/userIconCall.svg',
                              ),
                            ],
                          ),
                        ),
                      ),

                Container(
                  padding: EdgeInsets.only(
                    top: 55,
                  ),
                  //height: 79,
                  //width: MediaQuery.of(context).size.width,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 24,
                              color: chatRoomColor,
                            ),
                            onPressed: () {
                              widget.groupListprovider.duration("");
                              setState(() {
                                isCallinProgress = true;
                                isCallinProgress1 = true;
                                print("iscallingprogress $isCallinProgress");
                              });

                              widget.groupListprovider.callProgress(true);

                              time = _time;
                              widget.popCallBAck();
                              print("this is mesg scrn icon pressed");
                            },
                          ),
                          Text(
                            widget.mediaType == "video"
                                ? 'You are video calling with'
                                : "You are audio calling with",
                            style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.none,
                                fontFamily: secondaryFontFamily,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                color: darkBlackColor),
                          ),
                          Spacer(),
                          //  padding: EdgeInsets.only(left: 90),
                          Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              _pressDuration,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 14,
                                  fontFamily: secondaryFontFamily,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  color: darkBlackColor),
                            ),
                          ),
                        ],
                      ),

                      // Container(
                      //   padding: EdgeInsets.only(
                      //     right: 25,
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     children: [
                      //       //            Consumer<ContactProvider>(
                      //       //   builder: (context, contact, child) {
                      //       //     if (contact.contactState == ContactStates.Success) {
                      //       //       int index = contact.contactList.users.indexWhere(
                      //       //           (element) => element.ref_id == incomingfrom);
                      //       //       return Text(
                      //       //         contact.contactList.users[index].full_name,
                      //       //         style: TextStyle(
                      //       //             fontFamily: primaryFontFamily,
                      //       //             color: darkBlackColor,
                      //       //             decoration: TextDecoration.none,
                      //       //             fontWeight: FontWeight.w700,
                      //       //             fontStyle: FontStyle.normal,
                      //       //             fontSize: 24),
                      //       //       );
                      //       //     }
                      //       //   },
                      //       // ),
                      //       // (callTo == "")
                      //       //     ? Consumer<ContactProvider>(
                      //       //         builder: (context, contact, child) {
                      //       //         if (contact.contactState ==
                      //       //             ContactStates.Success) {
                      //       //           int index = contact.contactList.users
                      //       //               .indexWhere((element) =>
                      //       //                   element.ref_id == incomingfrom);
                      //       //           print("i am here-");
                      //       //           return Text(
                      //       //             "theere",
                      //       //             // contact
                      //       //             //     .contactList.users[index].full_name,
                      //       //             // "this is GroupCall",
                      //       //             style: TextStyle(
                      //       //                 fontFamily: primaryFontFamily,
                      //       //                 color: darkBlackColor,
                      //       //                 decoration: TextDecoration.none,
                      //       //                 fontWeight: FontWeight.w700,
                      //       //                 fontStyle: FontStyle.normal,
                      //       //                 fontSize: 24),
                      //       //           );
                      //       //         } else {
                      //       //           return Container();
                      //       //         }
                      //       //       })
                      //       //     : Text(
                      //       //        //  callTo,
                      //       //      "heeere",
                      //       //         style: TextStyle(
                      //       //             fontFamily: primaryFontFamily,
                      //       //             // background: Paint()..color = yellowColor,
                      //       //             color: darkBlackColor,
                      //       //             decoration: TextDecoration.none,
                      //       //             fontWeight: FontWeight.w700,
                      //       //             fontStyle: FontStyle.normal,
                      //       //             fontSize: 24),
                      //       //       ),
                      //       // Row(
                      //       //   children: [
                      //       //     Text(
                      //       //       _pressDuration,
                      //       //       style: TextStyle(
                      //       //           decoration: TextDecoration.none,
                      //       //           fontSize: 14,
                      //       //           fontFamily: secondaryFontFamily,
                      //       //           fontWeight: FontWeight.w400,
                      //       //           fontStyle: FontStyle.normal,
                      //       //           color: darkBlackColor),
                      //       //     ),
                      //       //     //   SizedBox(width:10),
                      //       //     // number!=null?   Text(
                      //       //     //     "DownStream $downstream  UpStream $upstream",
                      //       //     //     style: TextStyle(
                      //       //     //         decoration: TextDecoration.none,
                      //       //     //         fontSize: 14,
                      //       //     //         fontFamily: secondaryFontFamily,
                      //       //     //         fontWeight: FontWeight.w400,
                      //       //     //         fontStyle: FontStyle.normal,
                      //       //     //         color: darkBlackColor),
                      //       //     //   ):Text(
                      //       //     //     "DownStream 0   UpStream 0",
                      //       //     //     style: TextStyle(
                      //       //     //         decoration: TextDecoration.none,
                      //       //     //         fontSize: 14,
                      //       //     //         fontFamily: secondaryFontFamily,
                      //       //     //         fontWeight: FontWeight.w400,
                      //       //     //         fontStyle: FontStyle.normal,
                      //       //     //         color: darkBlackColor),
                      //       //     //   ),
                      //       //   ],
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),

                // Container(
                //   padding: EdgeInsets.only(top: 85, left: 50),
                //   child: Text(
                //     // "yes",
                //     callTo !="" && iscalloneto1==true?
                //     '${callTo}':callTo!= "" && iscalloneto1==false && widget.callingTo.length==1? '${callTo}':
                //     callTo== "" && iscalloneto1==false && widget.callingTo.length==1? '${callername}'
                //     :callTo!="" &&iscalloneto1==false && widget.callingTo.length>1?"A Group":callTo=="" &&iscalloneto1==false && widget.callingTo.length>1?'A Group': '${callername}',
                //     //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                //     style: TextStyle(
                //         fontSize: 24,
                //         decoration: TextDecoration.none,
                //         fontFamily: primaryFontFamily,
                //         fontWeight: FontWeight.w700,
                //         fontStyle: FontStyle.normal,
                //         color: darkBlackColor),
                //   ),
                // ),
                //*
                callTo != "" && iscalloneto1==true
                    ? Container(
                        padding: EdgeInsets.only(top: 85, left: 50),
                        child: Text(
                          '${callTo}',
                          //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                          style: TextStyle(
                              fontSize: 24,
                              decoration: TextDecoration.none,
                              fontFamily: primaryFontFamily,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: darkBlackColor),
                        ),
                      )
                    : callTo!="" && iscalloneto1==false && widget.callingTo.length>1?
                    Container(
                        padding: EdgeInsets.only(top: 85, left: 50),
                        child: Text(
                          '${widget.groupName}',
                          //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                          style: TextStyle(
                              fontSize: 24,
                              decoration: TextDecoration.none,
                              fontFamily: primaryFontFamily,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: darkBlackColor),
                        ),
                      ):
                      callTo!="" && iscalloneto1==false ?
                       Container(
                        padding: EdgeInsets.only(top: 85, left: 50),
                        child: Text(
                          '${callTo}',
                          //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                          style: TextStyle(
                              fontSize: 24,
                              decoration: TextDecoration.none,
                              fontFamily: primaryFontFamily,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: darkBlackColor),
                        ),
                      ):
                      callTo==""?Container(
                        padding: EdgeInsets.only(top: 85, left: 50),
                        child: Text(
                          '$callername',
                          //'${widget.groupListprovider.groupList.groups[widget.contactProvider.contactList.users.length].group_title}',
                          style: TextStyle(
                              fontSize: 24,
                              decoration: TextDecoration.none,
                              fontFamily: primaryFontFamily,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: darkBlackColor),
                        ),
                      ):
                      Container(),
                //*

                Container(
                    child: Align(
                  alignment: Alignment.topRight,
                  // color: Colors.red,
                  child: Column(
                    children: [
                      Container(
                        // height: 500,
                        // width: 500,
                        // padding: EdgeInsets.zero,
                        padding: const EdgeInsets.fromLTRB(0.0, 244.33, 20, 27),

                        child: GestureDetector(
                          child: SvgPicture.asset('assets/switch_camera.svg'),
                          onTap: () {
                            signalingClient.switchCamera();
                          },
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.zero,
                        // height: 500,
                        // width: 500,
                        padding: const EdgeInsets.only(right: 20),

                        child: GestureDetector(
                          child: switchSpeaker
                              ? SvgPicture.asset('assets/VolumnOn.svg')
                              : SvgPicture.asset('assets/VolumeOff.svg'),
                          onTap: () {
                            signalingClient.switchSpeaker(switchSpeaker);
                            setState(() {
                              switchSpeaker = !switchSpeaker;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )),

                widget.mediaType == "video"
                    ? Positioned(
                        top: 135,
                        left: 8,

                        // bottom: 145.0,
                        // right: 20,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: rendererListWithRefID.length,
                              itemBuilder: (context, index) {
                                int userIndex = widget
                                    .contactProvider.contactList.users
                                    .indexWhere((element) =>
                                        element.ref_id ==
                                        rendererListWithRefID[index]["refID"]);

                                return Container(
                                  padding: EdgeInsets.only(right: 8),
                                  width: 80.0,
                                  decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(16.0))),
                                  child: Stack(
                                    children: [
                                      Container(
                                        child: rendererListWithRefID[index]
                                                    ["remoteVideoFlag"] ==
                                                1
                                            ? RemoteStream(
                                                remoteRenderer:
                                                    rendererListWithRefID[index]
                                                        ["rtcVideoRenderer"],
                                              )
                                            : Container(
                                                width: 80.0,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius.all(
                                                            Radius.circular(
                                                                16.0)),
                                                    color:
                                                        backgroundAudioCallLight),
                                                child: Container(
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      'assets/userIconCall.svg',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            forLargStream =
                                                rendererListWithRefID[index];
                                          });
                                        },
                                        // child: Container(
                                        //   width: 80,
                                        //   height: 100,
                                        //   // color: Colors.white,
                                        //   alignment: Alignment.topCenter,
                                        //   child: Text(
                                        //     userIndex == -1
                                        //         ? widget.authProvider.getUser.full_name
                                        //         : widget.contactProvider.contactList
                                        //             .users[userIndex].full_name,
                                        //     style: TextStyle(
                                        //         color: primaryColor,
                                        //         fontSize: 10,
                                        //         fontWeight: FontWeight.bold),
                                        //   ),
                                        // ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(),

                Container(
                  padding: EdgeInsets.only(
                    bottom: 56,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.mediaType == "video"
                          ? Row(
                              children: [
                                GestureDetector(
                                  child: !enableCamera
                                      ? SvgPicture.asset('assets/video_off.svg')
                                      : SvgPicture.asset('assets/video.svg'),
                                  onTap: () {
                                    setState(() {
                                      enableCamera = !enableCamera;
                                    });
                                    signalingClient.audioVideoState(
                                        audioFlag: switchMute ? 1 : 0,
                                        videoFlag: enableCamera ? 1 : 0,
                                        mcToken: widget.registerRes["mcToken"]);
                                    signalingClient.enableCamera(enableCamera);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                )
                              ],
                            )
                          : SizedBox(),
                      // : Container(),

                      // FloatingActionButton(
                      //   backgroundColor:
                      //       switchSpeaker ? chatRoomColor : Colors.white,
                      //   elevation: 0.0,
                      //   onPressed: () {
                      //     setState(() {
                      //       switchSpeaker = !switchSpeaker;
                      //     });
                      //     signalingClient.switchSpeaker(switchSpeaker);
                      //   },
                      //   child: switchSpeaker
                      //       ? Icon(Icons.volume_up)
                      //       : Icon(
                      //           Icons.volume_off,
                      //           color: chatRoomColor,
                      //         ),
                      // ),
                      // SizedBox(
                      //   width: 20,
                      // ),
                      GestureDetector(
                        child: SvgPicture.asset(
                          'assets/end.svg',
                        ),
                        onTap: () {
                          widget.stopCall();
                          // setState(() {
                          //   _isCalling = false;
                          // });
                        },
                      ),

                      // SvgPicture.asset('assets/images/end.svg'),

                      SizedBox(width: 20),
                      GestureDetector(
                        child: !switchMute
                            ? SvgPicture.asset('assets/mute_microphone.svg')
                            : SvgPicture.asset('assets/microphone.svg'),
                        onTap: () {
                          final bool enabled = signalingClient.muteMic();
                          print("this is enabled $enabled");
                          setState(() {
                            switchMute = enabled;
                          });
                        },
                      ),
                      SizedBox(width: 20),
                      //       GestureDetector(
                      //         child:
                      //              SvgPicture.asset('assets/mesgscrn.svg'),
                      //         onTap: () {
                      //          widget.groupListprovider.duration("");
                      // setState(() {
                      //   isCallinProgress=true;
                      //   isCallinProgress1=true;
                      //   print("iscallingprogress $isCallinProgress");
                      // });

                      // widget.groupListprovider.callProgress(true);

                      //  time=_time;
                      // widget.popCallBAck();
                      //           print("this is mesg scrn icon pressed");

                      //         },
                      //       ),
                    ],
                  ),
                )
              ],
            ));
            //rendererListWithRefID.length == 2?Container(color:Colors.pink): rendererListWithRefID.length == 3? Container(color:Colors.green):Container(color:Colors.blue);

            // Container(
            //   child: Stack(children: <Widget>[
            //     // when remote video come
            //     // meidaType == MediaType.video
            //     //     ?

            //     onRemoteStream
            //         ? rendererListWithRefID.length == 2
            //             ?
            //             // if video is off then show white screen
            //             rendererListWithRefID.first["remoteVideoFlag"] == 0
            //                 ? Container(
            //                  // color:Colors.pink, height:250,width:250
            //                     decoration:
            //                         BoxDecoration(color: backgroundAudioCallLight),
            //                     child: Center(
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: [
            //                           SvgPicture.asset(
            //                             'assets/userIconCall.svg',
            //                           ),
            //                           Text(widget.contactProvider
            //                               .contactList
            //                               .users[widget.contactProvider.contactList.users
            //                                   .indexWhere((element) =>
            //                                       element.ref_id ==
            //                                       rendererListWithRefID[1]
            //                                           ["refID"])]
            //                               .full_name)
            //                         ],
            //                       ),
            //                     ),
            //                   )
            //                 :
            //                 RemoteStream(
            //                     remoteRenderer:rendererListWithRefID[1]
            //                         ["rtcVideoRenderer"],
            //                   )
            //             : rendererListWithRefID.length == 3
            //                 ? Column(
            //                     children: [
            //                       Expanded(
            //                         child: Container(
            //                             // color: Colors.yellow,
            //                             width: MediaQuery.of(context).size.width,
            //                             child: // if video is off then show white screen
            //                                 rendererListWithRefID[1]
            //                                             ["remoteVideoFlag"] ==
            //                                         0
            //                                     ? Container(
            //                                         decoration: BoxDecoration(
            //                                             color:
            //                                                 backgroundAudioCallLight),
            //                                         child: Center(
            //                                           child: Column(
            //                                             mainAxisAlignment:
            //                                                 MainAxisAlignment
            //                                                     .center,
            //                                             children: [
            //                                               SvgPicture.asset(
            //                                                 'assets/userIconCall.svg',
            //                                               ),
            //                                               Text(widget.contactProvider
            //                                                   .contactList
            //                                                   .users[widget.contactProvider
            //                                                       .contactList.users
            //                                                       .indexWhere((element) =>
            //                                                           element
            //                                                               .ref_id ==
            //                                                           rendererListWithRefID[
            //                                                                   1][
            //                                                               "refID"])]
            //                                                   .full_name)
            //                                             ],
            //                                           ),
            //                                         ),
            //                                       )
            //                                     : RemoteStream(
            //                                         remoteRenderer:
            //                                             rendererListWithRefID[1]
            //                                                 ["rtcVideoRenderer"],
            //                                       )),
            //                       ),
            //                       Expanded(
            //                         child: Container(
            //                             // color: Colors.green,
            //                             width: MediaQuery.of(context).size.width,
            //                             child: // if video is off then show white screen
            //                                rendererListWithRefID[2]
            //                                             ["remoteVideoFlag"] ==
            //                                         0
            //                                     ? Container(
            //                                         decoration: BoxDecoration(
            //                                             color:
            //                                                 backgroundAudioCallLight),
            //                                         child: Center(
            //                                           child: Column(
            //                                             mainAxisAlignment:
            //                                                 MainAxisAlignment
            //                                                     .center,
            //                                             children: [
            //                                               SvgPicture.asset(
            //                                                 'assets/userIconCall.svg',
            //                                               ),
            //                                               Text(widget.contactProvider
            //                                                   .contactList
            //                                                   .users[widget.contactProvider
            //                                                       .contactList.users
            //                                                       .indexWhere((element) =>
            //                                                           element
            //                                                               .ref_id ==
            //                                                         rendererListWithRefID[
            //                                                                   2][
            //                                                               "refID"])]
            //                                                   .full_name)
            //                                             ],
            //                                           ),
            //                                         ),
            //                                       )
            //                                     : RemoteStream(
            //                                         remoteRenderer:
            //                                            rendererListWithRefID[2]
            //                                                 ["rtcVideoRenderer"],
            //                                       )),
            //                       )
            //                     ],
            //                   )
            //                 : rendererListWithRefID.length == 4
            //                     ? Column(
            //                         children: [
            //                           Expanded(
            //                             child: Row(
            //                               children: [
            //                                 Container(
            //                                     // color: Colors.yellow,
            //                                     width: MediaQuery.of(context)
            //                                             .size
            //                                             .width /
            //                                         2,
            //                                     height: MediaQuery.of(context)
            //                                             .size
            //                                             .height /
            //                                         2,
            //                                     child: // if video is off then show white screen
            //                                         rendererListWithRefID[1][
            //                                                     "remoteVideoFlag"] ==
            //                                                 0
            //                                             ? Container(
            //                                                 decoration: BoxDecoration(
            //                                                     color:
            //                                                         backgroundAudioCallLight),
            //                                                 child: Center(
            //                                                   child: Column(
            //                                                     mainAxisAlignment:
            //                                                         MainAxisAlignment
            //                                                             .center,
            //                                                     children: [
            //                                                       SvgPicture.asset(
            //                                                         'assets/userIconCall.svg',
            //                                                       ),
            //                                                       Text(widget.contactProvider
            //                                                           .contactList
            //                                                           .users[widget.contactProvider
            //                                                               .contactList
            //                                                               .users
            //                                                               .indexWhere((element) =>
            //                                                                   element
            //                                                                       .ref_id ==
            //                                                                 rendererListWithRefID[1]
            //                                                                       [
            //                                                                       "refID"])]
            //                                                           .full_name)
            //                                                     ],
            //                                                   ),
            //                                                 ),
            //                                               )
            //                                             : RemoteStream(
            //                                                 remoteRenderer:
            //                                                    rendererListWithRefID[
            //                                                             1][
            //                                                         "rtcVideoRenderer"],
            //                                               )),
            //                                 Container(
            //                                   // color: Colors.yellow,
            //                                   width: MediaQuery.of(context)
            //                                           .size
            //                                           .width /
            //                                       2,
            //                                   height: MediaQuery.of(context)
            //                                           .size
            //                                           .height /
            //                                       2,
            //                                   child: // if video is off then show white screen
            //                                       rendererListWithRefID[2]
            //                                                   ["remoteVideoFlag"] ==
            //                                               0
            //                                           ? Container(
            //                                               decoration: BoxDecoration(
            //                                                   color:
            //                                                       backgroundAudioCallLight),
            //                                               child: Center(
            //                                                 child: Column(
            //                                                   mainAxisAlignment:
            //                                                       MainAxisAlignment
            //                                                           .center,
            //                                                   children: [
            //                                                     SvgPicture.asset(
            //                                                       'assets/userIconCall.svg',
            //                                                     ),
            //                                                     Text(widget.contactProvider
            //                                                         .contactList
            //                                                         .users[widget.contactProvider
            //                                                             .contactList
            //                                                             .users
            //                                                             .indexWhere((element) =>
            //                                                                 element
            //                                                                     .ref_id ==
            //                                                                rendererListWithRefID[2]
            //                                                                     [
            //                                                                     "refID"])]
            //                                                         .full_name)
            //                                                   ],
            //                                                 ),
            //                                               ),
            //                                             )
            //                                           : RemoteStream(
            //                                               remoteRenderer:
            //                                                  rendererListWithRefID[
            //                                                           2][
            //                                                       "rtcVideoRenderer"],
            //                                             ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                           Expanded(
            //                             child: Container(
            //                               // color: Colors.green,
            //                               width: MediaQuery.of(context).size.width,
            //                               child: // if video is off then show white screen
            //                                   rendererListWithRefID[3]
            //                                               ["remoteVideoFlag"] ==
            //                                           0
            //                                       ? Container(
            //                                           decoration: BoxDecoration(
            //                                               color:
            //                                                   backgroundAudioCallLight),
            //                                           child: Center(
            //                                             child: Column(
            //                                               mainAxisAlignment:
            //                                                   MainAxisAlignment
            //                                                       .center,
            //                                               children: [
            //                                                 SvgPicture.asset(
            //                                                   'assets/userIconCall.svg',
            //                                                 ),
            //                                                 Text(widget.contactProvider
            //                                                     .contactList
            //                                                     .users[widget.contactProvider
            //                                                         .contactList
            //                                                         .users
            //                                                         .indexWhere((element) =>
            //                                                             element
            //                                                                 .ref_id ==
            //                                                            rendererListWithRefID[
            //                                                                     3][
            //                                                                 "refID"])]
            //                                                     .full_name)
            //                                               ],
            //                                             ),
            //                                           ),
            //                                         )
            //                                       : RemoteStream(
            //                                           remoteRenderer:
            //                                               rendererListWithRefID[3]
            //                                                   ["rtcVideoRenderer"],
            //                                         ),
            //                             ),
            //                           )
            //                         ],
            //                       )
            //                     : Column(
            //                         children: [
            //                           Expanded(
            //                             child: Row(
            //                               children: [
            //                                 Container(
            //                                     // color: Colors.yellow,
            //                                     width: MediaQuery.of(context)
            //                                             .size
            //                                             .width /
            //                                         2,
            //                                     height: MediaQuery.of(context)
            //                                             .size
            //                                             .height /
            //                                         2,
            //                                     child: // if video is off then show white screen
            //                                        rendererListWithRefID.first[
            //                                                     "remoteVideoFlag"] ==
            //                                                 0
            //                                             ? Container(
            //                                                 decoration: BoxDecoration(
            //                                                     color:
            //                                                         backgroundAudioCallLight),
            //                                                 child: Center(
            //                                                   child: Column(
            //                                                     mainAxisAlignment:
            //                                                         MainAxisAlignment
            //                                                             .center,
            //                                                     children: [
            //                                                       SvgPicture.asset(
            //                                                         'assets/userIconCall.svg',
            //                                                       ),
            //                                                       Text(widget.contactProvider
            //                                                           .contactList
            //                                                           .users[widget.contactProvider
            //                                                               .contactList
            //                                                               .users
            //                                                               .indexWhere((element) =>
            //                                                                   element
            //                                                                       .ref_id ==
            //                                                                   rendererListWithRefID[1]
            //                                                                       [
            //                                                                       "refID"])]
            //                                                           .full_name)
            //                                                     ],
            //                                                   ),
            //                                                 ),
            //                                               )
            //                                             : RemoteStream(
            //                                                 remoteRenderer:
            //                                                    rendererListWithRefID[
            //                                                             1][
            //                                                         "rtcVideoRenderer"],
            //                                               )),
            //                                 Container(
            //                                   // color: Colors.yellow,
            //                                   width: MediaQuery.of(context)
            //                                           .size
            //                                           .width /
            //                                       2,
            //                                   height: MediaQuery.of(context)
            //                                           .size
            //                                           .height /
            //                                       2,
            //                                   child: // if video is off then show white screen
            //                                      rendererListWithRefID[2]
            //                                                   ["remoteVideoFlag"] ==
            //                                               0
            //                                           ? Container(
            //                                               decoration: BoxDecoration(
            //                                                   color:
            //                                                       backgroundAudioCallLight),
            //                                               child: Center(
            //                                                 child: Column(
            //                                                   mainAxisAlignment:
            //                                                       MainAxisAlignment
            //                                                           .center,
            //                                                   children: [
            //                                                     SvgPicture.asset(
            //                                                       'assets/userIconCall.svg',
            //                                                     ),
            //                                                     Text(widget.contactProvider
            //                                                         .contactList
            //                                                         .users[widget.contactProvider
            //                                                             .contactList
            //                                                             .users
            //                                                             .indexWhere((element) =>
            //                                                                 element
            //                                                                     .ref_id ==
            //                                                                 rendererListWithRefID[2]
            //                                                                     [
            //                                                                     "refID"])]
            //                                                         .full_name)
            //                                                   ],
            //                                                 ),
            //                                               ),
            //                                             )
            //                                           : RemoteStream(
            //                                               remoteRenderer:
            //                                                   rendererListWithRefID[
            //                                                           2][
            //                                                       "rtcVideoRenderer"],
            //                                             ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                           Expanded(
            //                             child: Row(
            //                               children: [
            //                                 Container(
            //                                     // color: Colors.yellow,
            //                                     width: MediaQuery.of(context)
            //                                             .size
            //                                             .width /
            //                                         2,
            //                                     height: MediaQuery.of(context)
            //                                             .size
            //                                             .height /
            //                                         2,
            //                                     child: // if video is off then show white screen
            //                                       rendererListWithRefID[3][
            //                                                     "remoteVideoFlag"] ==
            //                                                 0
            //                                             ? Container(
            //                                                 decoration: BoxDecoration(
            //                                                     color:
            //                                                         backgroundAudioCallLight),
            //                                                 child: Center(
            //                                                   child: Column(
            //                                                     mainAxisAlignment:
            //                                                         MainAxisAlignment
            //                                                             .center,
            //                                                     children: [
            //                                                       SvgPicture.asset(
            //                                                         'assets/userIconCall.svg',
            //                                                       ),
            //                                                       Text(widget.contactProvider
            //                                                           .contactList
            //                                                           .users[widget.contactProvider
            //                                                               .contactList
            //                                                               .users
            //                                                               .indexWhere((element) =>
            //                                                                   element
            //                                                                       .ref_id ==
            //                                                                 rendererListWithRefID[3]
            //                                                                       [
            //                                                                       "refID"])]
            //                                                           .full_name)
            //                                                     ],
            //                                                   ),
            //                                                 ),
            //                                               )
            //                                             : RemoteStream(
            //                                                 remoteRenderer:
            //                                                    rendererListWithRefID[
            //                                                             3][
            //                                                         "rtcVideoRenderer"],
            //                                               )),
            //                                 Container(
            //                                   // color: Colors.yellow,
            //                                   width: MediaQuery.of(context)
            //                                           .size
            //                                           .width /
            //                                       2,
            //                                   height: MediaQuery.of(context)
            //                                           .size
            //                                           .height /
            //                                       2,
            //                                   child: // if video is off then show white screen
            //                                      rendererListWithRefID[4]
            //                                                   ["remoteVideoFlag"] ==
            //                                               0
            //                                           ? Container(
            //                                               decoration: BoxDecoration(
            //                                                   color:
            //                                                       backgroundAudioCallLight),
            //                                               child: Center(
            //                                                 child: Column(
            //                                                   mainAxisAlignment:
            //                                                       MainAxisAlignment
            //                                                           .center,
            //                                                   children: [
            //                                                     SvgPicture.asset(
            //                                                       'assets/userIconCall.svg',
            //                                                     ),
            //                                                     Text(widget.contactProvider
            //                                                         .contactList
            //                                                         .users[widget.contactProvider
            //                                                             .contactList
            //                                                             .users
            //                                                             .indexWhere((element) =>
            //                                                                 element
            //                                                                     .ref_id ==
            //                                                                rendererListWithRefID[4]
            //                                                                     [
            //                                                                     "refID"])]
            //                                                         .full_name)
            //                                                   ],
            //                                                 ),
            //                                               ),
            //                                             )
            //                                           : RemoteStream(
            //                                               remoteRenderer:
            //                                                  rendererListWithRefID[
            //                                                           4][
            //                                                       "rtcVideoRenderer"],
            //                                             ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ],
            //                       )

            //         // RTCVideoView(rendererListWithRefID[0]["refID"],
            //         //     mirror: false,
            //         //     objectFit: kIsWeb
            //         //         ? RTCVideoViewObjectFit.RTCVideoViewObjectFitContain
            //         //         : RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
            //         // : Container(
            //         //     decoration: BoxDecoration(
            //         //         gradient: LinearGradient(
            //         //       colors: [
            //         //         backgroundAudioCallDark,
            //         //         backgroundAudioCallLight,
            //         //         backgroundAudioCallLight,
            //         //         backgroundAudioCallLight,
            //         //       ],
            //         //       begin: Alignment.topCenter,
            //         //       end: Alignment(0.0, 0.0),
            //         //     )),
            //         //     child: Center(
            //         //       child: SvgPicture.asset(
            //         //         'assets/userIconCall.svg',
            //         //       ),
            //         //     ),
            //         //   )
            //         : Container(
            //             decoration: BoxDecoration(
            //                 gradient: LinearGradient(
            //               colors: [
            //                 backgroundAudioCallDark,
            //                 backgroundAudioCallLight,
            //                 backgroundAudioCallLight,
            //                 backgroundAudioCallLight,
            //               ],
            //               begin: Alignment.topCenter,
            //               end: Alignment(0.0, 0.0),
            //             )),
            //             child: Center(
            //               child: SvgPicture.asset(
            //                 'assets/userIconCall.svg',
            //               ),
            //             ),
            //           ),
            //     // : Container(
            //     //     decoration: BoxDecoration(
            //     //         gradient: LinearGradient(
            //     //       colors: [
            //     //         backgroundAudioCallDark,
            //     //         backgroundAudioCallLight,
            //     //         backgroundAudioCallLight,
            //     //         backgroundAudioCallLight,
            //     //       ],
            //     //       begin: Alignment.topCenter,
            //     //       end: Alignment(0.0, 0.0),
            //     //     )),
            //     //     child: Center(
            //     //       child: SvgPicture.asset(
            //     //         'assets/userIconCall.svg',
            //     //       ),
            //     //     ),
            //     //   ),

            //     Container(
            //       padding: EdgeInsets.only(top: 55, left: 20),
            //       //height: 79,
            //       //width: MediaQuery.of(context).size.width,

            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [

            //           Text(
            //              widget.mediaType=="video"?
            //             'You are video calling with':'You are audio calling with',
            //             style: TextStyle(
            //                 fontSize: 14,
            //                 decoration: TextDecoration.none,
            //                 fontFamily: secondaryFontFamily,
            //                 fontWeight: FontWeight.w400,
            //                 fontStyle: FontStyle.normal,
            //                 color: darkBlackColor),
            //           ),
            //           Container(
            //             padding: EdgeInsets.only(
            //               right: 25,
            //             ),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               crossAxisAlignment: CrossAxisAlignment.end,
            //               children: [
            //                 //            Consumer<ContactProvider>(
            //                 //   builder: (context, contact, child) {
            //                 //     if (contact.contactState == ContactStates.Success) {
            //                 //       int index = contact.contactList.users.indexWhere(
            //                 //           (element) => element.ref_id == incomingfrom);
            //                 //       return Text(
            //                 //         contact.contactList.users[index].full_name,
            //                 //         style: TextStyle(
            //                 //             fontFamily: primaryFontFamily,
            //                 //             color: darkBlackColor,
            //                 //             decoration: TextDecoration.none,
            //                 //             fontWeight: FontWeight.w700,
            //                 //             fontStyle: FontStyle.normal,
            //                 //             fontSize: 24),
            //                 //       );
            //                 //     }
            //                 //   },
            //                 // ),
            //                 (callTo == "")
            //                     ? Consumer<ContactProvider>(
            //                         builder: (context, contact, child) {
            //                         if (contact.contactState ==
            //                             ContactStates.Success) {
            //                           int index = contact.contactList.users
            //                               .indexWhere((element) =>
            //                                   element.ref_id == incomingfrom);
            //                           print("i am here-");
            //                           return Text(

            //                             contact.contactList.users[index].full_name,
            //                             style: TextStyle(
            //                                 fontFamily: primaryFontFamily,
            //                                 color: darkBlackColor,
            //                                 decoration: TextDecoration.none,
            //                                 fontWeight: FontWeight.w700,
            //                                 fontStyle: FontStyle.normal,
            //                                 fontSize: 24),
            //                           );
            //                         } else {
            //                           return Container();
            //                         }
            //                       })
            //                     : Text(
            //                       "",
            //                        // callTo,
            //                         style: TextStyle(
            //                             fontFamily: primaryFontFamily,
            //                             // background: Paint()..color = yellowColor,
            //                             color: darkBlackColor,
            //                             decoration: TextDecoration.none,
            //                             fontWeight: FontWeight.w700,
            //                             fontStyle: FontStyle.normal,
            //                             fontSize: 24),
            //                       ),
            //                 Text(
            //                   _pressDuration,
            //                   style: TextStyle(
            //                       decoration: TextDecoration.none,
            //                       fontSize: 14,
            //                       fontFamily: secondaryFontFamily,
            //                       fontWeight: FontWeight.w400,
            //                       fontStyle: FontStyle.normal,
            //                       color: darkBlackColor),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     !kIsWeb
            //         ? widget.mediaType == "video"
            //             ? Container(
            //                 // color: Colors.red,
            //                 child: Column(
            //                   children: [
            //                     Padding(
            //                       // height: 500,
            //                       // width: 500,
            //                       // padding: EdgeInsets.zero,
            //                       padding: const EdgeInsets.fromLTRB(
            //                           327.0, 120.0, 25.0, 8.0),
            //                       child: Align(
            //                         alignment: Alignment.topRight,
            //                         child: GestureDetector(
            //                           child: SvgPicture.asset(
            //                               'assets/switch_camera.svg'),
            //                           onTap: () {
            //                             signalingClient.switchCamera();
            //                           },
            //                         ),
            //                       ),
            //                     ),
            //                     Padding(
            //                       // padding: EdgeInsets.zero,
            //                       // height: 500,
            //                       // width: 500,
            //                       padding: const EdgeInsets.fromLTRB(
            //                           327.0, 10.0, 20.0, 8.0),
            //                       child: Align(
            //                         alignment: Alignment.topRight,
            //                         child: GestureDetector(
            //                           child: switchSpeaker
            //                               ? SvgPicture.asset('assets/VolumnOn.svg')
            //                               : SvgPicture.asset(
            //                                   'assets/VolumeOff.svg'),
            //                           onTap: () {
            //                             print("HERE IS SWITCH SPEAKER $switchSpeaker");
            //                           signalingClient
            //                                 .switchSpeaker(switchSpeaker);
            //                             setState(() {
            //                               switchSpeaker = !switchSpeaker;
            //                             });

            //                           },
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               )
            //             : Container(
            //                 // color: Colors.red,
            //                 child: Column(
            //                   children: [
            //                     Padding(
            //                       // padding: EdgeInsets.zero,
            //                       // height: 500,
            //                       // width: 500,
            //                       padding: const EdgeInsets.fromLTRB(
            //                           327.0, 120.0, 20.0, 8.0),
            //                       child: Align(
            //                         alignment: Alignment.topRight,
            //                         child: GestureDetector(
            //                           child: switchSpeaker
            //                               ? SvgPicture.asset('assets/VolumnOn.svg')
            //                               : SvgPicture.asset(
            //                                   'assets/VolumeOff.svg'),
            //                           onTap: () {

            //                                signalingClient.switchSpeaker(switchSpeaker);
            //                             setState(() {
            //                               switchSpeaker = !switchSpeaker;
            //                             });
            //                           },
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               )
            //         : SizedBox(),

            //     widget.mediaType == "video"
            //         ? Positioned(
            //             left: 20.0,
            //             bottom: 145.0,
            //             // right: 20,
            //             child: Align(
            //               alignment: Alignment.bottomCenter,
            //               child: Container(
            //                 height: 170,
            //                 width: 130,
            //                 decoration: BoxDecoration(
            //                   color: Colors.red,
            //                   borderRadius: BorderRadius.circular(10.0),
            //                 ),
            //                 child: ClipRRect(
            //                     borderRadius: BorderRadius.circular(10.0),
            //                     child: RemoteStream(
            //                       remoteRenderer:rendererListWithRefID[0]
            //                           ["rtcVideoRenderer"],
            //                     )

            //                     // RTCVideoView(_remoteRenderer,
            //                     //     // key: forsmallView,
            //                     //     mirror: false,
            //                     //     objectFit: RTCVideoViewObjectFit
            //                     //         .RTCVideoViewObjectFitCover),
            //                     ),
            //               ),
            //             ),
            //           )
            //         : Container(),

            //     // Positioned(
            //     //   // left: 225.0,
            //     //   bottom: 145.0,
            //     //   right: 20,
            //     //   child: Align(
            //     //     // alignment: Alignment.bottomRight,
            //     //     child: Container(
            //     //       height: 170,
            //     //       width: 130,
            //     //       decoration: BoxDecoration(
            //     //         color: Colors.green,
            //     //         borderRadius: BorderRadius.circular(10.0),
            //     //       ),
            //     //       child: ClipRRect(
            //     //         borderRadius: BorderRadius.circular(10.0),
            //     //         child:
            //     //             // RemoteStream(
            //     //             //   remoteRenderer: _remoteRenderer,
            //     //             // )
            //     //             Container(),
            //     //       ),
            //     //     ),
            //     //   ),
            //     // ),

            //     Container(
            //       padding: EdgeInsets.only(
            //         bottom: 56,
            //       ),
            //       alignment: Alignment.bottomCenter,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           widget.mediaType == "video"
            //               ? Row(
            //                   children: [
            //                     GestureDetector(
            //                       child: !enableCamera
            //                           ? SvgPicture.asset('assets/video_off.svg')
            //                           : SvgPicture.asset('assets/video.svg'),
            //                       onTap: () {
            //                         setState(() {
            //                           enableCamera = !enableCamera;
            //                         });
            //                         signalingClient.audioVideoState(
            //                             audioFlag: switchMute ? 1 : 0,
            //                             videoFlag: enableCamera ? 1 : 0,
            //                             mcToken: widget.registerRes["mcToken"]);
            //                         signalingClient.enableCamera(enableCamera);
            //                       },
            //                     ),
            //                     SizedBox(
            //                       width: 20,
            //                     )
            //                   ],
            //                 )
            //               : SizedBox(),
            //           // : Container(),

            //           // FloatingActionButton(
            //           //   backgroundColor:
            //           //       switchSpeaker ? chatRoomColor : Colors.white,
            //           //   elevation: 0.0,
            //           //   onPressed: () {
            //           //     setState(() {
            //           //       switchSpeaker = !switchSpeaker;
            //           //     });
            //           //     signalingClient.switchSpeaker(switchSpeaker);
            //           //   },
            //           //   child: switchSpeaker
            //           //       ? Icon(Icons.volume_up)
            //           //       : Icon(
            //           //           Icons.volume_off,
            //           //           color: chatRoomColor,
            //           //         ),
            //           // ),
            //           // SizedBox(
            //           //   width: 20,
            //           // ),
            //           GestureDetector(
            //             child: SvgPicture.asset(
            //               'assets/end.svg',
            //             ),
            //             onTap: () {
            //               widget.stopCall();
            //          setState(() {
            //            isCallinProgress=false;
            //            isCallinProgress1=false;
            //          });
            //          time=null;
            //         // timee=null;
            //          widget.groupListprovider.callProgress(false);
            //               // setState(() {
            //               //   _isCalling = false;
            //               // });
            //             },
            //           ),

            //           // SvgPicture.asset('assets/images/end.svg'),

            //           SizedBox(width: 20),
            //           GestureDetector(
            //             child: !switchMute
            //                 ? SvgPicture.asset('assets/mute_microphone.svg')
            //                 : SvgPicture.asset('assets/microphone.svg'),
            //             onTap: () {
            //               final bool enabled = signalingClient.muteMic();
            //               print("this is enabled $enabled");
            //               setState(() {
            //                 switchMute = enabled;
            //               });
            //             },
            //           ),
            //         ],
            //       ),
            //     )
            //   ]),
            // );
          }),
        ));
  }
}
