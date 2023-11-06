import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/swappable.dart';
import '../screens/swappable_screen.dart';

class SwapSwappableCard extends StatelessWidget {
  const SwapSwappableCard({
    Key? key,
    required this.swappable,
  }) : super(key: key);
  final Swappable swappable;

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return SizedBox(
      child: Container(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(SwappableScreen.routeName, arguments: swappable);
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
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                          )
                        ),
                        height: MediaQuery.of(context).size.height * .18,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * .1,
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
                          radius: MediaQuery.of(context).size.width * .03,
                          backgroundImage:
                              NetworkImage(swappable.ownerImageUrl),
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
