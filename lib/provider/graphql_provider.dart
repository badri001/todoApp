import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final Link link =
    HttpLink("https://demotivation-quotes-api.herokuapp.com/graphql");

ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
    cache: GraphQLCache(),
    link: link,
    alwaysRebroadcast: true,
    defaultPolicies: DefaultPolicies()));
