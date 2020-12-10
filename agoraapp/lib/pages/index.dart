import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool _validateError = false;

  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height * 6 / 100,
          ),
          Container(
            height: size.height * 5 / 100,
            width: double.infinity,
            child: Image.asset("assets/images/agoralogo.png"),
          ),
          SizedBox(
            height: size.height * 3 / 100,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 4 / 100),
            width: double.infinity,
            child: Text(
              "Join a Channel",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 1 / 100,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 4 / 100),
            width: double.infinity,
            child: TextFormField(
              controller: _channelController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                errorText: _validateError ? 'Channel name is mandatory' : null,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
                hintText: 'Channel name',
                prefixIcon: Icon(
                  FontAwesomeIcons.video,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      // body: Center(
      //   child: Container(
      //     padding: const EdgeInsets.symmetric(horizontal: 20),
      //     height: 400,
      //     child: Column(
      //       children: <Widget>[
      //         Row(
      //           children: <Widget>[
      //             Expanded(
      //                 child: TextField(
      //               controller: _channelController,
      //               decoration: InputDecoration(
      //                 errorText: _validateError ? 'Channel name is mandatory' : null,
      //                 border: UnderlineInputBorder(
      //                   borderSide: BorderSide(width: 1),
      //                 ),
      //                 hintText: 'Channel name',
      //               ),
      //             ))
      //           ],
      //         ),
      //         Column(
      //           children: [
      //             ListTile(
      //               title: Text("Join as a Broadcaster"),
      //               leading: Radio(
      //                 value: ClientRole.Broadcaster,
      //                 groupValue: _role,
      //                 onChanged: (ClientRole value) {
      //                   setState(() {
      //                     _role = value;
      //                   });
      //                 },
      //               ),
      //             ),
      //             ListTile(
      //               title: Text("Join as a Spectator"),
      //               leading: Radio(
      //                 value: ClientRole.Audience,
      //                 groupValue: _role,
      //                 onChanged: (ClientRole value) {
      //                   setState(() {
      //                     _role = value;
      //                   });
      //                 },
      //               ),
      //             )
      //           ],
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 20),
      //           child: Row(
      //             children: <Widget>[
      //               Expanded(
      //                 child: RaisedButton(
      //                   onPressed: onJoin,
      //                   child: Text('Join'),
      //                   color: Colors.blueAccent,
      //                   textColor: Colors.white,
      //                 ),
      //               )
      //             ],
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty ? _validateError = true : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
