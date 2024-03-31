import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tukangnow1/comps/styles.dart';
import 'package:tukangnow1/comps/widgets.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String workerId;
  final String userid;
  final String provider;
  final String bookingId;
 
  const ChatPage({Key? key, required this.workerId, required this.userid, required this.provider, required this.bookingId}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var roomId;
  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    return Scaffold(
      backgroundColor: Colors.indigo.shade400,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade400,
        title:  Text(widget.bookingId),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Chats',
                  style: Styles.h1(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: Styles.friendsBox(),
              child: StreamBuilder(
                  stream: firestore.collection('Rooms').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        List<QueryDocumentSnapshot?> allData = snapshot
                            .data!.docs
                            .where((element) =>
                                element['users'].contains(widget.userid) &&
                                element['users'].contains(
                                    FirebaseAuth.instance.currentUser!.uid))
                            .toList();
                        QueryDocumentSnapshot? data =
                            allData.isNotEmpty ? allData.first : null;
                        if (data != null) {
                          roomId = data.id;
                        }
                        return data == null
                            ? Container()
                            : StreamBuilder(
                                stream: data.reference
                                    .collection('messages')
                                    .orderBy('datetime', descending: true)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snap) {
                                  return !snap.hasData
                                      ? Container()
                                      : ListView.builder(
                                          itemCount: snap.data!.docs.length,
                                          reverse: true,
                                          itemBuilder: (context, i) {
                                            return ChatWidgets.messagesCard(
                                                snap.data!.docs[i]['sent_by'] ==
                                                    FirebaseAuth.instance.currentUser!.uid,
                                                snap.data!.docs[i]['message'],
                                                DateFormat('hh:mm a').format(
                                                    snap.data!
                                                        .docs[i]['datetime']
                                                        .toDate()));
                                          },
                                        );
                                });
                      } else {
                        return Center(
                          child: Text(
                            'No conversion found',
                            style: Styles.h1()
                                .copyWith(color: Colors.indigo.shade400),
                          ),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.indigo,
                        ),
                      );
                    }
                  }),
            ),
          ),
          Container(
            color: Colors.white,
            child: ChatWidgets.messageField(onSubmit: (controller) {
              if(controller.text.toString() != ''){
                if (roomId != null) {
                  Map<String, dynamic> data = {
                    'message': controller.text.trim(),
                    'sent_by': FirebaseAuth.instance.currentUser!.uid,
                    'datetime': DateTime.now(),
                  };
                  firestore.collection('Rooms').doc(roomId).update({
                    'last_message_time': DateTime.now(),
                    'last_message': controller.text,
                  });
                  firestore
                      .collection('Rooms')
                      .doc(roomId)
                      .collection('messages')
                      .add(data);
                } else {
                  Map<String, dynamic> data = {
                    'message': controller.text.trim(),
                    'sent_by': FirebaseAuth.instance.currentUser!.uid,
                    'datetime': DateTime.now(),
                  };
                  firestore.collection('Rooms').add({
                    'users': [
                      widget.userid,
                      FirebaseAuth.instance.currentUser!.uid,
                    ],
                    'last_message': controller.text,
                    'last_message_time': DateTime.now(),
                  }).then((value) async {
                    value.collection('messages').add(data);
                  });
                }
              }
              controller.clear();
            }),
          )
        ],
      ),
    );
  }
}
