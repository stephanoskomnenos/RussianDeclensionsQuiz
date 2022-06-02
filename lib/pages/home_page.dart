import 'package:flutter/material.dart';
import 'package:russian_declensions_quiz/pages/components/loading_indicator.dart';

import '../utils/load_dict.dart';
import 'adjective_page.dart';
import 'noun_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  List<List<String>>? adjectiveDict, nounDict;

  @override
  void initState() {
    super.initState();
    loadDicts();
  }

  void loadDicts() async {
    final adjectiveDictAwait = await loadDict('adjectives.csv');
    final nounDictAwait = await loadDict('nouns.csv');
    setState(() {
      adjectiveDict = adjectiveDictAwait;
      nounDict = nounDictAwait;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = adjectiveDict == null || nounDict == null
        ? const Center(child: LoadingIndicator())
        : [
            NounPage(
              nounDict: nounDict!,
            ),
            AdjectivePage(
              adjectiveDict: adjectiveDict!,
            ),
          ][currentPageIndex];

    return Scaffold(
      body: currentPage,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.book), label: 'Noun'),
          NavigationDestination(
              icon: Icon(Icons.local_offer), label: 'Adjective'),
        ],
        selectedIndex: currentPageIndex,
      ),
    );
  }
}
