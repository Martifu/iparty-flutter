import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:IParty/src/models/mesagge_model.dart';

class Chat extends StatefulWidget {
  final int userId;
  final List<Message> messages;
  final Function(String) onSend;

  const Chat(this.userId,
      {Key key, this.messages = const [], @required this.onSend})
      : super(key: key);

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  var _isTheEnd = false;
  var unread = 0;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  

  _onSend() {
    final text = _controller.value.text;
    if (text.trim().length == 0) {
      return;
    }

    if (widget.onSend != null) {
      widget.onSend(text);
    }
    _controller.text = '';
  }

  goToEnd() {
    setState(() {
      unread = 0;
    });
    Timer(Duration(milliseconds: 300), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
  }

  checkUnread() {
    if (_scrollController.position.maxScrollExtent == 0) return;
    if (_isTheEnd) {
      goToEnd();
    } else {
      setState(() {
        unread++;
      });
    }
  }

  Widget _item(Message message) {
    final isMe = widget.userId == message.from;
  
    return Container(
      child: Wrap(
        alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: isMe ? Color(0xffFF5722) : Color(0xffFFECE5),
                  borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),bottomLeft: Radius.circular(20),) : BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),bottomRight: Radius.circular(20),)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  Text(
                    message.mensaje,
                    style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: size.width,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: NotificationListener(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: widget.messages.length,
                        itemBuilder: (context, index) {
                          final message = widget.messages[index];
                          return _item(message);
                        }),
                    onNotification: (t) {
                      if (t is ScrollEndNotification) {
                        if (_scrollController.offset >=
                            _scrollController.position.maxScrollExtent) {
                          _isTheEnd = true;
                        } else {
                          _isTheEnd = false;
                        }
                      }
                      return false;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: CupertinoTextField(
                          controller: _controller,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                              color: Color(0xffd2d2d2),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      SizedBox(width: 10),
                      CupertinoButton(
                        onPressed: _onSend,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        borderRadius: BorderRadius.circular(20),
                        minSize: 30,
                        color:  Color(0xffff5722),
                        child: Icon(FontAwesomeIcons.paperPlane, size: 18,),
                      ),
                    ],
                  ),
                )
              ],
            ),
            unread > 0
                ? Positioned(
                    left: 10,
                    bottom: 60,
                    child: Stack(
                      children: <Widget>[
                        CupertinoButton(
                          color: Color(0xffdddddd),
                          borderRadius: BorderRadius.circular(30),
                          padding: EdgeInsets.all(5),
                          onPressed: goToEnd,
                          child: Icon(
                            Icons.arrow_downward,
                            color: Colors.blue,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: Text(
                                unread.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        )
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}