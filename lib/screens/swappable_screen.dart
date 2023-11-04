import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:provider/provider.dart';
import 'package:swapsta/providers/auth_provider.dart';
import 'package:swapsta/screens/image_screen.dart';
import 'package:swapsta/widgets/condition.dart';
import 'package:swapsta/widgets/swap_dialog.dart';
import '../models/swappable.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:intl/intl.dart';

class SwappableScreen extends StatelessWidget {
  static const routeName = '/swappable';

  const SwappableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String emoji(String category) {
      switch (category) {
        case 'Electronics':
          return '📱';
        case 'Stationary':
          return '📚';
        case 'Clothing':
          return '👕';
        case 'Sports':
          return '⚽';
        // Add more cases for other categories if needed
        default:
          return '';
      }
    }

    final user = Provider.of<Auth>(context);
    final authUser = FirebaseAuth.instance.currentUser!;
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final swappable = routeArgs as Swappable;
    //formatting swappable.updatedAt
    String formattedDate =
        DateFormat('dd MMMM y ,').add_jm().format(swappable.updatedAt);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'swappable-${swappable.id}',
              child: ImageSlideshow(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                initialPage: 0,
                indicatorColor: const Color.fromARGB(255, 55, 51, 46),
                isLoop: swappable.imageUrls.length > 1,
                autoPlayInterval: 4000,
                children: swappable.imageUrls
                    .map(
                      (url) => GestureDetector(
                        onTap: () {
                          Navigator.push<Widget>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageScreen(
                                url: swappable.imageUrls,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Image.network(
                              url,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.7),
                                    blurRadius: 30,
                                    spreadRadius: 0,
                                    offset: const Offset(0, -30),
                                    inset: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    //avatar
                    children: [
                      //ownername
                      Text(
                        (swappable.ownerId == authUser.email)  //you box
                            ? "You"
                            : swappable.ownerName,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),                   
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    // width: double.infinity,
                    child: Text(              //mitumitu box
                      swappable.name,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                   SizedBox(
                    width: double.infinity,
                    child: Text(              //mitumitu box
                      'Description',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14.8,
                        fontWeight: FontWeight.w700,
                        color: Colors.black
                      ),
                    ),
                  ),



                  //description
                  SizedBox(

                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: SingleChildScrollView(
                      child: Text(
                        swappable.description,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  //condition
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Condition: ',
                        style: TextStyle(
                          fontSize: 14.8,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          
                        ),
                        
                      ),
                      
                      ConditionStars(swappable.condition)
                    ],
                  ),
                  
                  //buttons
                  Container(
                      child: (swappable.ownerId != authUser.email)
                          ? Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildSwappableButton(
                                    context: context,
                                    wishlist: (user.wishlist
                                            .containsKey(swappable.id))
                                        ? true
                                        : false,
                                    onPressed: () {
                                      user.toggleWishlist(swappable.id);
                                    },
                                  ),
                                  Material(
                                    child: Ink(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
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
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => SwapDialog(
                                              swappableItem: swappable,
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.swap_horiz,
                                                color: Colors.white,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      'Request Swap',
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                  ),
                                ],
                              ),
                            )
                          : (null)
                      //swap button
                      ),
                  const SizedBox(
                    height: 11,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Last updated at ' + formattedDate,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildSwappableButton({
  required BuildContext context,
  required bool wishlist,
  required Function onPressed,
}) {
  return Material(
    color: Colors.transparent,
    child: Ink(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        color: wishlist ? Colors.black : const Color(0xFFF9F6F2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: wishlist ? Colors.transparent : Colors.black,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: const Color.fromRGBO(255, 152, 0, 0.2),
        highlightColor: Colors.transparent,
        onTap: (() => onPressed()),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                wishlist ? Icons.favorite : Icons.favorite_border,
                color: wishlist ? Colors.white : Colors.black,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      wishlist ? 'Saved' : 'Add to Wishlist',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: wishlist ? Colors.white : Colors.black,
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
  );
}
