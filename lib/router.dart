import 'package:flutter/material.dart';

part 'app_router.gr.dart';      
class App extends StatelessWidget {      
  // make sure you don't initiate your router          
  // inside of the build function.          
  final _appRouter = AppRouter();      
      
  @override      
  Widget build(BuildContext context){      
    return MaterialApp.router(      
      routerDelegate: _appRouter.delegate(),      
      routeInformationParser: _appRouter.defaultRouteParser(),      
    );      
  }      
} 