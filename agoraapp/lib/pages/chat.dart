import 'package:flutter/material.dart';
import 'package:pubnub/core.dart';
import 'package:pubnub/pubnub.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var pubnub;
  var myChannel;
  var subscription;
  List<String> messageHistory = [];
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    pubnub = PubNub(defaultKeyset: Keyset(subscribeKey: 'demo', publishKey: 'demo', uuid: UUID('demo')));
    myChannel = await pubnub.channel('ch1');
    subscription = await pubnub.subscribe(channels: {'ch1'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          RaisedButton(
            onPressed: () async {
              await myChannel.publish({"message": "Hello, how are you?"});
              subscription.messages.listen((envelope) {
                print('${envelope.uuid} sent a message: ${envelope.payload}');
              });
              var envelope = await subscription.messages.firstWhere((envelope) => envelope.channel == 'ch1');
              var history = myChannel.messages(from: Timetoken(1234567890));

              var count = await history.count();
              print(count);

              var messages = await history.fetch();
              print(messages.length);

              setState(() {
                messageHistory.add(envelope.payload['message']);
              });
            },
            child: Text("Send"),
          ),
          Container(
            height: 300,
            child: ListView.builder(
              itemCount: messageHistory.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Text(messageHistory[index]) ?? Text("empty"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
