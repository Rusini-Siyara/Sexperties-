import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/Admin/Video%20Function/EditVideo.dart';
import 'package:sexpertise/Interfaces/Admin/Video%20Function/VideoListPage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewVideoAdmin extends StatefulWidget {
  final String? id;
  final String? videoID;
  const ViewVideoAdmin({super.key, required this.id, required this.videoID});

  @override
  State<ViewVideoAdmin> createState() => _ViewVideoAdminState();
}

class _ViewVideoAdminState extends State<ViewVideoAdmin> {
  YoutubePlayerController? _controller;

  bool isClicked = false;
  String? id;
  String? videoID;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    videoID = widget.videoID;
    getData(id!);

    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
    );
  }

  String? topic;
  String? description;
  String? video;

  void getData(String uId) async {
    final DocumentSnapshot videoDoc =
        await FirebaseFirestore.instance.collection("Videos").doc(uId).get();

    setState(() {
      topic = videoDoc.get('Topic');
      description = videoDoc.get('Description');
      video = videoDoc.get('Video_Link');
    });

    print(videoID);
  }

  //Delete Video
  void deleteData(String uId) async {
    await FirebaseFirestore.instance.collection('Videos').doc(uId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Video",
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                '$topic',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
              ),
              const SizedBox(
                height: 10,
              ),
              Text('$description'),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditVideo(id: widget.id),
                    ),
                  );
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 35, 60, 135),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 4.0),
                        blurRadius: 4.0,
                        color: Color.fromARGB(63, 0, 0, 0),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  deleteData(id!);

                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => VideoListPage()),
                    );
                  });
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 4.0),
                        blurRadius: 4.0,
                        color: Color.fromARGB(63, 0, 0, 0),
                      ),
                    ],
                  ),
                  child: Center(
                    child: isClicked
                        ? CircularProgressIndicator()
                        : Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
