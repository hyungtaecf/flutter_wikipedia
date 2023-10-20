//Copyright 2022 Crazy Mind
///This is the model for the Summary Data [WikipediaSummaryData]

import 'package:wikipedia/src/utils/parse_html.dart';

class WikipediaSummaryData {
  int? pageid; ///Page Id of Result
  int? ns; ///NS
  String? title; ///Title of Result
  String? extract; ///Extract of Result
  String? description; ///Description of Result
  String? descriptionsource; ///Description Source of Result

  WikipediaSummaryData(
      {this.pageid,
      this.ns,
      this.title,
      this.extract,
      this.description,
      this.descriptionsource});

  WikipediaSummaryData.fromJson(Map<String, dynamic> json) {
    pageid = json['pageid'];
    ns = json['ns'];
    title = json['title'];
    extract = ParserHtml().parserHtml(json['extract']);
    description = ParserHtml().parserHtml(json['description']);
    descriptionsource = json['descriptionsource'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageid'] = pageid;
    data['ns'] = ns;
    data['title'] = title;
    data['extract'] = extract;
    data['description'] = description;
    data['descriptionsource'] = descriptionsource;
    return data;
  }
}
