import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key, required this.handleSearch}) : super(key: key);

  final Function(String) handleSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 24,
            color: Colors.orange[700],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (query) {
                handleSearch(query);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'What are you looking for?',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
