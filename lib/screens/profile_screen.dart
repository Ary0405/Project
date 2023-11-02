import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String imageUrl;

  const ProfileScreen(
      {Key? key,
      required this.name,
      required this.email,
      required this.imageUrl})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * .15,
                bottom: MediaQuery.of(context).size.width * .09,
              ),
              width: double.infinity,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(25.0),
                  ),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ClipOval(
                    child: Image.network(
                      authUser.photoURL!,
                      width: 70,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    authUser.displayName!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProDisplay',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    authUser.email!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SFProDisplay',
                      color: Color(0xff898A8D),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * .04,
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'SETTINGS',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff767676),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * .04,
                      bottom: MediaQuery.of(context).size.width * .04,
                      left: MediaQuery.of(context).size.width * .05,
                      right: MediaQuery.of(context).size.width * .05,
                    ),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(25.0),
                          top: Radius.circular(25.0),
                        ),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        _buildRow(
                          'assets/images/user_icon.png',
                          'Account Settings',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRow(
                          'assets/images/notif.png',
                          'Notifications',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.all(
            //     MediaQuery.of(context).size.width * .04,
            //   ),
            // child: Column(
            //   children: [
            //     const Row(
            //       children: [
            //         Text(
            //           'SHOPPING',
            //           style: TextStyle(
            //             fontFamily: 'SFProDisplay',
            //             fontSize: 14,
            //             fontWeight: FontWeight.w400,
            //             color: Color(0xff767676),
            //           ),
            //         )
            //       ],
            //     ),
            //     const SizedBox(
            //       height: 8,
            //     ),
            //     Container(
            //       padding: EdgeInsets.only(
            //         top: MediaQuery.of(context).size.width * .04,
            //         bottom: MediaQuery.of(context).size.width * .04,
            //         left: MediaQuery.of(context).size.width * .05,
            //         right: MediaQuery.of(context).size.width * .05,
            //       ),
            //       decoration: const ShapeDecoration(
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.vertical(
            //             bottom: Radius.circular(25.0),
            //             top: Radius.circular(25.0),
            //           ),
            //         ),
            //         color: Colors.white,
            //       ),
            //       child: Column(
            //         children: [
            //           _buildRow(
            //             'assets/images/bag.png',
            //             'Your Orders',
            //           ),
            //           const SizedBox(
            //             height: 20,
            //           ),
            //           _buildRow(
            //             'assets/images/address.png',
            //             'Address Book',
            //           ),
            //           const SizedBox(
            //             height: 20,
            //           ),
            //           _buildRow(
            //             'assets/images/shop.png',
            //             'Store Locating Help',
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // ),
            Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * .04,
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'MORE',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff767676),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * .04,
                      bottom: MediaQuery.of(context).size.width * .04,
                      left: MediaQuery.of(context).size.width * .05,
                      right: MediaQuery.of(context).size.width * .05,
                    ),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(25.0),
                          top: Radius.circular(25.0),
                        ),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        _buildRow(
                          'assets/images/info.png',
                          'About',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRow(
                          'assets/images/link.png',
                          'Send feedback',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRow(
                          'assets/images/alert-triangle.png',
                          'Report a safety emergency',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRow(
                          'assets/images/log_out.png',
                          'Logout',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .16,
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildRow(String imagePath, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          ClipOval(
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xffF2F4F7),
              ),
              child: Image.asset(
                imagePath,
                width: 20,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'SFProDisplay',
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
      Image.asset(
        'assets/images/right_arrow.png',
        width: 8,
      ),
    ],
  );
}
