import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jp_lesson/constants.dart';
import 'package:jp_lesson/widget/vidoe_player.dart';
import 'package:like_button/like_button.dart';

class KaiwaPage extends StatefulWidget {
  const KaiwaPage({super.key});

  @override
  State<KaiwaPage> createState() => _KaiwaPageState();
}

class _KaiwaPageState extends State<KaiwaPage> {
  final _userStrem =
      FirebaseFirestore.instance.collection('Kaia_Video').snapshots();
  var videoLength;
  TextEditingController inputComment = TextEditingController();
  bool isLike = false;
  int count = 0;

  @override
  void dispose() {
    super.dispose();
    inputComment.dispose();
  }

  @override
  void initState() {
    super.initState();
    // isLiked = like.contains(currentUser!.email.toString());
  }

  void toggleLike() {
    setState(() {
      isLike = !isLike;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ConnectionNotifierToggler(
              disconnected: const Center(child: CircularProgressIndicator()),
              connected: StreamBuilder(
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
                    return PageView.builder(
                      itemCount: docs.length,
                      controller:
                          PageController(initialPage: 0, viewportFraction: 1),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            VideoPlayerWidget(videoUrl: docs[index]['url']),
                            Positioned(
                              bottom: 20,
                              right: 10,
                              child: Column(
                                children: [
                                  LikeButton(
                                    likeBuilder: (isLiked) {
                                      return Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            isLiked ? Colors.red : Colors.white,
                                        size: 30,
                                      );
                                    },
                                  ),
                                  // LikeButton(
                                  //     isLiked: isLiked, onTap: toggleLike),
                                  const Text('Like',
                                      style: TextStyle(color: Colors.white)),
                                  const SizedBox(height: 10),
                                  IconButton(
                                      onPressed: () {
                                        comment(docs[index]['id'].toString());
                                      },
                                      icon: const Icon(
                                        Ionicons.chatbubble_ellipses_outline,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                  const Text('Comments',
                                      style: TextStyle(color: Colors.white)),
                                  const SizedBox(height: 10),
                                  const Icon(
                                    Ionicons.bookmark_outline,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  const Text('Save',
                                      style: TextStyle(color: Colors.white)),
                                  const SizedBox(height: 10),
                                  const Icon(
                                    Ionicons.arrow_redo_outline,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  const Text('Share',
                                      style: TextStyle(color: Colors.white)),
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        'https://media.tenor.com/GqAwMt01UXgAAAAi/cd.gif',
                                        fit: BoxFit.cover,
                                        height: 30,
                                        width: 30,
                                      ))
                                ],
                              ),
                            ),
                            Positioned(
                                left: 10,
                                bottom: 20,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text((docs[index]['userName']),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1),
                                    const SizedBox(height: 10),
                                    Text((docs[index]['description']),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.music_note,
                                            color: Colors.white),
                                        const SizedBox(width: 5),
                                        Text(
                                          docs[index]['songName'],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        );
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void comment(String videoId) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('${videoLength.toString()} Comments'),
              ),
              // Spacer(),
              Expanded(
                flex: 1,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Kaia_Video")
                        .doc(videoId)
                        .collection('comments')
                        .snapshots(),
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
                      var docs = snapshot.data!.docs;
                      videoLength = docs.length;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: docs[index]['userProfile']
                                        .toString()
                                        .isEmpty
                                    ? Image.network(
                                        'https://t3.ftcdn.net/jpg/00/53/01/86/360_F_53018621_KQbIttjKsgF4LIH6JwpACBSdTHgepTLz.jpg',
                                        fit: BoxFit.cover,
                                        height: 40,
                                        width: 40)
                                    : Image.network(
                                        docs[index]['userProfile'],
                                        fit: BoxFit.cover,
                                        height: 40,
                                        width: 40,
                                      )),
                            title: Text(docs[index]['userName']),
                            subtitle: Text(docs[index]['userComment']),
                            trailing:
                                const Icon(Icons.favorite_border_outlined),
                          );
                        },
                      );
                    }),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 10,
                    right: 10,
                    top: MediaQuery.of(context).viewInsets.top),
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: inputComment,
                    decoration: InputDecoration(
                        hintText: 'Add comment',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              if (inputComment.text.isEmpty) {
                                return;
                              }
                              addComment(videoId);
                            },
                            icon: const Icon(Ionicons.send))),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void addComment(String videoId) {
    // final currentUser = firebaseAuth.currentUser;
    final addComment = firestore
        .collection("Kaia_Video")
        .doc(videoId)
        .collection('comments')
        .doc();

    firestore
        .collection('Users')
        .doc(currentUser!.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      var docs = documentSnapshot.data() as Map<String, dynamic>;

      addComment.set({
        'userName': docs['name'],
        'userComment': inputComment.text,
        'userProfile': docs['url']
      });
    });
    setState(() {});
  }

  void addLike(String videoId) {
    DocumentReference videoRef =
        firestore.collection('Kaia_Video').doc(videoId);
    if (isLike == true) {
      videoRef.update({
        'Likes': FieldValue.arrayUnion([firebaseAuth.currentUser!.email])
      });
    } else {
      videoRef.update({
        'Likes': FieldValue.arrayRemove([firebaseAuth.currentUser!.email])
      });
    }
  }
}
