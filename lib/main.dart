import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_library/search_page.dart';
import 'package:open_library/widget/book_item.dart';
import 'model/reading_log_entries.dart';

void main() {
  runApp(const BookLibraryApp());
}

class BookLibraryApp extends StatelessWidget {
  const BookLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Library',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<ReadingLogEntries>? _allEntries;
  List<bool> _isReadStatus = [];
  List<ReadingLogEntries> _visibleEntries = [];
  int _visibleCount = 20;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final response = await http.get(Uri.parse(
        'https://openlibrary.org/people/mekBot/books/already-read.json'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> entries = data['reading_log_entries'];
      setState(() {
        _allEntries =
            entries.map((e) => ReadingLogEntries.fromJson(e)).toList();
        _isReadStatus = List<bool>.filled(_allEntries!.length, false);
        _visibleEntries = _allEntries!.take(_visibleCount).toList();
      });
    }
  }

  void _loadMore() {
    setState(() {
      _visibleCount += 20;
      _visibleEntries = _allEntries!.take(_visibleCount).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: _visibleEntries.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  _loadMore();
                }
                return true;
              },
              child: ListView.builder(
                itemCount: _visibleEntries.length,
                itemBuilder: (context, index) {
                  return BookItem(
                    readingLogEntries: _visibleEntries[index],
                    isRead: _isReadStatus[index],
                    onReadStatusChanged: (bool isRead) {
                      setState(() {
                        _isReadStatus[index] = isRead;
                      });
                    },
                  );
                },
              ),
            ),
    );
  }
}
