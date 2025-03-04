import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:swapsta/models/swap.dart';
import 'package:swapsta/models/swappable.dart';
import 'package:swapsta/providers/bottom_nav_visibility_provider.dart';
import 'package:swapsta/widgets/swap_swappable_row.dart';

class recievedswapslist extends StatefulWidget {
  final String searchQuery;
  final TabController tabSwitcher;

  const recievedswapslist(
      {Key? key, required this.searchQuery, required this.tabSwitcher})
      : super(key: key);

  @override
  State<recievedswapslist> createState() => _recievedswapslistState();
}

class _recievedswapslistState extends State<recievedswapslist> {
  final authUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    Future<void> updateSwapData(String item_id, Swap item) async {
      final firestore = FirebaseFirestore.instance;
      final swapDocument = firestore.collection('swaps').doc(item_id);
      final ownerItemDocument =
          firestore.collection('items').doc(item.ownerItemId);
      final requesterItemDocument =
          firestore.collection('items').doc(item.requesterItemId);
      try {
        await swapDocument.update({
          'status': 'swapped',
          'createdAt': DateTime.now().toIso8601String(),
        });
        await ownerItemDocument.update({
          'swapped': true,
        });
        await requesterItemDocument.update({
          'swapped': true,
        });
      } on Exception catch (e) {
        print(e);
      }
    }

    Future<void> rejectSwap(String item_id, Swap item) async {
      final firestore = FirebaseFirestore.instance;
      final swapDocument = firestore.collection('swaps').doc(item_id);
      final ownerItemDocument =
          firestore.collection('items').doc(item.ownerItemId);
      final requesterItemDocument =
          firestore.collection('items').doc(item.requesterItemId);
      try {
        await ownerItemDocument.update({
          'swapRequests': FieldValue.increment(-1),
        });
        await requesterItemDocument.update({
          'swapRequests': FieldValue.increment(-1),
        });
        await swapDocument.delete();
      } on Exception catch (e) {
        print(e);
      }
    }

    final ScrollController scrollController = ScrollController();

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('swaps').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final data = snapshot.data?.docs;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final recievedSwaps = data?.map((item) {
            var dataTemp = item.data() as Map<dynamic, dynamic>;
            if (dataTemp['ownerId'] == authUser.email &&
                dataTemp['status'] == 'requested') {
              return Swap(
                id: dataTemp['id'],
                requesterId: dataTemp['requesterId'],
                requesterName: dataTemp['requesterName'],
                requesterImage: dataTemp['requesterImage'],
                ownerId: dataTemp['ownerId'],
                ownerName: dataTemp['ownerName'],
                ownerImage: dataTemp['ownerImage'],
                requesterItemId: dataTemp['requestItemId'],
                requesterItemName: dataTemp['requesterItemName'],
                requesterItemImages:
                    List<String>.from(dataTemp['requesterItemImages']),
                requesterItemDescription: dataTemp['requesterItemDescription'],
                requesterItemCategory: dataTemp['requesterItemCategory'],
                requesterItemCreatedAt:
                    DateTime.parse(dataTemp['requesterItemCreatedAt']),
                requesterItemUpdatedAt:
                    DateTime.parse(dataTemp['requesterItemUpdatedAt']),
                requesterItemCondition:
                    dataTemp['requesterItemCondition'].toDouble(),
                ownerItemId: dataTemp['ownerItemId'],
                ownerItemName: dataTemp['ownerItemName'],
                ownerItemImages: List<String>.from(dataTemp['ownerItemImages']),
                ownerItemDescription: dataTemp['ownerItemDescription'],
                ownerItemCategory: dataTemp['ownerItemCategory'],
                ownerItemCreatedAt:
                    DateTime.parse(dataTemp['ownerItemCreatedAt']),
                ownerItemUpdatedAt:
                    DateTime.parse(dataTemp['ownerItemUpdatedAt']),
                ownerItemCondition: dataTemp['ownerItemCondition'].toDouble(),
                isAccepted: dataTemp['status'] == 'requested' ? false : true,
              );
            } else {
              return [];
            }
          }).toList();
          final _recSwaps = recievedSwaps?.whereType<Swap>().toList();
          final keywordIncludedSwaps = _recSwaps
              ?.where((sentSwap) =>
                  sentSwap.ownerName
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()) ||
                  sentSwap.requesterName
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()))
              .toList();
          return Consumer<BottomBarVisibilityProvider>(
            builder: (context, bottomBarVisibilityProvider, child) {
              scrollController.addListener(() {
                final direction = scrollController.position.userScrollDirection;

                if (direction == ScrollDirection.forward) {
                  if (!bottomBarVisibilityProvider.isVisible) {
                    bottomBarVisibilityProvider.show();
                  }
                } else if (direction == ScrollDirection.reverse) {
                  if (bottomBarVisibilityProvider.isVisible) {
                    bottomBarVisibilityProvider.hide();
                  }
                }
              });
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10.0),
                itemCount: keywordIncludedSwaps?.length,
                controller: scrollController,
                itemBuilder: (ctx, i) {
                  return Wrap(
                    children: [
                      Stack(
                        children: [
                          Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            shadowColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  SwapSwappableRow(
                                      swap: keywordIncludedSwaps?[i]),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            color: Colors
                                                .red, // Set the background color to red
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                splashRadius: 24,
                                                onPressed: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            'Are you Sure?',
                                                          ),
                                                          content: Text(
                                                            'Are you sure you want to reject swap request from ${keywordIncludedSwaps?[i].ownerName}',
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        false, // Prevent dismissing the dialog by tapping outside
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            CircularProgressIndicator(), // Show the circular progress indicator
                                                                            SizedBox(
                                                                              height: 16,
                                                                            ),
                                                                            Text(
                                                                              "Please wait...",
                                                                            ), // Optional: Add a message
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                  await rejectSwap(
                                                                    keywordIncludedSwaps![
                                                                            i]
                                                                        .id,
                                                                    keywordIncludedSwaps[
                                                                        i],
                                                                  );
                                                                  final swappableProvider =
                                                                      Provider.of<
                                                                          SwappableProvider>(
                                                                    context,
                                                                    listen:
                                                                        false,
                                                                  );
                                                                  await swappableProvider
                                                                      .fetchSwappables();
                                                                  await swappableProvider
                                                                      .fetchSwaps();
                                                                } on Exception catch (e) {
                                                                  print(e);
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                                Navigator
                                                                    .pushNamed(
                                                                  context,
                                                                  '/home',
                                                                );
                                                              },
                                                              child: const Text(
                                                                'OK',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: const Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 20),
                                                splashColor: Colors.red[400],
                                                highlightColor:
                                                    Colors.transparent,
                                              ),
                                              // Text(
                                              //   'Deny',
                                              //   style: TextStyle(
                                              //     fontSize: 15,
                                              //     color: Colors.white,
                                              //     fontWeight: FontWeight
                                              //         .w500, // Font color for the tab text
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            color: Colors
                                                .black, // Set the background color to red
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            'Contact Info',
                                                          ),
                                                          content: Text(
                                                              'Contact ${keywordIncludedSwaps?[i].requesterName} at ${keywordIncludedSwaps?[i].requesterId}'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'OK'),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: const Icon(Icons.contacts,
                                                    color: Colors.white,
                                                    size: 20),
                                                splashRadius: 24,
                                                splashColor: Colors.black,
                                                highlightColor:
                                                    Colors.transparent,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            color: Colors
                                                .green, // Set the background color to red
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext ctx) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Are you Sure?'),
                                                          content: Text(
                                                              'Are you sure you want to accept swap request from ${keywordIncludedSwaps?[i].requesterName}'),
                                                          actions: [
                                                            TextButton(
                                                              child: const Text(
                                                                  'OK'),
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        false, // Prevent dismissing the dialog by tapping outside
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            CircularProgressIndicator(), // Show the circular progress indicator
                                                                            SizedBox(
                                                                              height: 16,
                                                                            ),
                                                                            Text(
                                                                              "Please wait...",
                                                                            ), // Optional: Add a message
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                  await updateSwapData(
                                                                    keywordIncludedSwaps![
                                                                            i]
                                                                        .id,
                                                                    keywordIncludedSwaps[
                                                                        i],
                                                                  );
                                                                  final swappableProvider =
                                                                      Provider.of<
                                                                          SwappableProvider>(
                                                                    context,
                                                                    listen:
                                                                        false,
                                                                  );
                                                                  await swappableProvider
                                                                      .fetchSwappables();
                                                                  await swappableProvider
                                                                      .fetchSwaps();
                                                                } on Exception catch (e) {
                                                                  print(e);
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator
                                                                    .pushNamed(
                                                                  context,
                                                                  '/home',
                                                                );
                                                                // Navigator.of(ctx).pop();
                                                                // widget.tabSwitcher
                                                                //     .animateTo(2);
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: const Icon(Icons.check,
                                                    color: Colors.white,
                                                    size: 20),
                                                splashRadius: 24,
                                                splashColor: Colors.green[400],
                                                highlightColor:
                                                    Colors.transparent,
                                              ),
                                              // Text(
                                              //   'Accept',
                                              //   style: TextStyle(
                                              //       fontSize: 15,
                                              //       color: Colors.white,
                                              //       fontWeight: FontWeight
                                              //           .w500 // Font color for the tab text
                                              //       ),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * .37,
                              MediaQuery.of(context).size.height * .12,
                              0,
                              0,
                            ),
                            child: Image.asset(
                              'assets/img/swap_arrow_new.png',
                              height: 80,
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          );
        });
  }
}
