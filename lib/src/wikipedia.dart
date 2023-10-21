//Copyright 2022 Crazy Mind
///Core File for this Package

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wikipedia/src/models/search_query_model.dart';
import 'package:wikipedia/src/models/summary_data_model.dart';

export 'package:wikipedia/src/models/search_query_model.dart';
export 'package:wikipedia/src/models/summary_data_model.dart';
export 'package:wikipedia/src/models/thumbnail.dart';

///This is the base URL[_baseUrl] for the Wikipedia API.
String _baseUrl = "https://en.wikipedia.org/w/api.php";

class Wikipedia {
  /// The searchQuery is for searching any type for query.
  /// You can search anything from wikipedia by using [searchQuery].
  /// You can also set limit for this results. By default the limit is set to 1.
  Future<WikipediaResponse?> searchQuery(
      {required String searchQuery, int limit = 1}) async {
    try {
      final responseData = await http.get(Uri.parse(
          "$_baseUrl?action=query&format=json&list=search&srlimit=$limit&srsearch=$searchQuery&origin=*"));
      return WikipediaResponse.fromJson(json.decode(responseData.body));
    } catch (e, stack) {
      debugPrint("$e $stack");
      return null;
    }
  }

  Future<List<WikipediaSummaryData>?> getRandomPages({int limit = 1}) async {
    try {
      final responseData = await http.get(Uri.parse(
          "$_baseUrl?action=query&format=json&generator=random&grnnamespace=0&prop=pageimages|extracts|description&grnlimit=$limit"));

      final pages = Map<String, dynamic>.from(
          json.decode(responseData.body)["query"]["pages"]);
      final result = pages.values.map<WikipediaSummaryData>((e) {
        return WikipediaSummaryData.fromJson(e as Map<String, dynamic>);
      }).toList();
      return result;
    } catch (e, stack) {
      debugPrint("$e $stack");
      return null;
    }
  }

  /// The searchSummaryWithPageId is for searching page with the help for page id.
  /// You can get page data by providing the page id. Page Id is required.
  Future<WikipediaSummaryData?> searchSummaryWithPageId(
      {required int pageId}) async {
    try {
      final responseData = await http.get(Uri.parse(
          "$_baseUrl?action=query&format=json&pageids=$pageId&prop=pageimages|extracts|description&origin=*"));
      return WikipediaSummaryData.fromJson(
          json.decode(responseData.body)["query"]["pages"]["$pageId"]);
    } catch (e) {
      return null;
    }
  }
}
