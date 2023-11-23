import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/swappable.dart';
import '../providers/auth_provider.dart';
import '../screens/swappable_screen.dart';
import 'condition.dart';

class SwappableCard extends StatelessWidget {
  final Swappable swappable;

  const SwappableCard({
    Key? key,
    required this.swappable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    final authUser = FirebaseAuth.instance.currentUser!;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        splashColor: const Color.fromRGBO(255, 152, 0, 0.2),
        // highlightColor: const Color(0x00ffffff),
        onTap: () {
          Navigator.of(context).pushNamed(
            SwappableScreen.routeName,
            arguments: swappable,
          );
        },
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'swappable-${swappable.id}',
                  child: Material(
                    child: Ink(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(swappable.imageUrls[0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * .2,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Material(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.transparent,
                    child: (swappable.ownerId != authUser.email)
                        ? IconButton(
                            splashRadius: 20,
                            onPressed: () async {
                              var wishRef = FirebaseFirestore.instance
                                  .collection('wishlist');
                              var items = [];
                              var wish = {
                                "id": swappable.id,
                                "name": swappable.name,
                                "imageUrls": swappable.imageUrls,
                                "description": swappable.description,
                                "category": swappable.category,
                                "ownerName": swappable.ownerName,
                                "ownerId": swappable.ownerId,
                                "ownerImageUrl": swappable.ownerImageUrl,
                                "condition": swappable.condition,
                                "createdAt": swappable.createdAt,
                                "updatedAt": swappable.updatedAt,
                                "swapRequests": swappable.swapRequests,
                                "swapped": swappable.swapped,
                              };
                              var data =
                                  await wishRef.doc(authUser.email).get();
                              if (!data.exists) {
                                print("yoyo");
                                items.add(wish);
                                var data = {
                                  "items": items,
                                };
                                wishRef.doc(authUser.email).set(data);
                              } else {
                                print("yo333yo");
                                // print(data.data()?['items']);
                                bool exists = data.data()?['items'].any(
                                      (obj) => obj['id'] == swappable.id,
                                    );

                                items = data.data()?['items'];
                                if (exists) {
                                  items.removeWhere(
                                    (obj) => obj['id'] == swappable.id,
                                  );
                                  wishRef.doc(authUser.email).update(
                                    {"items": items},
                                  );
                                } else {
                                  items.add(wish);
                                  wishRef.doc(authUser.email).update(
                                    {"items": items},
                                  );
                                }
                              }
                              user.toggleWishlist(swappable.id);
                            },
                            icon: FutureBuilder(
                              future: user.itemExists(swappable.id),
                              builder: (context, snapshot) {
                                print(snapshot.connectionState);
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return Icon(
                                    (snapshot.data == true)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.white,
                                  );
                                }
                              },
                            ),
                            color: Colors.white,
                            splashColor: const Color.fromRGBO(255, 152, 0, 0.2),
                          )
                        : null,
                  ),
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * .115,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    swappable.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * .035,
                        backgroundImage: NetworkImage(swappable.ownerImageUrl),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          (swappable.ownerId == authUser.email)
                              ? "You"
                              : swappable.ownerName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  //condition
                  ConditionStars(swappable.condition),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
