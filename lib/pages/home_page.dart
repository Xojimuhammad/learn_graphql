import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/GraphQlConfig.dart';
import '../graphql/QueryMutation.dart';
import '../models/user_model.dart';
import 'create_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  List<User> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiUserList();
  }

  void apiUserList() async {
    QueryMutation queryMutation = QueryMutation();
    GraphQLClient client = graphQLConfiguration.clientToQuery();
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(queryMutation.userList(20)),
      ),
    );
    if (!result.hasException) {
      for (var i = 0; i < result.data!["users"].length; i++) {
        setState(() {
          users.add(User(
            result.data!["users"][i]["id"] ?? "",
            result.data!["users"][i]["name"] ?? "no name",
            result.data!["users"][i]["rocket"] ?? "no rocket",
            result.data!["users"][i]["twitter"] ?? "no twitter",
          ));
        });
      }
      print(users.length.toString());
    } else {
      print("Error: ${result.toString()}");
    }
  }

  _insertUser(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        CreatePage createPage = const CreatePage();
        return createPage;
      },
    ).whenComplete(() {
      users.clear();
      apiUserList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GraphQL"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              _insertUser(context);
            },
            tooltip: "Insert User",
          )
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];

          return Card(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name),
                  Text(user.rocket),
                  Text(user.twitter)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}