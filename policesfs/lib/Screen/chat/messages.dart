import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/message_bubble.dart';

class Messages extends StatelessWidget {
  var id;
  Messages(this.id);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'date',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final chatDocs = chatSnapshot.data!.docs;

          return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => ((chatDocs[index]['senderid'] ==
                              "BXwySkot9bw59oDsbhN" ||
                          chatDocs[index]['receiverid'] ==
                              "BXwySkot9bw59oDsbhN") &&
                      (chatDocs[index]['senderid'] == id["receiverid"] ||
                          chatDocs[index]['receiverid'] == id["receiverid"]))
                  ? MessageBubble(
                      chatDocs[index]['message'],
                      chatDocs[index]['SenderName'],
                      chatDocs[index]['role'],
                      chatDocs[index]['senderid'] == "BXwySkot9bw59oDsbhN",
                      chatDocs[index]['receiverid'],
                      key: ValueKey(chatDocs[index].id),
                    )
                  : Container());
        });
  }
}
