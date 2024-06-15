import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/Admin/Blog%20Function/ArticleListPage.dart';
import 'package:sexpertise/Interfaces/Admin/Blog%20Function/EditArticle.dart';

class ViewArticleAdmin extends StatefulWidget {
  final String? id;
  const ViewArticleAdmin({super.key, required this.id});

  @override
  State<ViewArticleAdmin> createState() => _ViewArticleAdminState();
}

class _ViewArticleAdminState extends State<ViewArticleAdmin> {
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

  //Delete Image
  Future<void> deleteImage() async {
    try {
      final Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl!);

      await imageRef.delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  //Delete Data
  void deleteData(String uId) async {
    await FirebaseFirestore.instance.collection('Articles').doc(uId).delete();
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
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditArticle(id: widget.id),
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
                  deleteImage().then((_) {
                    print('Deleted Sucess!');
                    setState(() {
                      isClicked = false;
                    });
                    deleteData(id!);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Article Delete Sucesss!')),
                  );

                  setState(() {
                    isClicked = false;
                  });

                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArticleListAdmin()),
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
