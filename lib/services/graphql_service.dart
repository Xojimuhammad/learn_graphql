import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  // Basic configuration
  static const _baseUrl = 'https://flutter-b17.hasura.app/v1/graphql';
  static const _socketUrl = 'wss://flutter-b17.hasura.app/v1/graphql';

  static const _headers = {
    "x-hasura-admin-secret": "WHvUwDlVnAeBgpNdz3Sg66DMixAGbICCpJU4q1lQzRfNqx6IEU9RC1IDLLliEwdW",
    "content-type": "application/json"
  };

  static final HttpLink _httpLink = HttpLink(_baseUrl, defaultHeaders: _headers);

  static final WebSocketLink _socketLink = WebSocketLink(_socketUrl, config: const SocketClientConfig(
    autoReconnect: true,
    inactivityTimeout: Duration(seconds: 30),
    headers: _headers,
  ));

  static final Link _link = _httpLink.concat(_socketLink);

  static GraphQLClient get client => GraphQLClient(cache: GraphQLCache(), link: _link);

  static ValueNotifier<GraphQLClient> notifierClient = ValueNotifier(client);

  // Method: query, mutation, subscription
  // GET
  static Future<Map<String, dynamic>?> QUERY(String query, Map<String, dynamic> variable) async {
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: variable,
      ),
    );

    print(result.toString());
    if(!result.hasException) {
      return result.data;
    } else {
      return null;
    }
  }

  // POST, PUT, PATCH, DELETE
  static Future<bool> MUTATION(String mutation, Map<String, dynamic> variable) async {
    QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: variable,
      ),
    );

    if(!result.hasException) {
      return true;
    } else {
      return false;
    }
  }

  // WEB SOCKET
  static Stream<Map<String, dynamic>?> SUBSCRIPTION(String subscription, Map<String, dynamic> variable) {
    Stream<Map<String, dynamic>?> result = client.subscribe(SubscriptionOptions(
      document: gql(subscription),
      variables: variable,
    )).transform(StreamTransformer<QueryResult, Map<String, dynamic>?>.fromHandlers(
        handleData: (queryResult, sink) {
          print("queryResult: $queryResult");
          if(!queryResult.hasException) {
            sink.add(queryResult.data);
          }
        }
    ));

    return result;
  }

  // Query
  static String queryMessages() {
    return """
query{
    messages(order_by: {created_at: asc}) {
        id
        username
        message
    }
}
  """;
  }

  // Mutation
  static String mutationMessage() {
    return """
mutation createMessage(\$username: String!, \$message: String!) {
  insert_messages_one(object: {username: \$username, message: \$message}) {
    id,
    username,
    message,
    created_at
  }
}
    """;
  }

  // Subscription
  static String subscriptionMessage() {
    return """
subscription {
  messages {
    id,
    username,
    message
  }
}
    """;
  }

  // Variables
  static Map<String, dynamic> get variableEmpty => {};

  static Map<String, dynamic> variableInsertMessage(String username, String message) {
    return {
      "username": username,
      "message": message,
    };
  }
}