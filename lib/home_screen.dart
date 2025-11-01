import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchData();
  }

  bool isFetching = false;
  final List<FootballMatch> data = [];
  // Future<void> fetchData() async {
  //   setState(() {
  //     isFetching = true;
  //   });
  //   data.clear();
  //   final snaphot = await FirebaseFirestore.instance
  //       .collection('football_score')
  //       .get();
  //   print("Documents found: ${snaphot.docs.length}");

  //   for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snaphot.docs) {
  //     data.add(
  //       FootballMatch(
  //         id: doc.id,
  //         is_running: doc.get('is_running'),
  //         team1_name: doc.get('team1_name'),
  //         team1_score: doc.get('team1_score'),
  //         team2_name: doc.get('team2_name'),
  //         team2_score: doc.get('team2_score'),
  //         winner: doc.get('winner'),
  //       ),
  //     );
  //     setState(() {
  //       isFetching = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Live Scores'),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout_outlined),
            ),
          ],
          backgroundColor: Colors.amber,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('football_score')
              .snapshots(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (asyncSnapshot.hasError) {
              return Center(child: Text(asyncSnapshot.error.toString()));
            } else if (asyncSnapshot.hasData) {
              data.clear();
              for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                  in asyncSnapshot.data!.docs) {
                data.add(
                  FootballMatch(
                    id: doc.id,
                    is_running: doc.get('is_running'),
                    team1_name: doc.get('team1_name'),
                    team1_score: doc.get('team1_score'),
                    team2_name: doc.get('team2_name'),
                    team2_score: doc.get('team2_score'),
                    winner: doc.get('winner'),
                  ),
                );
              }

              return ListView.separated(
                itemBuilder: (context, index) => ListTile(
                  subtitle: Text(
                    'Winner: ${data[index].winner.isNotEmpty ? data[index].winner : 'N/A'}',
                  ),
                  title: Text(
                    '${data[index].team1_name} vs ${data[index].team2_name}',
                  ),
                  leading: CircleAvatar(
                    backgroundColor: data[index].is_running
                        ? Colors.green
                        : Colors.grey,
                    radius: 10,
                  ),
                  trailing: Text(
                    '${data[index].team1_score}-${data[index].team2_score}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                separatorBuilder: (context, index) => Divider(),
                itemCount: data.length,
              );
            } else {
              return Center(child: Text('NO DATA'));
            }
          },
        ),
      ),
    );
  }
}

class FootballMatch {
  final String id;
  final bool is_running;
  final String team1_name;
  final int team1_score;
  final String team2_name;
  final int team2_score;
  final String winner;

  FootballMatch({
    required this.id,
    required this.is_running,
    required this.team1_name,
    required this.team1_score,
    required this.team2_name,
    required this.team2_score,
    required this.winner,
  });
}
