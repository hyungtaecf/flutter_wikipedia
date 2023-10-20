//Copyright 2022 Crazy Mind
///This is the model for the Wikipedia Response Data [WikipediaResponse]

import 'package:wikipedia/src/utils/parse_html.dart';

class WikipediaResponse {
  Query? query; ///Query Result

  WikipediaResponse({this.query});

  WikipediaResponse.fromJson(Map<String, dynamic> json) {
    query = json['query'] != null ? Query.fromJson(json['query']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (query != null) {
      data['query'] = query!.toJson();
    }
    return data;
  }
}

class Query {
  List<WikipediaSearch>? search;

  Query({this.search});

  Query.fromJson(Map<String, dynamic> json) {
    if (json['search'] != null) {
      search = <WikipediaSearch>[];
      json['search'].forEach((v) {
        search!.add(WikipediaSearch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (search != null) {
      data['search'] = search!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WikipediaSearch {
  int? ns;
  String? title; ///Title of Result
  int? pageid; ///Page Id of Single Result
  int? size; ///Size of Result
  int? wordcount; ///Word Count
  String? snippet; ///Snippet
  String? timestamp; ///Timestamp

  WikipediaSearch(
      {this.ns,
      this.title,
      this.pageid,
      this.size,
      this.wordcount,
      this.snippet,
      this.timestamp});

  WikipediaSearch.fromJson(Map<String, dynamic> json) {
    ns = json['ns'];
    title = json['title'];
    pageid = json['pageid'];
    size = json['size'];
    wordcount = json['wordcount'];
    snippet = ParserHtml().parserHtml(json['snippet']);
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ns'] = ns;
    data['title'] = title;
    data['pageid'] = pageid;
    data['size'] = size;
    data['wordcount'] = wordcount;
    data['snippet'] = snippet;
    data['timestamp'] = timestamp;
    return data;
  }
}
