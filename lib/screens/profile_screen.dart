import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen();

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                    child: Image.asset(
                      'assets/images/user.png',
                      width: 70,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Rakesh Umashankar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProDisplay',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const Text(
                    'rakeshUmashankar@gmail.com',
                    style: TextStyle(
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
                  Row(
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
                  SizedBox(
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
                          'assets/images/acc.png',
                          'Account Settings',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRow(
                          'assets/images/notif.png',
                          'Notification Settings',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRow(
                          'assets/images/lang.png',
                          'Change Langauge',
                        ),
                      ],
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
                          'assets/images/about.png',
                          'About',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRow(
                          'assets/images/feed.png',
                          'Send Feedback',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRow(
                          'assets/images/report.png',
                          'Report a safety emergency',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRow(
                          'assets/images/logout.png',
                          'Log out',
                        ),
                      ],
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

Widget _buildRow(String imagePath, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          ClipOval(
            child: Container(
              // padding: const EdgeInsets.all(6),
              width: 25,
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