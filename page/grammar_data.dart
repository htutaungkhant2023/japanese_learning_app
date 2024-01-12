import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jp_lesson/constants.dart';

class GrammarDataPage extends StatefulWidget {
  const GrammarDataPage({super.key, required this.data, required this.id});
  final data;
  final id;

  @override
  State<GrammarDataPage> createState() => _GrammarDataPageState();
}

class _GrammarDataPageState extends State<GrammarDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Back"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: StreamBuilder<DocumentSnapshot>(
            stream: firestore
                .collection('Grammar')
                .doc(widget.id)
                .collection("GrammarDetail")
                .doc(widget.data['title'].toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('Connection error');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              var docs = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.data['title'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(child: Text(widget.data['subtitle'],style: const TextStyle(fontSize: 16),)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(docs['pattern'].toString())),
                      // const Icon(Icons.add),
                      Text(" + ${widget.data['title'].toString()}")
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Explanation",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.star),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(
                        docs['explain1'],
                        maxLines: 5,
                      ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.star),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(
                        docs['explain2'],
                        style: const TextStyle(color: Colors.black),
                        maxLines: 5,
                      ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "How to use",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                          child: Text(
                        'れい',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(
                        docs['example1'],
                        maxLines: 5,
                      ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                          child: Text(
                        'れい',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(
                        docs['example2'],
                        maxLines: 5,
                      ))
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
