//Copyright 2022 Crazy Mind
///This is the model for the Summary Data [WikipediaSummaryData]

import 'package:wikipedia/src/models/thumbnail.dart';
import 'package:wikipedia/src/utils/parse_html.dart';

class WikipediaSummaryData {
  ///Page Id of Result
  int? pageid;

  ///NS
  int? ns;

  ///Title of Result
  String? title;

  ///Extract of Result
  String? extract;

  ///Description of Result
  String? description;

  ///Description Source of Result
  String? descriptionsource;

  Thumbnail? thumbnail;

  WikipediaSummaryData({
    this.pageid,
    this.ns,
    this.title,
    this.extract,
    this.description,
    this.descriptionsource,
    this.thumbnail,
  });

  WikipediaSummaryData.fromJson(Map<String, dynamic> json) {
    pageid = json['pageid'];
    ns = json['ns'];
    title = json['title'];
    extract = ParserHtml().parserHtml(json['extract']);
    description = ParserHtml().parserHtml(json['description']);
    descriptionsource = json['descriptionsource'];
    final thumbnail_ = json["thumbnail"];
    if (thumbnail_ != null) thumbnail = Thumbnail.fromJson(json["thumbnail"]);
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
