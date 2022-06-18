import 'package:flutter/material.dart';
import 'package:swapsta/widgets/swap_swappable_card.dart';
import '../../globals.dart' as globals;
import '../models/swap.dart';
import '../models/swappable.dart';

class SwapHistory extends StatelessWidget {
  const SwapHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Swap swap = globals.sentSwaps[0];
    return Wrap(children: [
      Stack(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          // currently creating swappables on the go, will give id and fetch it on swappable screen later.
                          child: SwapSwappableCard(
                            swappable: Swappable(
                              id: '1',
                              name: 'Swappable 1',
                              imageUrls: ['https://picsum.photos/200/300'],
                              description: 'This is a swappable',
                              category: "Clothing",
                              categoryEmoji: '👕',
                              condition: 3.5,
                              createdAt: DateTime.now(),
                              ownerId: "7",
                              ownerName: "John Doe",
                              ownerImageUrl: "https://picsum.photos/400/300",
                              updatedAt: DateTime.now(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          // currently creating swappables on the go, will give id and fetch it on swappable screen later.
                          child: SwapSwappableCard(
                            swappable: Swappable(
                              id: '1',
                              name: 'Swappable 1',
                              imageUrls: ['https://picsum.photos/400/300'],
                              description: 'This is a swappable',
                              category: "Clothing",
                              categoryEmoji: '👕',
                              condition: 3.5,
                              createdAt: DateTime.now(),
                              ownerId: "7",
                              ownerName: "John Doe",
                              ownerImageUrl: "https://picsum.photos/200/300",
                              updatedAt: DateTime.now(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      ' Swapped 19th June 2022',
                      style: TextStyle(color: Colors.orange),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Image.asset(
              'assets/img/done.png',
              height: 35,
            ),
          )
        ],
      ),
    ]);
  }
}
