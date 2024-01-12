import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jp_lesson/widget/youtube_controller.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});
  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final _userStrem =
      FirebaseFirestore.instance.collection('Songs').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _userStrem,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const Text(
                  'Connection error!',
                  style: TextStyle(color: Colors.yellow),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              }
              var docs = snapshot.data!.docs..shuffle();
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Card(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: YoutubePlayerWidget(
                                  videoUrl: docs[index]["url"],
                                  videoAspectRatio: 16 / 9,
                                  videoController: false),
                            )),
                        // const SizedBox(height: 15)
                      ],
                    );
                  });
            }));
  }
}
