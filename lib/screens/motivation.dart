import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:scratcher/widgets.dart';
import 'package:todo/constants.dart';

import '../widgets/custom_snack_bar.dart';

class MotivationScreen extends StatelessWidget {
  const MotivationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("May contain Sarcasm"),
        ),
        body: const Quotes());
  }
}

class Quotes extends StatelessWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(r'''query {
  randomQuote {
    quote
    author
  }
} '''),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        // print(result);
        // print(result.data?["randomQuote"]["quote"].toString());
        if (result.hasException) {
          return Text(result.exception.toString());
        }
        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        } else {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Scratcher(
                brushSize: 80,
                threshold: 18,
                color: Colors.amber,
                onChange: (value) {
                  if (value > 80) {
                    value = 100;
                  }
                },
                onThreshold: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      MySnackBar.createSnackBar(
                          bgColor: Colors.redAccent,
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          text:
                              "Go back and complete your ToDO list , This may hurt you !!!",
                          icon: Icons.warning_amber));
                },
                child: Card(
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                result.data?["randomQuote"]["quote"].toString()
                                    as String,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 26, color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                  " - ${result.data?["randomQuote"]["author"].toString() as String}",
                                  style: const TextStyle(
                                      color: Colors.white60, fontSize: 21),
                                  textAlign: TextAlign.right),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
