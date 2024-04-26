class Work {
  String? title;
  List<String>? authorNames;
  int? firstPublishYear;
  int? coverId;

  Work({this.title, this.authorNames, this.firstPublishYear, this.coverId});

  Work.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    authorNames = json['author_names']?.cast<String>();
    firstPublishYear = json['first_publish_year'];
    coverId = json['cover_id'];
  }
}
