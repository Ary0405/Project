import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:swapsta/models/swappable.dart';
import 'package:uuid/uuid.dart';
import '../../globals.dart' as globals;



/*
Changes made:
Font updation,box shadows,ui fixes and some other minor changes
*/
class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  static const routeName = '/add-item';

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final categories = globals.categories;
  late List<Map<String, dynamic>> dropdownItems = [];
  String selectedValue = "Stationery";
  double rating = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    categories.asMap().forEach((index, value) => {
          if (index != 0)
            {
              dropdownItems.add({
                "text": value.name,
                "emoji": value.emoji,
                "value": value.id,
              }),
            }
        });
    super.initState();
  }

  void dispose() {
    print("dispose");
    // This is the line that breaks when called inside setState() of onPressed() method
    _titleController.dispose();
    super.dispose();
  }

  List<String> imageUrls = [];
  List<File> imageFile = [];
  final picker = ImagePicker();
  Future selectImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imageFile.add(File(pickedFile.path));
      } else {
        return;
      }
    });
  }

  Future selectImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile.add(File(pickedFile.path));
      } else {
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var item_id = Uuid().v4();
    Future<void> addItemToDatabase() async {
      final firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final itemDocument = firestore.collection('items').doc(item_id);
        final newItem = {
          'id': item_id,
          'name': _titleController.text,
          'imageUrls': imageUrls,
          'category': selectedValue,
          'ownerName': user.displayName,
          'ownerId': user.email,
          'ownerImageUrl': user.photoURL,
          'condition': rating,
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'swapRequests': 0,
          'description': _descriptionController.text,
          'swapped': false
        };
        // Update the 'items' array in the user document
        try {
          await itemDocument.set(newItem);
        } on Exception catch (e) {
          print(e);
        }
      }
      return;
    }

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (arguments['title'] == null) {
    } else {}
    bool isLoading = true;
    Future<void> uploadFile(imagePath) async {
      File file = imagePath;
      if (isLoading) {
        showDialog(
          // The user CANNOT close this dialog  by pressing outsite it
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return Dialog(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    // Some text
                    Text('Loading...')
                  ],
                ),
              ),
            );
          },
        );
      }
      String imageName =
          'productImages/${DateTime.now().millisecondsSinceEpoch}';
      String downloadUrl = '';
      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadUrl =
            await FirebaseStorage.instance.ref(imageName).getDownloadURL();
        setState(() {
          imageUrls.add(downloadUrl);
        });
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: _buildAppBar(arguments['header']),
        backgroundColor: Color.fromARGB(255, 251, 249, 246),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.001),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Product Name*',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    // const SizedBox(
                    //   height: 7,
                    // ),

                    TextField(
                      maxLength: 50,
                      controller: _titleController,
                      decoration: InputDecoration(
                          counterText: " ",
                          hintText: 'Enter Product Name',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: const EdgeInsets.all(8),
                          filled: true,
                          fillColor: Color.fromARGB(245, 249, 249, 249),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                    ),
                  ],
                ),
              ),

              //input for desc
              Column(
                //describe your product
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align children to the left

                children: [
                  const Text(
                    'Description*',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  Container(
                    height: 100,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 200,
                      controller: _descriptionController,
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.done, //mark done

                      decoration: InputDecoration(
                        counterText: " ",
                        hintText: 'Describe your product',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(245, 249, 249, 249), //upd
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(11)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(11)),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * .03),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload Image(s)*',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 40,
                            ),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(245, 249, 249, 249),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(11)),
                            ),
                            child: ElevatedButton(
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: const CircleBorder()),
                              onPressed: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: ((context, setState) {
                                        return Container(
                                          padding: const EdgeInsets.only(
                                            left: 30,
                                            right: 30,
                                            top: 25,
                                            bottom: 40,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Select One Option',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: selectImageCamera,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          color: Colors.black,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 16.0,
                                                            vertical: 16.0,
                                                          ),
                                                          child: Text(
                                                            'Choose from camera',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Inter',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: selectImageGallery,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons.image_outlined,
                                                          color: Colors.black,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 16.0,
                                                            vertical: 16.0,
                                                          ),
                                                          child: Text(
                                                            'Choose from Gallery',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Inter',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                    );
                                  }),
                            ),
                          ),
                          (imageFile.isNotEmpty)
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * .36,
                                  width:
                                      MediaQuery.of(context).size.width * .55,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imageFile.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.file(
                                          imageFile[index],
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Category*',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedValue,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              filled: true,
                              fillColor: Color.fromARGB(245, 249, 249, 249),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                          icon: const Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.black,
                          ),
                          items: dropdownItems.map((e) {
                            return DropdownMenuItem<String>(
                              child: Row(
                                children: [
                                  Text(e['emoji']),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .05,
                                  ),
                                  Text(e['text']),
                                ],
                              ),
                              value: e['text'],
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Condition',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Ink(
                        padding: EdgeInsets.all(13),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(245, 249, 249, 249),
                          borderRadius: BorderRadius.all(Radius.circular(11)),
                        ),
                        child: RatingBar.builder(
                          minRating: 1,
                          itemSize: 22,
                          allowHalfRating: true,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 2),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.black,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              this.rating = rating;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Ink(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.black,
                  ),
                  color: Colors.black,
                ),
                child: InkWell(
                  splashColor: const Color.fromRGBO(
                    255,
                    255,
                    255,
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      for (File item in imageFile) {
                        await uploadFile(item);
                      }
                      await addItemToDatabase();
                      setState(() {
                        isLoading = false;
                        imageFile.clear();
                        _titleController.clear();
                        _descriptionController.clear();
                        selectedValue = "Stationery";
                        rating = 0;
                      });
                    } catch (error) {
                      setState(() {
                        isLoading = false;
                      });
                    }

                    setState(() {
                      isLoading = false;
                    });
                    final swappableProvider = Provider.of<SwappableProvider>(
                      context,
                      listen: false,
                    );
                    await swappableProvider.fetchSwappables();
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 17,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Create Product',
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildAppBar(String? header) {
  if (header == null) {
    return Text(
      'Add Item',
      textAlign: TextAlign.left,
    );
  }
  return Text(
    'Edit Item',
    textAlign: TextAlign.left,
  );
}
