import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/Admin/Video%20Function/AddVideo.dart';
import 'package:sexpertise/Interfaces/Admin/Video%20Function/ViewVideoAdmin.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({super.key});

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  final _videos = FirebaseFirestore.instance.collection('Videos').snapshots();

  String selectedIndex = '';
  String videoId = '';

  TextEditingController _search = TextEditingController();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Videos",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 74, 173),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddVideo(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.add_circle,
                    color: Color.fromARGB(255, 0, 74, 173),
                    size: 40,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    width: 100,
                    height: 45,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 0, 74, 173),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 74, 173),
                            width: 2.0,
                          ),
                        ),
                        labelText: 'Search',
                      ),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          search = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: StreamBuilder(
                stream: _videos,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Connection Error");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading......");
                  }
                  var docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      if (_search.text.toString().isEmpty) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex =
                                      docs[index]['Video_ID'].toString();

                                  videoId = YoutubePlayer.convertUrlToId(
                                      docs[index]['Video_Link'].toString())!;
                                  print(selectedIndex);
                                  print(videoId);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ViewVideoAdmin(
                                        id: selectedIndex,
                                        videoID: videoId,
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 244, 243, 243),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 0, 74, 173),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Image.asset(
                                          'lib/Assets/video-player.png'),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              docs[index]['Topic'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (docs[index]['Topic']
                          .toLowerCase()
                          .contains(_search.text.toString())) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex =
                                      docs[index]['Video_ID'].toString();
                                  videoId = YoutubePlayer.convertUrlToId(
                                      docs[index]['Video_Link'].toString())!;

                                  print(selectedIndex);
                                  print(videoId);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ViewVideoAdmin(
                                        id: selectedIndex,
                                        videoID: videoId,
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 244, 243, 243),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 0, 74, 173),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Image.asset(
                                          'lib/Assets/video-player.png'),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              docs[index]['Topic'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
