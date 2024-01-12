import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:jp_lesson/page/grammar_detail.dart';

class GrammarPage extends StatefulWidget {
  const GrammarPage({super.key});

  @override
  State<GrammarPage> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  // List<CategoryModel> categories = [];

  // void _getCategories() {
  //   categories = CategoryModel.getcategories();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _getCategories();
  // }

  final _userStream =
      FirebaseFirestore.instance.collection('Grammar').snapshots();

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.sizeOf(context);
    // _getCategories();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            const Text('Grammar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: ConnectionNotifierToggler(
                disconnected: const Center(child: CircularProgressIndicator()),
                connected: StreamBuilder(
                    stream: _userStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Connection error');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var docs = snapshot.data!.docs;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GrammarDetailPage(data: docs[index], id: docs[index]['id'].toString(),),
                                    ));
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: docs[index]['url'].toString().isEmpty
                                ? Image.asset(
                                  'images/img/japanLogo.jpg',
                                  fit: BoxFit.cover,
                                  width: 35,
                                  height: 35,
                                )
                                :Image.network(
                                  docs[index]['url'].toString(),
                                  fit: BoxFit.cover,
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                              title: Text(docs[index]['title']),
                              subtitle: Text(docs[index]['subTitle']),
                            ),
                          );
                        },
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
