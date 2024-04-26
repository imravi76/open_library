import 'package:flutter/material.dart';

import '../model/docs.dart';
import '../model/reading_log_entries.dart';

class BookItem extends StatelessWidget {
  final ReadingLogEntries? readingLogEntries;
  final Docs? doc;
  final bool isRead;
  final ValueChanged<bool> onReadStatusChanged;

  const BookItem({
    super.key,
    this.readingLogEntries,
    this.doc,
    required this.isRead,
    required this.onReadStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 80,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                readingLogEntries != null
                    ? 'https://covers.openlibrary.org/b/id/${readingLogEntries?.work!.coverId}-M.jpg'
                    : 'https://covers.openlibrary.org/b/id/${doc!.coverI}-M.jpg',
              ),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        title: Text(
          readingLogEntries != null
              ? readingLogEntries?.work!.title ?? 'Unknown'
              : doc!.title ?? 'Unknown',
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              readingLogEntries != null
                  ? '${readingLogEntries?.work!.authorNames?.join(", ") ?? 'Unknown'} - ${readingLogEntries?.work!.firstPublishYear ?? 'Unknown'}'
                  : '${doc!.authorName?.join(", ") ?? 'Unknown'} - ${doc!.firstPublishYear ?? 'Unknown'}',
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            onReadStatusChanged(!isRead);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: isRead ? Colors.white : null,
            backgroundColor: isRead ? Colors.green : null,
            side: const BorderSide(color: Colors.grey),
          ),
          child: Text(isRead ? 'Read' : 'Unread'),
        ),
      ),
    );
  }
}
