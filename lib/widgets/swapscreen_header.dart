import 'package:flutter/material.dart';

class SwapscreenHeader extends StatelessWidget {
  const SwapscreenHeader({Key? key, required this.handleSearch})
      : super(key: key);
  final Function(String) handleSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 20, top: 40),
      child: const Text(
        'Swaps',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
