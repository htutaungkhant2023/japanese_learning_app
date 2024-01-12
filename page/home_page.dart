import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jp_lesson/page/grammar_page.dart';
import 'package:jp_lesson/page/profile_page.dart';
import 'package:jp_lesson/page/video_page/kaiwa_page.dart';
import 'package:jp_lesson/page/video_page/song_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

int index = 0;

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final firestore = FirebaseStorage.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Learning Japanese',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  )),
              child: ConnectionNotifierToggler(
                disconnected: const Center(child: CircularProgressIndicator()),
                connected: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(currentUser?.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return userData['url'].toString().isEmpty 
                            ? Image.network(
                                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                userData['url'].toString(),
                                fit: BoxFit.cover,
                              );
                      } else if (snapshot.hasError) {
                        // print('error');
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
            iconSize: 30,
          )
        ],
      ),
      body: TabBarView(
          controller: _tabController,
          children: <Widget>[TopTabBar(), GrammarPage()]),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
          onTap: (value) {
            setState(() {
              _tabController.index = value;
            });
          },
          currentIndex: _tabController.index,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Ionicons.book), label: 'Grammer'),
          ]),
    );
  }
}

class TopTabBar extends StatefulWidget {
  const TopTabBar({super.key});

  @override
  State<TopTabBar> createState() => _TopTabBatState();
}

class _TopTabBatState extends State<TopTabBar>
    with SingleTickerProviderStateMixin {
  List<Widget> homePageWidget = [KaiwaPage(), SongPage()];
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: TabBar(controller: tabController, tabs: const [
          Tab(text: 'Kaiwa'),
          Tab(text: 'Song'),
        ]),
      ),
      body: TabBarView(controller: tabController, children: homePageWidget),
    );
  }
}
