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
            height: size.height * 2 / 100,
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
          SizedBox(
            height: size.height * 3 / 100,
          ),
          ListTile(
            title: Text("Join as a Broadcaster"),
            leading: Radio(
              value: ClientRole.Broadcaster,
              groupValue: _role,
              onChanged: (ClientRole value) {
                setState(() {
                  _role = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text("Join as a Spectator"),
            leading: Radio(
              value: ClientRole.Audience,
              groupValue: _role,
              onChanged: (ClientRole value) {
                setState(() {
                  _role = value;
                });
              },
            ),
          ),
          SizedBox(
            height: size.height * 5 / 100,
          ),
          Container(
            padding: EdgeInsets.all(size.height * 1 / 100),
            width: size.width * 40 / 100,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: FlatButton(
              onPressed: onJoin,
              child: Container(
                child: Text(
                  'Join',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              color: Colors.blueAccent,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty ? _validateError = true : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
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
