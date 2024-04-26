class Docs {
  List<String>? authorName;
  int? coverI;
  int? firstPublishYear;
  String? title;

  Docs({
    this.authorName,
    this.coverI,
    this.firstPublishYear,
    this.title,
  });

  Docs.fromJson(Map<String, dynamic> json) {
    authorName = json['author_name'].cast<String>();
    coverI = json['cover_i'];
    firstPublishYear = json['first_publish_year'];
    title = json['title'];
  }
}
