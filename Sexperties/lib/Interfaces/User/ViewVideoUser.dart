import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewVideoUser extends StatefulWidget {
  final String? id;
  final String? videoID;
  const ViewVideoUser({super.key, required this.id, required this.videoID});

  @override
  State<ViewVideoUser> createState() => _ViewVideoUserState();
}

class _ViewVideoUserState extends State<ViewVideoUser> {
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
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
