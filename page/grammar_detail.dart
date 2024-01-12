import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jp_lesson/constants.dart';
import 'package:jp_lesson/page/grammar_data.dart';

class GrammarDetailPage extends StatefulWidget {
  const GrammarDetailPage(
      {super.key, required this.data, required this.id});
  final data;
  final id;

  @override
  State<GrammarDetailPage> createState() => _GrammarDetailPageState();
}

class _GrammarDetailPageState extends State<GrammarDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.data['title']),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Ionicons.search))]),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection('Grammar')
              .doc(widget.id)
              .collection("GrammarData")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('Connection error');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GrammarDataPage(data: docs[index], id: widget.id.toString(),)));
                    },
                    leading: CircleAvatar(
                        child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(docs[index]['id']),
                    )),
                    title: Text(
                      docs[index]['title'].toString(),
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(docs[index]['subtitle'].toString(),maxLines: 1),
                  ),
                );
              },
            );
          }),
    );
  }
}
