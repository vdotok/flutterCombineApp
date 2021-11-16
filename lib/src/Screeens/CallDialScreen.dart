import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdkFlutterChat/src/Screeens/home/home.dart';
import 'package:vdkFlutterChat/src/Screeens/home/streams/remoteStream.dart';
import 'package:vdkFlutterChat/src/constants/constant.dart';
import 'package:vdkFlutterChat/src/core/providers/auth.dart';
import 'package:vdkFlutterChat/src/core/providers/call_provider.dart';
import 'package:vdkFlutterChat/src/core/providers/contact_provider.dart';
import 'package:vdotok_stream/vdotok_stream.dart';

import 'home/CustomAppBar.dart';

class CallDialScreen extends StatefulWidget {
  final mediaType;
  final remoteRenderer;
  final callTo;
  final incomingfrom;
  final callingTo;
  //final pressDuration;
  final CallProvider callProvider;
  final AuthProvider authProvider;
  final ContactProvider contactProvider;
  final localRenderer;
  final VoidCallback stopCall;
  final SignalingClient signalingClient;
  final registerRes;
//  final rendererListWithRefID;
  // final remoteVideoFlag;

  const CallDialScreen({
    Key key,
    this.mediaType,
    this.remoteRenderer,
    this.callTo,
    this.incomingfrom,
    // this.pressDuration,

    this.localRenderer,
    this.stopCall,
    this.signalingClient,
    this.registerRes,
    this.callProvider,
    this.authProvider,
    this.contactProvider,
    // this.rendererListWithRefID,
    this.callingTo,
    // this.remoteVideoFlag,
  }) : super(key: key);

  @override
  _CallDialScreenState createState() => _CallDialScreenState();
}

class _CallDialScreenState extends State<CallDialScreen> {
  // String _pressDuration = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("DNJDNJDGNJDHGJDHGJ ${rendererListWithRefID[0]["rtcVideoRenderer"]}");
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          children: [
            widget.mediaType == "video"
                ? Container(
                    // color: Colors.red,
                    //margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: RemoteStream(
                      remoteRenderer: rendererListWithRefID[0]
                          ["rtcVideoRenderer"],
                    )

                    // RTCVideoView(
                    //     rendererListWithRefID[0]["rtcVideoRenderer"],
                    //     key: forDialView,
                    //     mirror: false,
                    //     objectFit: RTCVideoViewObjectFit
                    //         .RTCVideoViewObjectFitCover),
                    )
                : Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        backgroundAudioCallDark,
                        backgroundAudioCallLight,
                        backgroundAudioCallLight,
                        backgroundAudioCallLight,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment(0.0, 0.0),
                    )),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/userIconCall.svg',
                      ),
                    ),
                  ),
            Container(
                padding: EdgeInsets.only(top: 120),
                alignment: Alignment.center,
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Calling",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontFamily: secondaryFontFamily,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: darkBlackColor),
                      ),
                      callTo != "" &&  iscalloneto1==true?
                               Text(
                              "$callTo",
                              style: TextStyle(
                                  fontFamily: primaryFontFamily,
                                  color: darkBlackColor,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 24),
                            )
                          : callTo!="" ?
                          Expanded(
                              child: ListView.builder(
                                itemCount: widget.callingTo.length,
                                itemBuilder: (context, index) {
                                  print(
                                      "this is calling to length ${widget.callingTo.length}");
                                  return Container(
                                    alignment: Alignment.center,
                                    child: (widget.callingTo[index].full_name ==
                                            widget
                                                .authProvider.getUser.full_name)
                                        ? SizedBox(
                                            height: 0,
                                          )
                                        : Text(
                                            widget.callingTo[index].full_name,
                                            //  widget.callingTo[index].full_name,
                                            // widget.callingTo[index].full_name==widget.
                                            style: TextStyle(
                                                fontFamily: primaryFontFamily,
                                                color: darkBlackColor,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 24),
                                          ),
                                  );
                                },
                              ),
                            )
                            :Container(),
                          
                    ])),
            Container(
              padding: EdgeInsets.only(bottom: 56),
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                child: SvgPicture.asset(
                  'assets/end.svg',
                ),
                onTap: () {
                  widget.signalingClient
                      .onCancelbytheCaller(widget.registerRes["mcToken"]);
                  widget.callProvider.initial();
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
