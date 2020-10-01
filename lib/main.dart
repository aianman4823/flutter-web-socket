import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Web Socket App"),
        ),
        body: WebSocketDemo(),
      ),
    );
  }
}

class WebSocketDemo extends StatefulWidget {
  final WebSocketChannel channel =
      IOWebSocketChannel.connect("wss://echo.websocket.org/");
  @override
  _WebSocketDemoState createState() => _WebSocketDemoState(channel: channel);
}

class _WebSocketDemoState extends State<WebSocketDemo> {
  final WebSocketChannel channel;
  final inputController = TextEditingController();
  List<String> messageList = [];

  _WebSocketDemoState({this.channel}) {
    channel.stream.listen((data) {
      print(data);
      setState(() {
        messageList.add(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: inputController,
                  decoration: InputDecoration(
                    labelText: "Send Message",
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () {
                    if (inputController.text.isNotEmpty) {
                      channel.sink.add(inputController.text);
                      inputController.text = '';
                    } else {
                      print('none');
                    }
                  },
                  child: Text(
                    "Send",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: getMessageList(),
          // child:StreamBuilder(
          //   stream: widget.channel.stream,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData){
          //       messageList.add(snapshot.data);
          //     }

          //     return getMessageList();
          //   }
          // ),
        ),
      ]),
    );
  }

  ListView getMessageList() {
    List<Widget> listWidget = [];
    for (String message in messageList) {
      listWidget.add(
        ListTile(
          title: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: TextStyle(fontSize: 22),
              ),
            ),
            color: Colors.teal[50],
            height: 60,
          ),
        ),
      );
    }
    return ListView(children: listWidget);
  }

  @override
  void dispose() {
    inputController.dispose();
    channel.sink.close();
    super.dispose();
  }
}
