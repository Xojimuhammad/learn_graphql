import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:learn_graphql/pages/home_page.dart';
import 'package:learn_graphql/pages/message_page.dart';
import 'graphql/GraphQlConfig.dart';


GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GraphQLProvider(
      client: graphQLConfiguration.client,
      child: const CacheProvider(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MessagePage(),
    );
  }
}