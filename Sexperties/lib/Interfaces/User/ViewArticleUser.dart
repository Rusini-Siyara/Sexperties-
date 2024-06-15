import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewArticleUser extends StatefulWidget {
  final String? id;
  const ViewArticleUser({super.key, required this.id});

  @override
  State<ViewArticleUser> createState() => _ViewArticleUserState();
}

class _ViewArticleUserState extends State<ViewArticleUser> {
  bool isClicked = false;
  String? id;

  @override
  void initState() {
    super.initState();

    id = widget.id;
    getData(id!);
  }

  String? topic;
  String? description;
  String? imageUrl;
  String? tag01;
  List<String> _tagsList = [];

  void getData(String uId) async {
    final DocumentSnapshot articleDoc =
        await FirebaseFirestore.instance.collection("Articles").doc(uId).get();

    setState(() {
      topic = articleDoc.get('Topic');
      description = articleDoc.get('Description');
      imageUrl = articleDoc.get('Image');
      _tagsList = List<String>.from(articleDoc.get('Tags') ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Article",
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
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color.fromARGB(255, 0, 74, 173),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage('$imageUrl'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
              Text('$description'),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Tags:",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 74, 173),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _tagsList.isEmpty
                        ? const Text(
                            "No Tags",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _tagsList[0],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 74, 173),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _tagsList.isEmpty
                        ? const Text(
                            "No Tags",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _tagsList[1],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 74, 173),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _tagsList.isEmpty
                        ? const Text(
                            "No Tags",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _tagsList[2],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 74, 173),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _tagsList.isEmpty
                        ? const Text(
                            "No Tags",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _tagsList[3],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 74, 173),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _tagsList.isEmpty
                        ? const Text(
                            "No Tags",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _tagsList[4],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
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
