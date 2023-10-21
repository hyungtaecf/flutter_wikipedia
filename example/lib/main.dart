import 'package:flutter/material.dart';
import 'package:wikipedia/wikipedia.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wikipedia Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;

  bool _loading = false;
  List<WikipediaSearch> _searchData = [];
  List<WikipediaSummaryData> _pageDataList = [];

  @override
  void initState() {
    _controller = TextEditingController(text: "What is Flutter");
    getLandingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
              hintText: "Search...",
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.casino, color: Colors.black),
                    onPressed: () {
                      getLandingData(random: true);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () {
                      getLandingData();
                    },
                  ),
                ],
              )),
        ),
      ),
      body: Stack(
        children: [
          _buildSearchResult(),
          Visibility(
            visible: _loading,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }

  ListView _buildSearchResult() {
    if (_searchData.isEmpty) return _buildPageDataList();
    return _buildSearchData();
  }

  ListView _buildSearchData() {
    return ListView.builder(
      itemCount: _searchData.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) => InkWell(
        onTap: () => _onTapSearchData(context, index),
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  _searchData[index].title!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(_searchData[index].snippet!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView _buildPageDataList() {
    return ListView.builder(
      itemCount: _pageDataList.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) => InkWell(
        onTap: () => _onTapPageDataList(context, index),
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  _pageDataList[index].title!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(_pageDataList[index].description ??
                    _pageDataList[index].extract ??
                    ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getLandingData({bool random = false}) async {
    try {
      setState(() {
        _loading = true;
      });
      Wikipedia instance = Wikipedia();
      if (random) {
        var result = await instance.getRandomPages(limit: 10);
        setState(() {
          _loading = false;
          if (result != null) {
            _pageDataList = result;
            _controller.clear();
            _searchData.clear();
          }
        });
      } else {
        var result = await instance.searchQuery(
            searchQuery: _controller.text, limit: 10);
        setState(() {
          _loading = false;
          final data = result?.query?.search;
          if (data != null) {
            _searchData = data;
            _pageDataList.clear();
          }
        });
      }
    } catch (e, stack) {
      debugPrint("$e $stack");
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _onTapSearchData(BuildContext context, int index) async {
    Wikipedia instance = Wikipedia();
    setState(() {
      _loading = true;
    });
    var pageData = await instance.searchSummaryWithPageId(
        pageId: _searchData[index].pageid!);
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
    if (pageData == null) {
      const snackBar = SnackBar(
        content: Text('Data Not Found'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailPage(pageData: pageData),
      );
    }
  }

  _onTapPageDataList(BuildContext context, int index) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) =>
          DetailPage(pageData: _pageDataList[index]),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.pageData,
  });

  final WikipediaSummaryData pageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(pageData.title!, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      pageData.title!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pageData.description ?? '',
                      style: const TextStyle(
                          color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              if (pageData.thumbnail != null)
                Image.network(pageData.thumbnail!.source),
            ],
          ),
          const SizedBox(height: 8),
          Text(pageData.extract ?? '')
        ],
      ),
    );
  }
}
