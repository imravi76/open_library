import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_library/widget/book_item.dart';
import 'model/docs.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Docs> _searchResults = [];
  bool _isLoading = false;

  List<bool> _isReadStatus = [];

  Future<void> _searchBooks(String query) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http
        .get(Uri.parse('https://openlibrary.org/search.json?title=$query'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> docs = data['docs'];

      List<Docs> results =
          docs.take(50).map((doc) => Docs.fromJson(doc)).toList();

      setState(() {
        _searchResults = results;
        _isLoading = false;
        _isReadStatus = List<bool>.filled(results.length, false);
      });
    } else {
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search Books',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            String query = _searchController.text.trim();
            if (query.isNotEmpty) {
              _searchBooks(query);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              String query = _searchController.text.trim();
              if (query.isNotEmpty) {
                _searchBooks(query);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return BookItem(
                      doc: _searchResults[index],
                      isRead: _isReadStatus[index],
                      onReadStatusChanged: (bool isRead) {
                        setState(() {
                          _isReadStatus[index] = isRead;
                        });
                      },
                    );
                  },
                ),
    );
  }
}
