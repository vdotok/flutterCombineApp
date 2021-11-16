import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/Screeens/CallAcceptScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/CallDialScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/CallzreceiveScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/CreateGroupScreen/CreateGroupPopUp.dart';
import 'package:vdkFlutterChat/src/Screeens/groupChatScreen/ChatScreen.dart';
import 'package:vdkFlutterChat/src/Screeens/home/streams/remoteStream.dart';
import 'package:vdkFlutterChat/src/core/config/config.dart';
import 'package:vdkFlutterChat/src/core/models/GroupModel.dart';
import 'package:vdkFlutterChat/src/core/models/ParticipantsModel.dart';
import 'package:vdkFlutterChat/src/core/models/contact.dart';
import 'package:vdkFlutterChat/src/core/providers/call_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import 'package:vdkFlutterChat/src/shared_preference/shared_preference.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import 'package:vdotok_stream/vdotok_stream.dart';
import 'package:vibration/vibration.dart';
import '../home/CustomAppBar.dart';
import '../splash/splash.dart';
import '../../constants/constant.dart';
import '../../core/providers/auth.dart';
import '../../core/providers/groupListProvider.dart';
import '../../jsManager/jsManager.dart';
import '../../Screeens/home/NoChatScreen.dart';
import 'package:battery/battery.dart';

GlobalKey<ScaffoldState> scaffoldKey;
Emitter emitter;
bool enableCamera = true;
bool switchMute = true;
DateTime time;
DateTime time1;
double statsvalue;
bool switchSpeaker = true;
SignalingClient signalingClient = SignalingClient.instance;
bool remoteVideoFlag = true;
String callTo = "";
String incomingfrom;
bool onRemoteStream = false;
bool isCallinProgress = false;
Timer ticker;
bool iscalloneto1 = false;
Map<String, dynamic> forLargStream = {};
String meidaType = CallMediaType.video;
bool dConnected = true;
String groupName;
List<Map<String, dynamic>> rendererListWithRefID = [
  // {
  //   "i": "k",
  //   "j": "k",
  // },
  // {
  //   "i": "k",
  //   "j": "k",
  // }
];
bool isDial = false;

String pressDuration = "";
bool isPushed = false;
var _battery = Battery();

class Home extends StatefulWidget {
  bool state;
  Home(this.state);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _groupNameController = TextEditingController();
  AuthProvider authProvider;
  GroupListProvider groupListProvider;

  ContactProvider contactProvider;
  CallProvider _callProvider;

  List<Contact> _selectedContacts = [];
  bool isConnect = false;
  Uint8List _image;
  List<Uint8List> listOfChunks = [];
  Map<String, dynamic> header;
  bool scrollUp = false;
  CallStartScreen callStar = new CallStartScreen();
  bool istimerset = false;
  String mmtype = "";
  bool sockett = true;
  bool isotheruser = false;
  bool isSocketregis = false;
  bool isDeviceConnected = false;
  // SignalingClient signalingClient = SignalingClient.instance;
  RTCPeerConnection _peerConnection;
  RTCPeerConnection _answerPeerConnection;
  MediaStream _localStream;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  GlobalKey forsmallView = new GlobalKey();
  final key1 = GlobalKey();
  int receiveMesgs;
  GlobalKey forlargView = new GlobalKey();
  GlobalKey forDialView = new GlobalKey();
  var registerRes;
  bool inCall = false;
  bool onremoteset = false;
  //String callTo = "";
  List<int> vibrationList = [
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000,
    500,
    1000
  ];

  SharedPref sharedPref = SharedPref();
  //bool remoteVideoFlag = true;
  bool remoteAudioFlag = true;

  bool isSocketConnect = true;
  //   List<Map<String, dynamic>> rendererListWithRefID = [
  //   // {
  //   //   "i": "k",
  //   //   "j": "k",
  //   // },
  //   // {
  //   //   "i": "k",
  //   //   "j": "k",
  //   // }
  // ];

  int callDialCount;

  List<ParticipantsModel> callingTo;

  var callDuration;
  //Map<String, dynamic> forLargStream = {};
  bool isReceive = false;
  int callReceiveCount;
  int missedCallCount;
  isValuePresent(String key, int value) async {
    final response = await sharedPref.read("authUser");
    print("this is response of login api in shared pre $response");
    print("this is battery level ${await _battery.batteryLevel}");
    final counter = await sharedPref.readInteger(key);
    print("this is call dial count $counter");
    if (counter != null) {
      print("This is my if111");
    } else {
      print("This is my else111");
      sharedPref.saveInteger(key, 0);
      value = 0;
    }
  }

  totalCounter(String key, int value) async {
    final counter = await sharedPref.readInteger(key);
    print("this is call dial count q $counter");
    value = counter;
    sharedPref.saveInteger(key, value + 1);
    final counter1 = await sharedPref.readInteger(key);
    print("this is call dial count www $counter1");
  }

  //  bool onRemoteStream = false;
  @override
  void initState() {
    super.initState();
    isValuePresent("callDialCounter", callDialCount);
    isValuePresent("callReceiveCounter", callReceiveCount);
    isValuePresent("receiveMessagesCounter", receiveMesgs);
    isValuePresent("missedCallCounter", missedCallCount);
    //initRenderers();
    //WidgetsBinding.instance.addObserver(this);
    print("i am here in  init state of home page ........");
    time = null;
    emitter = Emitter.instance;
    scaffoldKey = GlobalKey<ScaffoldState>();
    //checkStatus();
    //checkConnectivity();
    //  rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    contactProvider = Provider.of<ContactProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    groupListProvider = Provider.of<GroupListProvider>(context, listen: false);
    _callProvider = Provider.of<CallProvider>(context, listen: false);

    emitter.connect(
        clientId: authProvider.getUser.user_id.toString(),
        reconnectivity: true,
        refID: authProvider.getUser.ref_id,
        authorization_token: authProvider.getUser.authorization_token,
        host: authProvider.host,
        port: authProvider.port);

    emitter.onConnect = (res) {
      print('this is response on connect $res');
      if (res) {
        groupListProvider.getGroupList(authProvider.getUser.auth_token);
        print("Connected Successfully $res");
        setState(() {
          print("IN SET STATE EMITTER>CONNECT");
          isConnect = res;
        });
        print("this is  connectttttttttttt before $isConnect");
      } else {
        print("connection error $res");
        setState(() {
          isConnect = res;
        });
        print("this is  connectttttttttttt  after $isConnect");
      }
    };

    emitter.onPresence = (res) {
      print("Presence  $res");

      groupListProvider.handlePresence(json.decode(res));
    };

    emitter.onsubscribe = (value) {
      print(("subscription homee $value"));
      if (value ==
          groupListProvider.groupList.groups.last.channel_key +
              "/" +
              groupListProvider.groupList.groups.last.channel_name) {
        groupListProvider.changeState();
      }
    };

    emitter.onMessage = (msg) async {
      print("this is msg on receive ");
      var message = json.decode(msg);

      switch (message["type"]) {
        case MessagingType.text:
          {
            if (authProvider.getUser.ref_id != message["from"]) {
              if (groupListProvider.currentOpendChat != null) {
                if (groupListProvider.currentOpendChat.channel_key ==
                    message["key"]) {
                  print("samee channel oppeened");
                  var receiptMsg = message;
                  receiptMsg["status"] = ReceiptType.seen;
                  Map<String, dynamic> tempData = {
                    "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
                    "from": authProvider.getUser.ref_id,
                    "key": message["key"],
                    "messageId": message["id"],
                    "receiptType": ReceiptType.seen,
                    "to": message["to"]
                  };

                  groupListProvider.recevieMsg(receiptMsg);
                  emitter.publish(
                      groupListProvider.currentOpendChat.channel_key,
                      groupListProvider.currentOpendChat.channel_name,
                      tempData);
                  totalCounter("receiveMessagesCounter", receiveMesgs);
                } else {
                  groupListProvider.recevieMsg(message);
                  totalCounter("receiveMessagesCounter", receiveMesgs);
                }
              } else {
                print("this is eelsee");
                groupListProvider.recevieMsg(message);
                totalCounter("receiveMessagesCounter", receiveMesgs);
              }
            } else {
              // here i'm getting my delivered message
              groupListProvider.changeMsgStatusToDelivered(
                  message, ReceiptType.delivered);
            }
          }
          break;
        case MessagingType.media:
          {}
          break;
        case MessagingType.file:
          {}
          break;
        case MessagingType.thumbnail:
          {}
          break;
        case MessagingType.path:
          {}
          break;
        case MessagingType.typing:
          {
            if (authProvider.getUser.ref_id != message["from"]) {
              groupListProvider.updateTypingStatus(msg);
            }
          }
          break;

        default:
          {
            if (message["receiptType"] == ReceiptType.seen)
              groupListProvider.changeMsgStatus(msg, ReceiptType.seen);
          }
          break;
      }

      if (message["type"] == MediaType.audio ||
          message["type"] == MediaType.video ||
          message["type"] == MediaType.image ||
          message["type"] == MediaType.file) {
        if (authProvider.getUser.ref_id != message["from"]) {
          if (groupListProvider.currentOpendChat != null) {
            //if shame channel is open
            if (groupListProvider.currentOpendChat.channel_key ==
                message["key"]) {
              print("samee channel oppeened ${message["date"]}  ${message}  ");
              var receiptMsg = message;
              receiptMsg["status"] = ReceiptType.seen;

              // groupListProvider.recevieMsg(receiptMsg);
              if (!kIsWeb) {
                var extension =
                    message["fileExtension"].toString().contains(".")
                        ? message["fileExtension"]
                        : '.' + message["fileExtension"];
                print("this is tempData ${extension}");
                final tempDir = await getTemporaryDirectory();
                File file = await File(
                        '${tempDir.path}/vdktok${(new DateTime.now()).millisecondsSinceEpoch.toString().trim()}$extension')
                    .create();
                file.writeAsBytesSync(base64.decode(receiptMsg["content"]));
                receiptMsg["content"] = file;
                message["id"] = message["messageId"];
                groupListProvider.recevieMsg(message);
              } else {
                final url = await JsManager.instance.connect(
                    base64.decode(receiptMsg["content"]),
                    receiptMsg["fileExtension"]);
                receiptMsg["content"] = url;
                groupListProvider.recevieMsg(receiptMsg);
              }
              Map<String, dynamic> tempData = {
                "date": ((DateTime.now()).millisecondsSinceEpoch).round(),
                "from": authProvider.getUser.ref_id,
                "key": message["key"],
                "messageId": message["messageId"],
                "receiptType": ReceiptType.seen,
                "to": message["topic"]
              };

              print("this is temp data $tempData ${message["to"]}");

              emitter.publish(groupListProvider.currentOpendChat.channel_key,
                  groupListProvider.currentOpendChat.channel_name, tempData);
              totalCounter("receiveMessagesCounter", receiveMesgs);
            }
            // if same channel in not opened
            else {
              if (!kIsWeb) {
                var extension =
                    message["fileExtension"].toString().contains(".")
                        ? message["fileExtension"]
                        : '.' + message["fileExtension"];
                print(
                    "this is extension ${message["fileExtension"].toString().contains(".") ? message["fileExtension"] : '.' + message["fileExtension"]}");
                final tempDir = await getTemporaryDirectory();
                File file = await File(
                        '${tempDir.path}/vdotok${(new DateTime.now()).millisecondsSinceEpoch.toString().trim()}$extension')
                    .create();
                file.writeAsBytesSync(base64.decode(message["content"]));
                message["content"] = file;
                groupListProvider.recevieMsg(message);
              } else {
                final url = await JsManager.instance.connect(
                    base64.decode(message["content"]),
                    message["fileExtension"]);
                message["content"] = url;
                groupListProvider.recevieMsg(message);
              }
            }
          } else {
            print("this is eelsee");
            if (!kIsWeb) {
              final tempDir = await getTemporaryDirectory();
              var extension = message["fileExtension"].toString().contains(".")
                  ? message["fileExtension"]
                  : '.' + message["fileExtension"];

              File file = await File(
                      '${tempDir.path}/vdotok${DateTime.now().toString().trim()}$extension')
                  .create();
              file.writeAsBytesSync(base64.decode(message["content"]));
              message["content"] = file;
              groupListProvider.recevieMsg(message);
              totalCounter("receiveMessagesCounter", receiveMesgs);
            } else {
              final url = await JsManager.instance.connect(
                  base64.decode(message["content"]), message["fileExtension"]);
              message["content"] = url;
              groupListProvider.recevieMsg(message);
            }
          }
        } else {
          // here i'm getting my delivered message
          groupListProvider.changeMsgStatusToDelivered(
              message, ReceiptType.delivered);
        }
      }
    };
    printyCallback();
  }

  printyCallback() {
    print("Hi i am parent class function");

    // contactProvider.getContacts(authProvider.getUser.auth_token);
    // groupListProvider.getGroupList(authProvider.getUser.auth_token);

    signalingClient.connect(project_id, authProvider.completeAddress);
    signalingClient.onConnect = (res) {
      print("onConnecttttttttttt signalining client $res");
      if (res == "connected") {
        sockett = true;
      }

      signalingClient.register(authProvider.getUser.toJson(), project_id);
      // signalingClient.register(user);
    };
    // signalingClient.onCallstats=(timeStats){
    //      print("this is timee stats ${timeStats/1024}");
    //     // statsvalue=timeStats/1024;
    //     groupListProvider.statsValue(timeStats);
    // };
    signalingClient.onError = (code, res) {
      print("onConnect erorrrrrrbf $code $res");
      print("hey i am here");
      // _callProvider.initial();
      var snackBar;
      if (code == 1002 || code == 1001) {
        sockett = false;
        isSocketregis = false;
        isPushed = false;
        //  snackBar = SnackBar(content: Text("Socket Disconnected"));
      } else {
        print("ffgfffff $res");
        // snackBar = SnackBar(content: Text(res));
      }
      if (code == 1005) {
        sockett = false;
        isSocketregis = false;
        isPushed = false;
      }

// Find the Scaffold in the widget tree and use it to show a SnackBar.

      // signalingClient.register(user);
    };
    signalingClient.onRegister = (res) {
      print("onRegister  $res");
      setState(() {
        registerRes = res;
      });
      // signalingClient.register(user);
    };
    Map<String, dynamic> temp = {
      "refID": authProvider.getUser.ref_id,
      "rtcVideoRenderer": new RTCVideoRenderer(),
      "remoteVideoFlag": 1,
      "remoteAudioFlag": 1
    };

//    _peerConnection.getStats();
//    try {
//   myPeerConnection = new RTCPeerConnection(pcOptions);

//   statsInterval = window.setInterval(getConnectionStats, 1000);
//   /* add event handlers, etc */
// } catch(err) {
//   console.error("Error creating RTCPeerConnection: " + err);
// }

//  getConnectionStats() {
//    _peerConnection.getStats(stats) {
//     var statsOutput = "";

//     stats.forEach(report => {
//       if (report.type == "inbound-rtp" && report.kind == "video") {
//         Object.keys(report).forEach(statName => {
//           statsOutput += `<strong>${statName}:</strong> ${report[statName]}<br>\n`;
//         });
//       }
//     });

//     document.querySelector(".stats-box").innerHTML = statsOutput;
//   });
// }

// void _getAudioStats(MediaStream _localStream, RTCPeerConnection _peerConnection) async {
//   print("in get audio stats $_localStream...... $_peerConnection..... $_answerPeerConnection");
//     if (_localStream != null || _peerConnection != null) {
//       var logger = Logger();
//       print("IN LOGGERRRRRR");
//       logger.d("hnnnnmnmnmnmnbn ${await _peerConnection.getStats(_localStream.getAudioTracks()[0])}");
//     }
//   }

    initRenderers(temp["rtcVideoRenderer"]);
    setState(() {
      rendererListWithRefID.add(temp);
    });
    signalingClient.onCallMissedCallback = () {
      totalCounter("missedCallCounter", missedCallCount);
      print("this is missed call counter $missedCallCount");
    };
    signalingClient.onCallWaitingCallback = () {
      print("i am in call waiting call back");
      stopCall();
      // Timer(Duration(seconds: 10), () {
      // print("after waiting for 10 seconds");
      // signalingClient.onSessionTimeOut(registerRes["mcToken"]);
      print("after session timeout call");
      // signalingClient.stopCall(
      // registerRes["mcToken"]);
      //stopCall();
      // _callProvider.initial();
      // });
    };
    signalingClient.onLocalStream = (stream) {
      _localStream = stream;
      // setState(() {
      //   _localRenderer.srcObject = stream;
      // });
// _peerConnection.getStats(reports -> {
//    for (StatsReport report : reports) {
//       Log.d(TAG, "Stats: " + report.toString());
//    }
// }, null);
//  _createPeerConnection().then((pc) {
//       _peerConnection = pc;
//     });
// var selector = _peerConnection.getRemoteStreams()[0].getAudioTracks()[0];
//  _peerConnection.getStats(selector);
// _peerConnection.getStats(new RTCStatsCollectorCallback() {
//   @Override
//   public void onStatsDelivered(RTCStatsReport rtcStatsReport) {
//     longInfo("RTC Stats: \n" + rtcStatsReport.toString());
//   }
// });
// conncectionStats() async{
//         const stats = await this._peerConnection.getStats(null);
//         const candidates = await this.getCandidateIds(stats)
//         console.log("candidates: ", candidates)
//         if (candidates !== {}) {
//             const localCadidate = await this.getCandidateInfo(stats, candidates.localId)
//             const remoteCadidate = await this.getCandidateInfo(stats, candidates.remoteId)
//             if (localCadidate !== null && remoteCadidate !== null) {
//                 return [localCadidate, remoteCadidate]
//             }
//         }
//         // we did not find the candidates for whatever reeason
//         return [null, null]
//     }
//       pc.getStats(null)).then(function(stats) {
//   return Object.keys(stats).forEach(function(key) {
//     if (stats[key].type == "candidatepair" &&
//         stats[key].nominated && stats[key].state == "succeeded") {
//       var remote = stats[stats[key].remoteCandidateId];
//       console.log("Connected to: " + remote.ipAddress +":"+
//                   remote.portNumber +" "+ remote.transport +
//                   " "+ remote.candidateType);
//     }
//   });
// })
// .catch(function(e) { console.log(e.name); });
// _peerConnection.pc.onaddstream = function(event) {
//       peer.remoteVideoEl.setAttribute("id", event.stream.id);
//       attachMediaStream(peer.remoteVideoEl, event.stream);
//       remoteVideosContainer.appendChild(peer.remoteVideoEl);
//       getStats(peer.pc);
// };

//       Future<RtcStatsResponse> getLegacyStats([MediaStreamTrack? selector]) {
//   var completer = new Completer<RtcStatsResponse>();
//   _getStats((value) {
//     completer.complete(value);
//   }, selector);
//   return completer.future;
// }
      // RTCRtpReceiver  pop;
      // var promise = pop.getStats();

      //  Future<RtcStatsReport> getStats() => promiseToFuture<RtcStatsReport>(
      // JS("creates:RtcStatsReport;", "#.getStats()", this));
      //   print("ddddrty");

      //  print("dddddsfsfs ${_peerConnection.getStats()}");
      //  print("ddddddlpo");
      print("call callback on call local stream");

      setState(() {
        rendererListWithRefID[0]["rtcVideoRenderer"].srcObject = stream;
      });
      print("REFID LIST LOCAL${rendererListWithRefID.length}");
    };

    signalingClient.onRemoteStream = (stream, refid) async {
      print("THIS IS ON REMOTE CALL BACKKKKKKK11111111");
      print("call callback on call remote Stream $refid ... $stream");
      // print("this is before remote object ${_remoteRenderer.srcObject}");
      //  _remoteRenderer.srcObject = stream;
      //     print("this is after remote object ${_remoteRenderer.srcObject}");
      print("REFID LIST ${rendererListWithRefID.length}");
      Map<String, dynamic> temp = {
        "refID": refid,
        "rtcVideoRenderer": new RTCVideoRenderer(),
        "remoteVideoFlag": meidaType == "video" ? 1 : 0,
        "remoteAudioFlag": 1
      };

      await initRenderers(temp["rtcVideoRenderer"]);
      setState(() {
        temp["rtcVideoRenderer"].srcObject = stream;
      });
      if (forLargStream.isEmpty) {
        print("this is in if large stream");
        setState(() {
          forLargStream = temp;
        });
      }
      setState(() {
        onremoteset = true;
        // isCallinProgress=true;
        groupListProvider.callProgress(true);
        print(
            "THIS IS RENDERER LIST LENGTH before addition....${rendererListWithRefID.length}");
        Future.delayed(const Duration(milliseconds: 50), () {
          rendererListWithRefID.add(temp);
        });

        print(
            "THIS IS RENDERER LIST LENGTH after addition....${rendererListWithRefID.length}");
        forLargStream = temp;
        onRemoteStream = true;
      });
      // setState(() {

      // });
      print("this is large streammmmm $forLargStream");
      print("REFID LIST AFTER ${rendererListWithRefID.length}");
      // _callProvider.callStart();
    };

    signalingClient.onReceiveCallFromUser =
        (receivefrom, type, isonetone) async {
      print("call callback on call Received incomming $type..... $receivefrom");
      rendererListWithRefID.first["remoteVideoFlag"] = type == "audio" ? 0 : 1;
      meidaType = type;
      print("renderer listdddd $receivefrom");
      startRinging();
      inCall = true;
      iscalloneto1 = isonetone;
      setState(() {
        onRemoteStream = false;
        incomingfrom = receivefrom;
        meidaType = type;
        switchMute = true;
        enableCamera = true;
        switchSpeaker = type == "video" ? true : false;
        remoteVideoFlag = true;
        remoteAudioFlag = true;
      });
      //here
      // _callBloc.add(CallReceiveEvent());
      _callProvider.callReceive();
      isReceive = true;
    };
    signalingClient.onParticipantsLeft = (refID) async {
      print("call callback on call left by participant");

      // on participants left
      if (refID == authProvider.getUser.ref_id) {
      } else {
        int index = rendererListWithRefID
            .indexWhere((element) => element["refID"] == refID);

        setState(() {
          rendererListWithRefID.removeAt(index);
          print(
              "this is print on participant left ${rendererListWithRefID.length}");
          if (rendererListWithRefID.length == 1) {
            signalingClient.stopCall(registerRes["mcToken"]);
          }
        });
      }
    };
    signalingClient.onCallAcceptedByUser = () async {
      // if (reCall == false) {
      print("call callback on call Accepted");
      isDial = false;
      isReceive = false;
      inCall = true;
      print("this is local renderer in if callacceptbyuser");
      //here
      // _callBloc.add(CallStartEvent());
      print("this is before call astart in call accept");
      _callProvider.callStart();
      print("this is before call astart in call accept11111111");
      //isPushed = false;
      Navigator.pop(context);
      setState(() {});
      // }
      // else{
      //   print("i am after recall else $reCall");

      // }
    };

    signalingClient.onCallHungUpByUser = (isLocal) {
      print("call callback on call hungUpBy User");
      isReceive = false;
      //here
      //  setState(() {
      //              isCallinProgress=false;
      //              isCallinProgress1=false;
      //            });
      // _callBloc.add(CallNewEvent());
      _callProvider.initial();
      if (isCallinProgress == false) {
        print("SSSSSPOSSPSFSSFkkfdsff");
        isPushed = false;
        print("this is local renderer in if inhungbyuser");
        Navigator.pop(context);
      }
      onremoteset = false;
      isDial = false;
      setState(() {
        isCallinProgress = false;
        isCallinProgress1 = false;
      });
      //if(inCall!=true){
      // print("i am here in not null call hung user");
      time = null;
      // }

      //  timee=null;
      groupListProvider.callProgress(false);
      if (isLocal == false) {
        disposeAllRenderer();
      }

      stopRinging();
    };
    // signalingClient.onCallDeclineByYou = () {
    //   print("call callback on call decline");

    //   //here
    //   // _callBloc.add(CallNewEvent());
    //   _callProvider.initial();
    //   setState(() {
    //     // _localRenderer.srcObject = null;
    //     // _remoteRenderer.srcObject = null;
    //     // _remoteRenderer2.srcObject = null;
    //     // _remoteRenderer3.srcObject = null;
    //     // _remoteRenderer4.srcObject = null;
    //   });
    //   stopRinging();
    // };
    signalingClient.onCallBusyCallback = () {
      print("call callback on call busy");
      _callProvider.initial();
      final snackBar =
          SnackBar(content: Text('User is busy with another call.'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        // _localRenderer.srcObject = null;
        // _remoteRenderer.srcObject = null;
        // _remoteRenderer2.srcObject = null;
        // _remoteRenderer3.srcObject = null;
        // _remoteRenderer4.srcObject = null;
      });
    };
    // signalingClient.onCallRejectedByUser = () {
    //   print("call callback on call Rejected");
    //   //here
    //   // _callBloc.add(CallNewEvent());
    //   stopRinging();
    //   _callProvider.initial();

    //   setState(() {
    //     // _localRenderer.srcObject = null;
    //     // _remoteRenderer.srcObject = null;
    //     // _remoteRenderer2.srcObject = null;
    //     // _remoteRenderer3.srcObject = null;
    //     // _remoteRenderer4.srcObject = null;
    //   });
    // };

    signalingClient.onAudioVideoStateInfo = (audioFlag, videoFlag, refID) {
      print("call callback on call audioVideo status $audioFlag, $videoFlag");
      int index = rendererListWithRefID
          .indexWhere((element) => element["refID"] == refID);
      print("this is index $index");
      setState(() {
        rendererListWithRefID[index]["remoteVideoFlag"] = videoFlag;
        rendererListWithRefID[index]["remoteAudioFlag"] = audioFlag;
      });
    };
  }

  // void checkConnectivity() async {
  //    isDeviceConnected = false;
  //   if (!kIsWeb) {
  //     DataConnectionChecker().onStatusChange.listen((status) async {
  //       print("this on listenerrrrrrrrrrrr");
  //       isDeviceConnected = await DataConnectionChecker().hasConnection;
  //       print("this is isdevice  connected $isDeviceConnected");
  //       if (isDeviceConnected == true) {
  //            if (sockett == false) {
  //     print("i am here in widget build");
  //     if (isSocketregis == false) {
  //       isSocketregis = true;
  //       print("IN WIODGET TRUE AND SOCKET FALSE");
  //       signalingClient.connect(auth_token, project_id);
  //       if (inCall == true) {
  //         print("I am in Re Reregister");

  //         signalingClient.register(authProvider.getUser.toJson(), project_id);
  //         isPushed = false;
  //         signalingClient.onRegister = (res) {
  //           print("onRegister after reconnection $res");
  //           setState(() {
  //             registerRes = res;
  //           });
  //           // signalingClient.register(user);
  //         };
  //       }
  //       //  signalingClient.reRegister(authProvider.getUser.toJson(), project_id);
  //       //   }​​​​​​​​
  //     }
  //   }
  //       }
  //       else {

  //     }});
  //   }
  // }
  checkInternet() async {
    dConnected = await DataConnectionChecker().hasConnection;
  }

  navigateCallBack() {
    print("DEEEEEEEEEEEEEEEEE");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>(
                  create: (context) => AuthProvider()),
              ChangeNotifierProvider(create: (context) => ContactProvider()),
              ChangeNotifierProvider(create: (context) => CallProvider()),
            ],
            child: CallStartScreen(
              // onSpeakerCallBack: onSpeakerCallBack,
              // onCameraCallBack: onCameraCallBack,
              // onMicCallBack: onMicCallBack,
              //  rendererListWithRefID:rendererListWithRefID,
              //  onRemoteStream:onRemoteStream,
              callingTo: callingTo,
              groupName: groupName,
              mediaType: meidaType,
              localRenderer: _localRenderer,
              remoteRenderer: _remoteRenderer,
              incomingfrom: incomingfrom,
              registerRes: registerRes,
              stopCall: stopCall,
              callTo: callTo,
              // signalingClient: signalingClient,
              callProvider: _callProvider,
              authProvider: authProvider,
              contactProvider: contactProvider,
              groupListprovider: groupListProvider,
              contactList: contactProvider.contactList,
              popCallBAck: screenPopCallBack,
            )),
      ),
    );
    // pressDuration="";
    // _ticker.cancel();
  }

  initRenderers(RTCVideoRenderer rtcRenderer) async {
    await rtcRenderer.initialize();
    // await _localRenderer.initialize();
    //await _remoteRenderer.initialize();
  }

  disposeAllRenderer() async {
    for (int i = 0; i < rendererListWithRefID.length; i++) {
      if (i == 0) {
        rendererListWithRefID[i]["rtcVideoRenderer"].srcObject = null;
      } else
        await rendererListWithRefID[i]["rtcVideoRenderer"].dispose();
    }
    print("this is after dispose all elements $rendererListWithRefID");
    // setState(() {
    if (rendererListWithRefID.length > 1) {
      print("yes i'm here ");
      rendererListWithRefID.removeRange(1, (rendererListWithRefID.length));
    }
    // });

    print("this is after dispose all elements $rendererListWithRefID");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("this is state of App change $state");
    if (state == AppLifecycleState.detached) {
      // if app swipe killed from background
      signalingClient.unRegister(registerRes["mcToken"]);
    } else if (state == AppLifecycleState.inactive) {
      // if app go to background
    } else if (state == AppLifecycleState.paused) {
      // if app in background and app go to in paused State
    } else if (state == AppLifecycleState.resumed) {
      // if app open from background
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
    final duration = DateTime.now().difference(time);
    final newDuration = _formatDuration(duration);
    //if (mounted) {
    setState(() {
      // Your state change code goes here
      pressDuration = newDuration;
      print(
          "IN SET STATE SINGNALING CLIENT>PRESS DURATIONnnnnn $pressDuration");
      groupListProvider.duration(pressDuration);
      //sharedPref.save("Duration", pressDuration);
    });
    //}
    //  setState(() {

    //   });
  }

  screenPushCallBack() {
    // if(time==null){
    //   time1=time;
    // }
    print("Hey! i am here in screen push callback");
    //  _callProvider.callStart();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>(
                  create: (context) => AuthProvider()),
              ChangeNotifierProvider(create: (context) => ContactProvider()),
              ChangeNotifierProvider(create: (context) => CallProvider()),
            ],
            child: CallStartScreen(
                // onSpeakerCallBack: onSpeakerCallBack,
                // onCameraCallBack: onCameraCallBack,
                // onMicCallBack: onMicCallBack,
                //  rendererListWithRefID:rendererListWithRefID,
                //  onRemoteStream:onRemoteStream,
                callingTo: callingTo,
                groupName: groupName,
                mediaType: meidaType,
                localRenderer: _localRenderer,
                remoteRenderer: _remoteRenderer,
                incomingfrom: incomingfrom,
                registerRes: registerRes,
                stopCall: stopCall,
                callTo: callTo,
                // signalingClient: signalingClient,
                callProvider: _callProvider,
                authProvider: authProvider,
                contactProvider: contactProvider,
                groupListprovider: groupListProvider,
                contactList: contactProvider.contactList,
                popCallBAck: screenPopCallBack)),
      ),
    );

    pressDuration = "";
    ticker.cancel();
  }

  screenPopCallBack() {
    print("djbgjksfbksfk");
    _callProvider.initial();
    _callProvider.initial();
    //  setState(() {
    //    isCallinProgress=true;
    //  });
    // isPushed = false;

    Navigator.pop(context);
    //_updateTimer();
    //  _time = DateTime.now();
    //istimerset=true;
    ticker = Timer.periodic(Duration(seconds: 1), (_) => _updateTimer());
    //  setState(() {

    //  });
    // callDuration = await sharedPref.read("Duration");
  }

  _startCall(
      GroupModel to, String mtype, String callType, String sessionType) async {
    //mmtype=mtype;
    print("thos is mtype  $mtype");
    setState(() {
      switchMute = true;
      enableCamera = true;
      onRemoteStream = false;
      switchSpeaker = mtype == "video" ? true : false;
    });
    List<String> groupRefIDS = [];
    // participantsCalling = to.participants;
    to.participants.forEach((element) {
      if (authProvider.getUser.ref_id != element.ref_id)
        groupRefIDS.add(element.ref_id.toString());
    });
    meidaType = mtype;
    callingTo = to.participants;
    groupName = to.group_title;
    print("This is group name $callingTo");
    // callingTo.removeWhere((element) => element.ref_id == authProvider.getUser.ref_id);
    setState(() {
      rendererListWithRefID.first["remoteVideoFlag"] = mtype == "video" ? 1 : 0;
    });

// print("this is rendererList ${rendererListWithRefID.first["remoteVideoFlag"]}");
    // groupRefIDS.add("bba0bcc3174e200139f9881538ff208d");
    print("this is list ${groupRefIDS}");
    signalingClient.startCall(
        from: authProvider.getUser.ref_id,
        to: groupRefIDS,
        // to: [
        //   "d4852b644614854af2707f1f3f43f726",
        //   "e74573df8a062cb4d5a0a8a9aa143cb3"
        // ],
        mcToken: registerRes["mcToken"],
        meidaType: mtype,
        callType: callType,
        sessionType: sessionType);
    // Map<String, dynamic> temp = {
    //   "refID": _auth.getUser.ref_id,
    //   "rtcVideoRenderer": new RTCVideoRenderer()
    // };
    // await initRenderers(temp["rtcVideoRenderer"]);
    // Navigator.pushNamedAndRemoveUntil(context, "/call", (route) => false,
    //     arguments: {"to": callingTo, "mediaType": mtype, "rtcRenderer": temp});
    _callProvider.callDial();
  }

  startRinging() async {
    if (Platform.isAndroid) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(pattern: vibrationList);
      }
    }
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 1.0, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
  }

  stopRinging() {
    print("this is on rejected ");

    vibrationList.clear();

    Vibration.cancel();
    FlutterRingtonePlayer.stop();
  }

  @override
  dispose() {
    // _localRenderer.dispose();
    // _remoteRenderer.dispose();
    // Connectivity().onConnectivityChanged.cancel();
    super.dispose();
  }

  stopCall() {
    signalingClient.stopCall(registerRes["mcToken"]);
    //here
    // _callBloc.add(CallNewEvent());
    isPushed = false;
    onremoteset = false;
    _callProvider.initial();
    if (isCallinProgress == true) {
      print("i am here  in call progress false stop call");
      print("SSSSSPOSSPSFSSFkkfdsff");
      isPushed = false;
      print("this is local renderer in if inhungbyuser");
      Navigator.pop(context);
    }
    if (!kIsWeb) stopRinging();
  }

  Future<Null> refreshList() async {
    setState(() {
      print("IN SET STATE EMOITER>REFRESH LIST");
      renderList();
      // rendersubscribe();
    });
    return;
  }

// publishMessage(key, channelname, sendmessage) {
//     print("print im here ");
//     print("The key:$key....$channelname...$sendmessage");
//     emitter.publish(key, channelname, sendmessage);
//   }
  renderList() {
    if (groupListProvider.groupListStatus == ListStatus.Scussess)
      groupListProvider.getGroupList(authProvider.getUser.auth_token);
    else {
      contactProvider.getContacts(authProvider.getUser.auth_token);
      _selectedContacts.clear();
    }
  }

  publishMessage(channelKey, channelName, send_message) {
    emitter.publish(channelKey, channelName, send_message);
  }

  handleSeenStatus(index) {
    if (groupListProvider.groupList.groups[index].chatList != null) {
      groupListProvider.groupList.groups[index].chatList.forEach((element) {
        if (element.status != ReceiptType.delivered &&
            authProvider.getUser.ref_id != element.from) {
          // ChatModel notseenMsg = element;
          // notseenMsg.type = "RECEIPTS";
          // notseenMsg.receiptType = 3;

          Map<String, dynamic> tempData = {
            "date": ((new DateTime.now()).millisecondsSinceEpoch).round(),
            "from": authProvider.getUser.ref_id,
            "key": element.key,
            "messageId": element.id,
            "receiptType": ReceiptType.seen,
            "to": groupListProvider.groupList.groups[index].channel_name
          };
          emitter.publish(groupListProvider.groupList.groups[index].channel_key,
              groupListProvider.groupList.groups[index].channel_name, tempData);
        }
      });
    }
  }

  String _presenceStatus = "";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    ));
    checkInternet();

    Future.delayed(Duration(seconds: 1), () {
      if (dConnected == true && sockett == false) {
        print(
            "i am in widget build of home page ${widget.state} && $sockett && $dConnected && ${groupListProvider.callprogress} && $isCallinProgress");
        print("i am here in widget build");

        //  time1=time;

        if (isSocketregis == false) {
          isSocketregis = true;
          print("IN WIODGET TRUE AND SOCKET FALSE");
          signalingClient.connect(project_id, authProvider.completeAddress);
          if (inCall == true) {
            print("I am in Re Reregister");

            signalingClient.register(authProvider.getUser.toJson(), project_id);
            isPushed = false;
            signalingClient.onRegister = (res) {
              print("onRegister after reconnection $res");
              setState(() {
                registerRes = res;
              });
              // signalingClient.register(user);
            };
          }
          //  signalingClient.reRegister(authProvider.getUser.toJson(), project_id);
          //   }​​​​​​​​
        }
      }
    });

    print("fbdfbdgfbdgbdb ${widget.state}");
    showSnakbar(msg) {
      final snackBar = SnackBar(
        content: Text(
          "$msg",
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    return Consumer3<GroupListProvider, AuthProvider, CallProvider>(
      builder: (context, listProvider, authProvider, callProvider, child) {
        void _showDialog(group_id, index) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  //title: Text('Alert Dialog Example'),
                  content:
                      Text('Are you sure you want to delete this chatroom?'),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('CANCEL',
                                style: TextStyle(color: chatRoomColor))),
                        // Consumer2<GroupListProvider, AuthProvider>(builder:
                        //     (context, listProvider, authProvider, child) {
                        //   return
                        FlatButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await groupListProvider.deleteGroup(
                                group_id,
                                authProvider.getUser.auth_token,
                              );
                              // (groupListProvider.deleteGroupStatus ==
                              //         DeleteGroupStatus.Loading)
                              //     ? SplashScreen():

                              if (groupListProvider.deleteGroupStatus ==
                                  DeleteGroupStatus.Success) {
                                // groupListProvider.groupList.groups.

                                showSnakbar(groupListProvider.successMsg);
                              } else if (groupListProvider.deleteGroupStatus ==
                                  DeleteGroupStatus.Failure) {
                                showSnakbar(groupListProvider.errorMsg);
                              } else {}
                              // if (groupListProvider.status == 200) {
                              //   print(
                              //       "this is status ${groupListProvider.status}");
                              //   groupListProvider.getGroupList(
                              //       authProvider.getUser.auth_token);
                              // }
                            },
                            child: Text('DELETE',
                                style: TextStyle(color: chatRoomColor)))
                        //;
                        // }),
                      ],
                    )
                  ],
                );
              });
        }

        //When the Screen is Laoding//
        if (listProvider.groupListStatus == ListStatus.Loading)
          return SplashScreen();

        //In case of success//
        else if (listProvider.groupListStatus == ListStatus.Scussess) {
          //Screen when there is no group or chat in Chat Room//
          if (listProvider.groupList.groups.length == 0)
            return NoChatScreen(
              funct: _startCall,
              sockett: sockett,
              //  funct:_startCall(to, mtype, callType, sessionType)
              registerRes: registerRes,
              //newChatHandler: handleGroupState,
              isConnect: isConnect,
              state: widget.state,
              groupListProvider: groupListProvider,
              emitter: emitter,
              refreshList: refreshList,
              authProvider: authProvider,
              presentCheck: true,
            );

          //Screen with chats in Chat Room//
          else if (callProvider.callStatus == CallStatus.CallReceive) {
            print("this is callllllllllllll");

            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider<AuthProvider>(
                            create: (context) => AuthProvider()),
                        ChangeNotifierProvider(
                            create: (context) => ContactProvider()),
                        ChangeNotifierProvider(
                            create: (context) => CallProvider()),
                      ],
                      child: CallReceiveScreen(
                        //  rendererListWithRefID:rendererListWithRefID,
                        mediaType: meidaType,
                        localRenderer: _localRenderer,
                        incomingfrom: incomingfrom,
                        callProvider: _callProvider,
                        registerRes: registerRes,
                        authProvider: authProvider,
                        from: authProvider.getUser.ref_id,
                        stopRinging: stopRinging,
                        signalingClient: signalingClient,
                        authtoken: authProvider.getUser.auth_token,
                        contactList: contactProvider.contactList,
                      )),
                ),
              );
            });
            return Container();

            //callReceive();}
          }

          if (callProvider.callStatus == CallStatus.CallStart) {
            isotheruser = false;
            print(
                "THIS IS RENDERER LIST LENGTH in start call providerr...${rendererListWithRefID.length}");
            print("THIS IS STARTTTTTTTTTT ${rendererListWithRefID.length}");
            if (rendererListWithRefID.length == 1) {
              print(
                  "THIS IS RENDERER LIST LENGTH in start call renndereer...${rendererListWithRefID.length}");
              //print("i am here in callstart home");
              //print("this is local renderer before if $_localRenderer");
              if (isPushed == false) {
                isPushed = true;
                totalCounter("callReceiveCounter", callReceiveCount);
                print("this is local renderer in if $_localRenderer");
                print("this is before call astart in call accept222222222");
                print("this is ispushed screen ");
                // Navigator.pop(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider<AuthProvider>(
                                create: (context) => AuthProvider()),
                            ChangeNotifierProvider(
                                create: (context) => ContactProvider()),
                            ChangeNotifierProvider(
                                create: (context) => CallProvider()),
                          ],
                          child: CallStartScreen(
                              // onSpeakerCallBack: onSpeakerCallBack,
                              // onCameraCallBack: onCameraCallBack,
                              // onMicCallBack: onMicCallBack,
                              //  rendererListWithRefID:rendererListWithRefID,
                              //  onRemoteStream:onRemoteStream,
                              callingTo: callingTo,
                              groupName: groupName,
                              mediaType: meidaType,
                              localRenderer: _localRenderer,
                              remoteRenderer: _remoteRenderer,
                              incomingfrom: incomingfrom,
                              registerRes: registerRes,
                              stopCall: stopCall,
                              callTo: callTo,
                              // signalingClient: signalingClient,
                              callProvider: _callProvider,
                              authProvider: authProvider,
                              contactProvider: contactProvider,
                              groupListprovider: groupListProvider,
                              contactList: contactProvider.contactList,
                              popCallBAck: screenPopCallBack)),
                    ),
                  );
                });
              }
              return Container();
            }
          }

          // return callStart();
          if (callProvider.callStatus == CallStatus.CallDial) {
            print("this is call= DIALLLLLL $isDial");
            if (isDial == false) {
              totalCounter("callDialCounter", callDialCount);
              isDial = true;
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider<AuthProvider>(
                              create: (context) => AuthProvider()),
                          ChangeNotifierProvider(
                              create: (context) => ContactProvider()),
                          ChangeNotifierProvider(
                              create: (context) => CallProvider()),
                        ],
                        child: CallDialScreen(
                          //  rendererListWithRefID:rendererListWithRefID,
                          callingTo: callingTo,
                          mediaType: meidaType,
                          localRenderer: _localRenderer,
                          incomingfrom: incomingfrom,
                          callProvider: _callProvider,
                          registerRes: registerRes,
                          authProvider: authProvider,
                          // stopRinging: stopRinging,
                          signalingClient: signalingClient,
                          // authtoken: authProvider.getUser.auth_token,
                          // contactList: contactProvider.contactList,
                        )),
                  ),
                );
              });
            }
            return Container();
          }
          //  return callDial();
          else if (callProvider.callStatus == CallStatus.Initial)
            return Scaffold(
              //  key: scaffoldKey,
              resizeToAvoidBottomInset: true,
              backgroundColor: chatRoomBackgroundColor,
              appBar: CustomAppBar(
                funct: _startCall,
                ischatscreen: false,
                groupListProvider: groupListProvider,
                callProvider: _callProvider,
                title: "Chat Rooms",
                lead: false,
                succeedingIcon: 'assets/plus.svg',
              ),

              body: RefreshIndicator(
                onRefresh: refreshList,
                child: SafeArea(
                  child: Column(
                    children: [
                      // SizedBox(
                      //   height: 20,
                      // ),
                      isCallinProgress == true || onremoteset == true
                          //  groupListProvider.callprogress==true
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: meidaType == "video"
                                  ? Container(
                                      color: backgroundAudioCallDark,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 19),
                                      height: 138,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: rendererListWithRefID.length,
                                        itemBuilder: (context, index) {
                                          //print(
                                          //   "THIS IS USERINDEX ${widget.contactprovider.contactList}");
                                          int userIndex = contactProvider
                                              .contactList.users
                                              .indexWhere((element) =>
                                                  element.ref_id ==
                                                  rendererListWithRefID[index]
                                                      ["refID"]);
                                          //print("THIS IS USERINDEX $userIndex");
                                          return Container(
                                            padding: EdgeInsets.only(right: 8),
                                            height: 100,
                                            width: 80.0,
                                            decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(16.0))),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  child: rendererListWithRefID[
                                                                  index][
                                                              "remoteVideoFlag"] ==
                                                          1
                                                      ? RemoteStream(
                                                          remoteRenderer:
                                                              rendererListWithRefID[
                                                                      index][
                                                                  "rtcVideoRenderer"],
                                                        )
                                                      : Container(
                                                          width: 80.0,
                                                          height: 100,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          16.0)),
                                                              color:
                                                                  backgroundAudioCallLight),
                                                          child: Container(
                                                            child: Center(
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/userIconCall.svg',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    print(
                                                        "Call positioned gesture detector pressed from chat screen");
                                                    screenPushCallBack();
                                                    isCallinProgress = false;
                                                    onremoteset = false;
                                                    //                           setState(() {
                                                    // forLargStream =
                                                    //     rendererListWithRefID[
                                                    //         index];
                                                    //                           });
                                                  },
                                                  // child: Container(
                                                  //   width: 80,
                                                  //   height: 100,
                                                  //   // color: Colors.white,
                                                  //   alignment:
                                                  //       Alignment.topCenter,
                                                  //   child: Text(
                                                  //     //   "Hello",
                                                  //     userIndex == -1
                                                  //         ? authProvider
                                                  //             .getUser
                                                  //             .full_name
                                                  //         : contactProvider
                                                  //             .contactList
                                                  //             .users[
                                                  //                 userIndex]
                                                  //             .full_name,
                                                  //     style: TextStyle(
                                                  //         color: primaryColor,
                                                  //         fontSize: 10,
                                                  //         fontWeight:
                                                  //             FontWeight
                                                  //                 .bold),
                                                  //   ),
                                                  // ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        print("fbhdfgbnfgnfg");
                                        screenPushCallBack();
                                        isCallinProgress = false;
                                        onremoteset = false;
                                        // pressDuration = "";
                                        //ticker.cancel();
                                        //  widget.callProvider.callStart();
                                        //  widget.navigate();
                                      },
                                      child: new Container(
                                          height: 40,
                                          alignment: Alignment.center,
                                          color: Colors.green,
                                          child: Text(
                                              "${groupListProvider.timerDuration}")),
                                    ),
                            )
                          // GestureDetector(
                          //   onTap: () {
                          //     print("fbhdfgbnfgnfg");

                          //      pressDuration = "";
                          //       ticker.cancel();
                          //     //  widget.callProvider.callStart();
                          //     widget.navigate();
                          //   },
                          //   child: new Container(
                          //       height: 40,
                          //       alignment: Alignment.center,
                          //       color: Colors.green,
                          //       child: Text("${groupListProvider.timerDuration}")),
                          // ),
                          // ],
                          // )
                          : SizedBox(height: 0),
                      // Stack(
                      //     children: <Widget>[
                      //       GestureDetector(
                      //         onTap: () {
                      //           Navigator.of(context).push(
                      //             MaterialPageRoute(
                      //               builder: (BuildContext context) =>
                      //                   MultiProvider(
                      //                       providers: [
                      //                     ChangeNotifierProvider<
                      //                             AuthProvider>(
                      //                         create: (context) =>
                      //                             AuthProvider()),
                      //                     ChangeNotifierProvider(
                      //                         create: (context) =>
                      //                             ContactProvider()),
                      //                     ChangeNotifierProvider(
                      //                         create: (context) =>
                      //                             CallProvider()),
                      //                   ],
                      //                       child: CallStartScreen(
                      //                           // onSpeakerCallBack: onSpeakerCallBack,
                      //                           // onCameraCallBack: onCameraCallBack,
                      //                           // onMicCallBack: onMicCallBack,
                      //                           //  rendererListWithRefID:rendererListWithRefID,
                      //                           //  onRemoteStream:onRemoteStream,
                      //                           mediaType: meidaType,
                      //                           localRenderer:
                      //                               _localRenderer,
                      //                           remoteRenderer:
                      //                               _remoteRenderer,
                      //                           incomingfrom: incomingfrom,
                      //                           registerRes: registerRes,
                      //                           stopCall: stopCall,
                      //                           callTo: callTo,
                      //                           // signalingClient: signalingClient,
                      //                           callProvider: _callProvider,
                      //                           authProvider: authProvider,
                      //                           contactProvider:
                      //                               contactProvider,
                      //                           groupListprovider:
                      //                               groupListProvider,
                      //                           contactList: contactProvider
                      //                               .contactList,
                      //                           popCallBAck:
                      //                               screenPopCallBack)),
                      //             ),
                      //           );
                      //           pressDuration = "";
                      //           ticker.cancel();
                      //         },
                      //         child: new Container(
                      //             height: 40,
                      //             alignment: Alignment.center,
                      //             color: Colors.green,
                      //             child: Text("$pressDuration")),
                      //       ),
                      //     ],
                      //   )
                      // : SizedBox(height: 0),
                      Expanded(
                          child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: listProvider.groupList.groups.length,
                        itemBuilder: (context, index) {
                          String _presenceStatus = "";
                          int _count = 0;
                          if (listProvider.groupList.groups[index].participants
                                  .length ==
                              1) {
                            if (listProvider.presenceList.indexOf(listProvider
                                    .groupList
                                    .groups[index]
                                    .participants[0]
                                    .ref_id) !=
                                -1)
                              _presenceStatus = "online";
                            else
                              _presenceStatus = "offline";
                          } else if (listProvider.groupList.groups[index]
                                  .participants.length ==
                              2) {
                            listProvider.groupList.groups[index].participants
                                .forEach((element) {
                              if (listProvider.presenceList
                                      .indexOf(element.ref_id) !=
                                  -1) _count++;
                            });
                            if (_count < 2)
                              _presenceStatus = "offline";
                            else
                              _presenceStatus = "online";
                          } else {
                            listProvider.groupList.groups[index].participants
                                .forEach((element) {
                              if (listProvider.presenceList
                                      .indexOf(element.ref_id) !=
                                  -1) _count++;
                            });
                            _presenceStatus = "(" +
                                _count.toString() +
                                "/" +
                                listProvider
                                    .groupList.groups[index].participants.length
                                    .toString() +
                                ") online";
                          }

                          //The Container returned that will show the Group Name, notification counter and availability status//
                          return
                              // InkWell(
                              //   onTap: () {
                              //     listProvider.setCountZero(index);
                              //     Navigator.pushNamed(context, "/chatScreen",
                              //         arguments: {
                              //           "index": index,
                              //           "publishMessage": publishMessage,
                              //           "groupListProvider": groupListProvider
                              //         });

                              //     handleSeenStatus(index);
                              //   },
                              //child:
                              Container(
                            // width: 375,
                            // height: 80,
                            child: Column(
                              children: [
                                SizedBox(height: 22),
                                InkWell(
                                    onTap: () {
                                      listProvider.setCountZero(index);
                                      Navigator.pushNamed(
                                          context, "/chatScreen",
                                          arguments: {
                                            "index": index,
                                            "publishMessage": publishMessage,
                                            "groupListProvider":
                                                groupListProvider,
                                            "callProvider": callProvider,
                                            "funct": _startCall,
                                            "navigate": navigateCallBack,
                                            "contactProvider": contactProvider,
                                            "pushCallBack": screenPushCallBack
                                            // "callbackfunction": _startCall
                                          });

                                      handleSeenStatus(index);
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              //The Group Title Shows Here
                                              Flexible(
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: listProvider
                                                              .groupList
                                                              .groups[index]
                                                              .participants
                                                              .length ==
                                                          1
                                                      ? Text(
                                                          "${listProvider.groupList.groups[index].participants[0].full_name}",
                                                          //  maxLines: 2,

                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color:
                                                                personNameColor,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                primaryFontFamily,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      : listProvider
                                                                  .groupList
                                                                  .groups[index]
                                                                  .participants
                                                                  .length ==
                                                              2
                                                          ? Text(
                                                              "${listProvider.groupList.groups[index].participants[listProvider.groupList.groups[index].participants.indexWhere((element) => element.ref_id != authProvider.getUser.ref_id)].full_name}",
                                                              //maxLines: 2,

                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color:
                                                                    personNameColor,
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    primaryFontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ))
                                                          : Text(
                                                              "${listProvider.groupList.groups[index].group_title}",
                                                              //  maxLines: 2,

                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color:
                                                                    personNameColor,
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    primaryFontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )),
                                                ),
                                              ),
                                              SizedBox(width: 3),

                                              //The Notification Counter for Each Group//
                                              listProvider
                                                              .groupList
                                                              .groups[index]
                                                              .counter ==
                                                          null ||
                                                      listProvider
                                                              .groupList
                                                              .groups[index]
                                                              .counter ==
                                                          0
                                                  ? Text("")
                                                  :
                                                  // Container(

                                                  //    child:

                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8),
                                                      child: Container(
                                                        width: (listProvider
                                                                        .groupList
                                                                        .groups[
                                                                            index]
                                                                        .counter
                                                                        .toString()
                                                                        .length ==
                                                                    1 ||
                                                                listProvider
                                                                        .groupList
                                                                        .groups[
                                                                            index]
                                                                        .counter
                                                                        .toString()
                                                                        .length ==
                                                                    2)
                                                            ? 16
                                                            : 20,
                                                        height: (listProvider
                                                                        .groupList
                                                                        .groups[
                                                                            index]
                                                                        .counter
                                                                        .toString()
                                                                        .length ==
                                                                    1 ||
                                                                listProvider
                                                                        .groupList
                                                                        .groups[
                                                                            index]
                                                                        .counter
                                                                        .toString()
                                                                        .length ==
                                                                    2)
                                                            ? 16
                                                            : 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              personOfflineColor,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "${listProvider.groupList.groups[index].counter}",
                                                            maxLines: 1,
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color:
                                                                  counterTextColor,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  "Inter",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                            ),
                                                          ),
                                                          //),
                                                        ),
                                                      ),
                                                    ),

                                              // Center(
                                              //                                                             child: Container(
                                              //     width: 16,
                                              //     height: 16,
                                              //     decoration:
                                              //         BoxDecoration(
                                              //       shape: BoxShape
                                              //           .circle,
                                              //       color:
                                              //           personOfflineColor,
                                              //     ),
                                              //   ),
                                              // ),
                                              // Positioned.fill(
                                              //   child: Align(
                                              //     alignment:
                                              //         Alignment
                                              //             .center,
                                              //     child: SizedBox(
                                              //       height: 15,
                                              //       child: Text(
                                              //         "${listProvider.groupList.groups[index].counter}",
                                              //         maxLines: 1,
                                              //         overflow:
                                              //             TextOverflow
                                              //                 .ellipsis,
                                              //         style:
                                              //             TextStyle(
                                              //           color:
                                              //               counterTextColor,
                                              //           fontSize:
                                              //               12,
                                              //           fontFamily:
                                              //               "Inter",
                                              //           fontWeight:
                                              //               FontWeight
                                              //                   .w800,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              //  )],
                                              //           ),
                                              //  ],

                                              //  ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 24,
                                          width: 24,
                                          margin: EdgeInsets.only(right: 29),

//                                         child: Column(children:
// [

                                          child: PopupMenuButton(
                                              offset: Offset(8, 30),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              icon: const Icon(
                                                Icons.more_horiz,
                                                size: 24,
                                                color: horizontalDotIconColor,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                        PopupMenuItem(
                                                          enabled: (listProvider
                                                                          .groupList
                                                                          .groups[
                                                                              index]
                                                                          .participants
                                                                          .length ==
                                                                      1 ||
                                                                  listProvider
                                                                          .groupList
                                                                          .groups[
                                                                              index]
                                                                          .participants
                                                                          .length ==
                                                                      2)
                                                              ? false
                                                              : true,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 12,
                                                                  left: 12),
                                                          value: 1,

                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 14,
                                                                    left: 16,
                                                                    right: 70),
                                                            width: 200,
                                                            height: 44,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    backgroundChatColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            //  color:popupGreyColor,
                                                            child: Text(
                                                              "Edit Group Name",
                                                              //textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                //decoration: TextDecoration.underline,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    font_Family,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                color:
                                                                    personNameColor,
                                                              ),
                                                            ),
                                                          ),
                                                          //)
                                                        ),
                                                        //SizedBox(height: 8,),

                                                        PopupMenuItem(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 12,
                                                                    left: 12),
                                                            value: 2,
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: 14,
                                                                    left: 16,
                                                                  ),
                                                                  width: 200,
                                                                  height: 44,
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          backgroundChatColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  //  color:popupGreyColor,
                                                                  child: Text(
                                                                    "Delete",
                                                                    style: TextStyle(
                                                                        //decoration: TextDecoration.underline,
                                                                        fontSize: font_size,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontFamily: font_Family,
                                                                        fontStyle: FontStyle.normal,
                                                                        color: popupDeleteButtonColor),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ],
                                              onSelected: (menu) {
                                                if (menu == 1) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return ListenableProvider<
                                                                GroupListProvider>.value(
                                                            value:
                                                                groupListProvider,
                                                            child:
                                                                CreateGroupPopUp(
                                                              editGroupName:
                                                                  true,
                                                              groupid:
                                                                  listProvider
                                                                      .groupList
                                                                      .groups[
                                                                          index]
                                                                      .id,
                                                              controllerText:
                                                                  listProvider
                                                                      .groupList
                                                                      .groups[
                                                                          index]
                                                                      .group_title,
                                                              groupNameController:
                                                                  _groupNameController,
                                                              publishMessage:
                                                                  publishMessage,
                                                              authProvider:
                                                                  authProvider,
                                                            ));
                                                      });
                                                  print("i am after here");
                                                  // if (groupListProvider
                                                  //         .editGroupNameStatus ==
                                                  //     EditGroupNameStatus
                                                  //         .Success) {
                                                  //   showSnakbar(groupListProvider
                                                  //       .successMsg);
                                                  // } else if (groupListProvider
                                                  //         .editGroupNameStatus ==
                                                  //     EditGroupNameStatus
                                                  //         .Failure) {
                                                  //   showSnakbar(groupListProvider
                                                  //       .errorMsg);
                                                  // } else {}
                                                  //  if(groupListProvider.editGroupNameStatus)

                                                } else if (menu == 2) {
                                                  _showDialog(
                                                      listProvider.groupList
                                                          .groups[index].id,
                                                      listProvider.groupList
                                                          .groups[index]);
                                                  // groupListProvider.deleteGroup(
                                                  //     listProvider.groupList
                                                  //         .groups[index].id);
                                                }
                                              }),
//]),
                                        ),
                                      ],
                                    )),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          width: 235,
                                          padding: EdgeInsets.only(left: 20),
                                          child: listProvider.groupList
                                                      .groups[index].chatList ==
                                                  null
                                              ? Text("",
                                                  style: TextStyle(
                                                    color: messageStatusColor,
                                                    fontSize: 14,
                                                  ))
                                              : (listProvider
                                                                  .groupList
                                                                  .groups[index]
                                                                  .counter ==
                                                              null ||
                                                          listProvider
                                                                  .groupList
                                                                  .groups[index]
                                                                  .counter ==
                                                              0) &&
                                                      listProvider
                                                              .groupList
                                                              .groups[index]
                                                              .chatList
                                                              .last
                                                              .type !=
                                                          0
                                                  ? Text(
                                                      listProvider
                                                                  .groupList
                                                                  .groups[index]
                                                                  .chatList
                                                                  .last
                                                                  .type ==
                                                              "text"
                                                          ? "${listProvider.groupList.groups[index].chatList.last.content}"
                                                          : "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color:
                                                            messageStatusColor,
                                                        fontSize: 14,
                                                      ))
                                                  : listProvider
                                                              .groupList
                                                              .groups[index]
                                                              .chatList
                                                              .last
                                                              .type ==
                                                          0
                                                      ? Text("Image",
                                                          style: TextStyle(
                                                            color:
                                                                messageStatusColor,
                                                            fontSize: 14,
                                                          ))
                                                      // :
                                                      // listProvider
                                                      //         .groupList
                                                      //         .groups[index]
                                                      //         .chatList
                                                      //         .last
                                                      //         .type ==
                                                      //     1
                                                      // ? Text("Audio",
                                                      //     style: TextStyle(
                                                      //       color:
                                                      //           messageStatusColor,
                                                      //       fontSize: 14,
                                                      //     )):
                                                      //     listProvider
                                                      //         .groupList
                                                      //         .groups[index]
                                                      //         .chatList
                                                      //         .last
                                                      //         .type ==
                                                      //     2
                                                      // ? Text("Video",
                                                      //     style: TextStyle(
                                                      //       color:
                                                      //           messageStatusColor,
                                                      //       fontSize: 14,
                                                      //     )):
                                                      //     listProvider
                                                      //         .groupList
                                                      //         .groups[index]
                                                      //         .chatList
                                                      //         .last
                                                      //         .type ==
                                                      //     3
                                                      // ? Text("File",
                                                      //     style: TextStyle(
                                                      //       color:
                                                      //           messageStatusColor,
                                                      //       fontSize: 14,
                                                      //     )):

                                                      : Text("Misread Messages",
                                                          style: TextStyle(
                                                            color:
                                                                messageStatusColor,
                                                            fontSize: 14,
                                                          ))),
                                    ),
                                    Container(
                                      // height: 15,
                                      // width: 51,
                                      margin: EdgeInsets.only(right: 24),
                                      child: listProvider.groupList
                                                      .groups[index].counter ==
                                                  null ||
                                              listProvider.groupList
                                                      .groups[index].counter ==
                                                  0
                                          ? Text(
                                              _presenceStatus,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color:
                                                    _presenceStatus != "offline"
                                                        ? chatRoomColor
                                                        : personOfflineColor,
                                                fontSize: 10,
                                              ),
                                            )
                                          : Text(
                                              _presenceStatus,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color:
                                                    _presenceStatus != "offline"
                                                        ? chatRoomColor
                                                        : personOfflineColor,
                                                fontSize: 10,
                                              ),
                                            ),
                                    )
                                  ],
                                ),
                                // SizedBox(height: 3),
                                // SizedBox(
                                //   height: 2,
                                //   width: 367,
                                //   child: Divider(
                                //     color: listdividerColor,
                                //     thickness: 1.0,
                                //   ),
                                // ),
                              ],
                            ),
                            //),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 24),
                            child: Divider(
                              thickness: 1,
                              color: listdividerColor,
                            ),
                          );
                        },
                      )),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // padding: const EdgeInsets.only(bottom: 60),
                                    child: FlatButton(
                                      onPressed: () {
                                        authProvider.logout();
                                        emitter.disconnect();
                                        signalingClient
                                            .unRegister(registerRes["mcToken"]);
                                      },
                                      child: Text(
                                        "LOG OUT",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: primaryFontFamily,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700,
                                            color: logoutButtonColor,
                                            letterSpacing: 0.90),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                    width: 25,
                                    child: SvgPicture.asset(
                                      'assets/messageicon.svg',
                                      color: isConnect && widget.state
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  // Container(
                                  //   height: 10,
                                  //   width: 10,
                                  //   decoration: BoxDecoration(
                                  //       color: isConnect && widget.state
                                  //           ? Colors.green
                                  //           : Colors.red,
                                  //       shape: BoxShape.circle),
                                  // ),
                                  // Container(
                                  //   margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  //   height: 10,
                                  //   width: 10,
                                  //   decoration: BoxDecoration(
                                  //       color: sockett && widget.state
                                  //           ? Colors.green
                                  //           : Colors.red,
                                  //       shape: BoxShape.circle),
                                  // )
                                  SizedBox(width: 13),
                                  Container(
                                    height: 18,
                                    width: 18,
                                    child: SvgPicture.asset(
                                      'assets/call.svg',
                                      color: sockett && widget.state
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  padding: const EdgeInsets.only(bottom: 60),
                                  child: Text(authProvider.getUser.full_name))
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              // floatingActionButton: Padding(
              //   padding: EdgeInsets.only(bottom: 40),
              //   child: FloatingActionButton(
              //       heroTag: Text("btn2"),
              //       mini: true,
              //       child: Icon(Icons.add),
              //       onPressed: () async {
              //         Navigator.pushNamed(context, '/creategroup',
              //             arguments: groupListProvider);
              //       }),
              // ),
            );
        }

        //The Screen Displayed in case of error//
        else
          return Scaffold(
            appBar: CustomAppBar(
              groupListProvider: groupListProvider,
              title: "Chat Rooms",
              lead: false,
              succeedingIcon: 'assets/plus.png',
              ischatscreen: false,
            ),
            body: Center(
                child: Text(
              "${listProvider.errorMsg}",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            )),
          );
      },
    );
  }
}
