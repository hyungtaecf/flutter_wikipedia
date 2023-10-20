//Copyright 2022 Crazy Mind
///Core File for this Package

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wikipedia/src/models/search_query_model.dart';
import 'package:wikipedia/src/models/summary_data_model.dart';

///This is the base URL[_baseUrl] for the Wikipedia API.
String _baseUrl = "https://en.wikipedia.org/w/api.php";

class Wikipedia {
  /// The searchQuery is for searching any type for query.
  /// You can search anything from wikipedia by using [searchQuery].
  /// You can also set limit for this results. By default the limit is set to 1.
  Future<WikipediaResponse?> searchQuery(
      {required String searchQuery, int limit = 1}) async {
    try {
      final _responseData = await http.get(Uri.parse(
          "$_baseUrl?action=query&format=json&list=search&srlimit=$limit&srsearch=$searchQuery&origin=*"));
      return WikipediaResponse.fromJson(json.decode(_responseData.body));
    } catch (e) {
      return null;
    }
  }

  /// The searchSummaryWithPageId is for searching page with the help for page id.
  /// You can get page data by providing the page id. Page Id is required.
  Future<WikipediaSummaryData?> searchSummaryWithPageId(
      {required int pageId}) async {
    try {
      final _responseData = await http.get(Uri.parse(
          "$_baseUrl?action=query&format=json&pageids=$pageId&prop=extracts|description&origin=*"));
      return WikipediaSummaryData.fromJson(
          json.decode(_responseData.body)["query"]["pages"]["$pageId"]);
    } catch (e) {
      return null;
    }
  }
}
