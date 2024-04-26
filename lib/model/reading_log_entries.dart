import 'package:open_library/model/work.dart';

class ReadingLogEntries {
  Work? work;
  String? loggedEdition;
  String? loggedDate;

  ReadingLogEntries({this.work, this.loggedEdition, this.loggedDate});

  ReadingLogEntries.fromJson(Map<String, dynamic> json) {
    work = json['work'] != null ? Work.fromJson(json['work']) : null;
    loggedEdition = json['logged_edition'];
    loggedDate = json['logged_date'];
  }
}
