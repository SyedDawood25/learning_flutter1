import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StartUp Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 36, 35, 35),
          foregroundColor: Color.fromARGB(255, 209, 204, 204),
        ),
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  final _wordSuggestions = <WordPair>[];
  final _favorites = <WordPair>{};
  final _style = const TextStyle(color: Color.fromARGB(255, 36, 35, 35), fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StartUp Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Favorite Suggestions',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemBuilder: (context, index) {
          if(index.isOdd) return const Divider();
    
          final i = index ~/ 2;
          if(i >= _wordSuggestions.length) {
            _wordSuggestions.addAll(generateWordPairs().take(10));
          }
    
          final alreadySaved = _favorites.contains(_wordSuggestions[i]);
    
          return ListTile(
            title: Text(
              _wordSuggestions[i].asPascalCase,
              style: _style,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from Favorites' : 'Add to Favorites'
            ),
            onTap: () {
              setState(() {
                if(alreadySaved) {
                  _favorites.remove(_wordSuggestions[i]);
                }
                else {
                  _favorites.add(_wordSuggestions[i]);
                }
              });
            },
          );
        }
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = _favorites.map((e) {
            return ListTile(
              title: Text(
                e.asPascalCase,
                style: _style,
              ),
            );
          });
          final divided = tiles.isNotEmpty ?
            ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList() : <Widget>[];
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Favorites'),
            ),
            body: ListView(
              children: divided,
            ),
          );
        },
      )
    );
  }
}