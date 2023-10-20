# Wikipedia Search Tool

A new wikipedia search tool written in dart language, search anything with this tool. You can also get full page data with page id.

## Example View
![alt text](https://firebasestorage.googleapis.com/v0/b/last-2be53.appspot.com/o/1.png?alt=media&token=e654af70-3706-4efe-baa0-10be1bb5da5f)
![Demo Video](https://firebasestorage.googleapis.com/v0/b/last-2be53.appspot.com/o/0Video.gif?alt=media&token=6c78dcd5-30ba-4538-afa2-7b0c0f051822)

## Features

- Search by title
- Serach full page data by page id

## Usage

```dart
try{
    Wikipedia instance = Wikipedia();
    var result = await instance.searchQuery(searchQuery: "What is flutter?",limit: 1);
    for(int i=0; i<result!.query!.search!.length; i++){
    print(result.query!.search![i].snippet);
    if(!(result.query!.search![i].pageid==null)){
      var resultDescription = await instance.searchSummaryWithPageId(pageId: result.query!.search![i].pageid!);
      print(resultDescription!.title);
      print(resultDescription.description);
    }
  }
}catch(e){
  print(e);
}
```

## Full Example
```dart
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
  List<WikipediaSearch> _data = [];

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
              suffixIcon: InkWell(
                child: const Icon(Icons.search,color: Colors.black),
                onTap: (){
                  getLandingData();
                },
              )
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: _data.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) => InkWell(
              onTap: ()async{
                Wikipedia instance = Wikipedia();
                setState(() {
                  _loading = true;
                });
                var pageData = await instance.searchSummaryWithPageId(pageId: _data[index].pageid!);
                setState(() {
                  _loading = false;
                });
                if(pageData==null){
                  const snackBar = SnackBar(
                    content: Text('Data Not Found'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }else{
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
                      appBar: AppBar(
                        title: Text(_data[index].title!,style: const TextStyle(color: Colors.black)),
                        backgroundColor: Colors.white,
                        iconTheme: const IconThemeData(color: Colors.black),
                      ),
                      body: ListView(
                        padding: const EdgeInsets.all(10),
                        children: [
                          Text(pageData!.title!,style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                          const SizedBox(height: 8),
                          Text(pageData.description!,style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),),
                          const SizedBox(height: 8),
                          Text(pageData.extract!)
                        ],
                      ),
                    ),
                  );
                }
              },
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
                      Text(_data[index].title!,style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      const SizedBox(height: 10),
                      Text(_data[index].snippet!),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _loading,
            child: Container(
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

  Future getLandingData()async{
    try{
      setState((){
        _loading = true;
      });
      Wikipedia instance = Wikipedia();
      var result = await instance.searchQuery(searchQuery: _controller.text,limit: 10);
      setState((){
        _loading = false;
        _data = result!.query!.search!;
      });
    }catch(e){
      print(e);
      setState((){
        _loading = false;
      });
    }
  }
}

```

## License

MIT