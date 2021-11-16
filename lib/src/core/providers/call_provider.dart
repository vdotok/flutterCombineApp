import 'package:flutter/foundation.dart';
enum CallStatus {
  Initial,
  CallReceive,
  CallStart,
  CallDial,
  CallProgress
}
class CallProvider with ChangeNotifier{
  CallStatus _callStatus =CallStatus.Initial;
  //String _pressure="";
   String _pressure="";
  String get pressure => _pressure;



CallStatus _callProgress=CallStatus.CallStart;
  CallStatus get callprogress => _callProgress;




  CallStatus get callStatus => _callStatus;
  initial(){
    _callStatus=CallStatus.Initial;
    print("i am here in initial  notify listener");
    notifyListeners();
  }
  Future<void> getPressure(String pp) async {
  //await Future.delayed(const Duration(milliseconds: 100), (){});
    _pressure=pp;
      print("SJNJSFBsjfbksjbfsj $_pressure");
  

  notifyListeners();
}
  //  getPressure(String pp){
  //    _pressure=pp;
  //    print("SJNJSFBsjfbksjbfsj $_pressure");
  //    notifyListeners();
  //  }
  callReceive(){
    _callStatus=CallStatus.CallReceive;
    notifyListeners();
  }

  callStart(){
    _callStatus=CallStatus.CallStart;
      print("this is before call astart in call accept in call provider");
    notifyListeners();
  }

  callDial(){
    _callStatus=CallStatus.CallDial;
    print("In call provider. call dial");
    notifyListeners();
  }

  // callProgress(){
  //  // print("KLLLLLLLLL $isCall");
  //   _callProgress=CallStatus.CallProgress;
  //  // _callStatus=CallStatus.CallDial;
  //   notifyListeners();
 // }

}