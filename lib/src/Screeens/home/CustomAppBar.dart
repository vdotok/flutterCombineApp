import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdkFlutterChat/src/Screeens/home/home.dart';
import 'package:vdkFlutterChat/src/core/models/GroupModel.dart';
import 'package:vdkFlutterChat/src/core/providers/auth.dart';
import 'package:vdkFlutterChat/src/core/providers/call_provider.dart';
import 'package:vdotok_connect/vdotok_connect.dart';
import '../../constants/constant.dart';
import '../../core/providers/groupListProvider.dart';



class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final title;
  final bool lead;
  final succeedingIcon;
  final bool ischatscreen;
  final index;
  final GroupListProvider groupListProvider;
  final AuthProvider authProvider;
  final CallProvider callProvider;
  final funct;

  CustomAppBar(
      {Key key,
      this.groupListProvider,
      this.title,
      @required this.lead,
      this.succeedingIcon,
      this.ischatscreen,
      this.index,
      this.authProvider,
      this.callProvider,
      this.funct})
      : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize {
    return ischatscreen ? Size.fromHeight(80) : Size.fromHeight(kToolbarHeight);
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Size get preferredSize {
    return widget.ischatscreen
        ? Size.fromHeight(80)
        : Size.fromHeight(kToolbarHeight);
  }

  Emitter emitter;

  String _presenceStatus = "";

  int _count = 0;

  @override
  Widget build(BuildContext context) {
    //   emitter.onPresence = (res) {
    //   print("Presence  $res");

    //   groupListProvider.handlePresence(json.decode(res));
    // };
    if (widget.ischatscreen) {
      //    emitter.onPresence = (res) {
      //   print("Presence  $res");

      //   groupListProvider.handlePresence((res));
      // };
      print(
          "this is group length ${widget.groupListProvider.groupList.groups[widget.index].participants.length}");
      if (widget.groupListProvider.groupList.groups[widget.index].participants
              .length ==
          1) {
        if (widget.groupListProvider.presenceList.indexOf(widget
                .groupListProvider
                .groupList
                .groups[widget.index]
                .participants[0]
                .ref_id) !=
            -1) {
          print("hereeeeee");
          _presenceStatus = "online";
        } else
          _presenceStatus = "offline";
      } else if (widget.groupListProvider.groupList.groups[widget.index]
              .participants.length ==
          2) {
        print("i am in 2");
        widget.groupListProvider.groupList.groups[widget.index].participants
            .forEach((element) {
          if (widget.groupListProvider.presenceList.indexOf(element.ref_id) !=
              -1) _count++;
        });
        if (_count < 2)
          _presenceStatus = "offline";
        else
          _presenceStatus = "online";
      }
    } else {
      print("nothing");
    }

    return AppBar(
      backgroundColor:
          widget.ischatscreen ? appbarBackgroundColor : chatRoomBackgroundColor,
      elevation: 0.0,
      centerTitle: false,
      leading: widget.lead == true
          ? widget.ischatscreen == true
              ? Padding(
                  padding: widget.ischatscreen == true
                      ? EdgeInsets.only(left: 20, top: 21)
                      : EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: chatRoomColor,
                    ),
                    onPressed: () {
                      widget.groupListProvider
                          .handlBacktoGroupList(widget.index);
                      Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                    },
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: chatRoomColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
          : null,
      title: widget.ischatscreen == true
          ? //name of user if participants count is 1
          widget.groupListProvider.groupList.groups[widget.index].participants
                      .length ==
                  1
              //Without Typing Status//
              ? Padding(
                  padding: const EdgeInsets.only(top: 21.0),
                  child: Text(
                    "${widget.groupListProvider.groupList.groups[widget.index].participants[0].full_name}",
                    style: TextStyle(
                      color: userTitleColor,
                      fontSize: 20,
                      fontFamily: primaryFontFamily,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : widget.groupListProvider.groupList.groups[widget.index]
                          .participants.length ==
                      2
                  ? Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: Text(
                        "${widget.groupListProvider.groupList.groups[widget.index].participants[widget.groupListProvider.groupList.groups[widget.index].participants.indexWhere((element) => element.ref_id != widget.authProvider.getUser.ref_id)].full_name}",
                        style: TextStyle(
                          color: userTitleColor,
                          fontSize: 20,
                          fontFamily: primaryFontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: Text(
                        "${widget.groupListProvider.groupList.groups[widget.index].group_title}",
                        style: TextStyle(
                          color: userTitleColor,
                          fontSize: 20,
                          fontFamily: primaryFontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )

          //With Typing Status//
          // : Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //         groupListProvider
          //                     .groupList.groups[index].typingstatus ==
          //                 true
          //             ? SizedBox(height: 15)
          //             : SizedBox(height: 20),
          //         groupListProvider.groupList.groups[index].participants
          //                     .length ==
          //                 1
          //             ? Text(
          //                 "${groupListProvider.groupList.groups[index].participants[0].full_name}",
          //                 style: TextStyle(
          //                   color: userTitleColor,
          //                   fontWeight: FontWeight.w400,
          //                   fontSize: 14,
          //                 ),
          //               )
          //             : groupListProvider.groupList.groups[index]
          //                         .participants.length ==
          //                     2
          //                 ? Text(
          //                     "${groupListProvider.groupList.groups[index].participants[groupListProvider.groupList.groups[index].participants.indexWhere((element) => element.ref_id != authProvider.getUser.ref_id)].full_name}",
          //                     style: TextStyle(
          //                       color: userTitleColor,
          //                       fontWeight: FontWeight.w400,
          //                       fontSize: 14,
          //                     ),
          //                   )
          //                 : Text(
          //                     "${groupListProvider.groupList.groups[index].group_title}",
          //                     style: TextStyle(
          //                       color: userTitleColor,
          //                       fontSize: 14,
          //                     ),
          //                   ),
          //       ])

          : Text("${widget.title}",
              style: TextStyle(
                color: chatRoomColor,
                fontSize: 20,
                fontFamily: primaryFontFamily,
                fontWeight: FontWeight.w500,
              )),
      bottom: widget.ischatscreen == true
          //&&
          // (groupListProvider.groupList.groups[index].typingstatus != "" &&
          //             groupListProvider.groupList.groups[index].typingstatus !=
          //                 null  )

          ? PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.only(left: 73.0, bottom: 5),
                    child:

                        // (_count < 2)
                        //     ? Text(_presenceStatus)
                        //

                        (widget.groupListProvider.groupList.groups[widget.index]
                                        .typingstatus !=
                                    "" &&
                                widget.groupListProvider.groupList
                                        .groups[widget.index].typingstatus !=
                                    null)
                            ? (widget.groupListProvider.typingUserDetail
                                        .length >
                                    1)
                                ? Text(
                                    "${widget.groupListProvider.groupList.groups[widget.index].typingstatus} are typing...",
                                    style: TextStyle(
                                      color: userTypingColor,
                                      fontSize: 14,
                                    ),
                                  )
                                : Text(
                                    "${widget.groupListProvider.groupList.groups[widget.index].typingstatus} is typing...",
                                    style: TextStyle(
                                      color: userTypingColor,
                                      fontSize: 14,
                                    ),
                                  )
                            : Text(
                                _presenceStatus,
                                style: TextStyle(
                                  color: _presenceStatus != "offline"
                                      ? userTypingColor
                                      : personOfflineColor,
                                  fontSize: 14,
                                ),
                              )),
              ),
            )
          : PreferredSize(preferredSize: Size.fromHeight(0), child: Text("")),
      actions: [
        //If we are on chat screen//

        widget.ischatscreen == true
            ?
            //Container()
            Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 21.0),
                    child: Container(
                      width: 35,
                      height: 35,
                      child: IconButton(
                        icon: SvgPicture.asset('assets/call.svg'),
                        onPressed: widget.groupListProvider.callprogress == true
                            ? () {}
                            : () {
                                print("I am in audiocall press");
                                setState(() {
                                  iscalloneto1=false;
                                });
                                //  widget.callProvider.callDial();

                                //  print("DJNVJDBVJDBVJDBVJDBVHDHBBJLLLLL ${widget.groupListProvider.groupList.groups[widget.index].participants[widget.groupListProvider.groupList.groups[widget.index].participants.indexWhere((element) => element.ref_id != widget.authProvider.getUser.ref_id)].full_name.toString()}");
                                callTo = widget
                                    .groupListProvider
                                    .groupList
                                    .groups[widget.index]
                                    .participants[0]
                                    .full_name
                                    .toString();
                                print("AMMMMMMMMMMMM $callTo");
                                GroupModel model = widget.groupListProvider
                                    .groupList.groups[widget.index];
                                print("this is groupmodel $model");
                                widget.funct(model, CallMediaType.audio,
                                    CAllType.many2many, SessionType.call);
                                // _startCall([test.ref_id], CallMediaType.audio,
                                //     CAllType.one2one, SessionType.call);
                                // setState(() {
                                //  callTo = widget.groupListProvider.groupList.groups[widget.index].participants[0].full_name;
                                //   meidaType = CallMediaType.audio;
                                //   print("this is callTo $callTo");
                                // });
                                // print("three dot icon pressed");
                              },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 21.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: SvgPicture.asset('assets/videocallicon.svg'),
                        onPressed: widget.groupListProvider.callprogress == true
                            ? () {}
                            : () {
                              setState(() {
                                  iscalloneto1=false;
                                });
                                // print("I am in audiocall press");
                                callTo = widget
                                    .groupListProvider
                                    .groupList
                                    .groups[widget.index]
                                    .participants[0]
                                    .full_name
                                    .toString();
                                print("AMMMMMMMMMMMM $callTo");
                                GroupModel model = widget.groupListProvider
                                    .groupList.groups[widget.index];
                                widget.funct(model, CallMediaType.video,
                                    CAllType.many2many, SessionType.call);
                                //   widget.callProvider.callDial();
                                // _startCall([test.ref_id], CallMediaType.video,
                                //     CAllType.one2one, SessionType.call);
                                // setState(() {
                                //   callTo = test.full_name;
                                //   meidaType = CallMediaType.video;
                                // });
                                // print("three dot icon pressed");
                              },
                      ),
                    ),
                  ),
                  SizedBox(width: 14)
                ],
              )
            :
            //If we are on other screens//
            Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: widget.succeedingIcon == ""
                    ? Container()
                    : IconButton(
                        icon: SvgPicture.asset(widget.succeedingIcon),
                        onPressed: widget.succeedingIcon == 'assets/plus.svg'
                            ? () {
                                print(
                                    "THSI IS DFFVDFJCJDFBKJD ${widget.callProvider}");
                                Navigator.pushNamed(context, '/contactlist',
                                    arguments: {
                                      "groupListProvider":
                                          widget.groupListProvider,
                                      "funct": widget.funct,
                                      "callProvider": widget.callProvider
                                    });
                              }
                            : () {},
                      ),
              ),
      ],
    );
  }
}
