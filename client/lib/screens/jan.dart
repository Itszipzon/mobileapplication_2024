import 'package:client/tools/router_provider.dart';
import 'package:flutter/material.dart';

class Jan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = RouterProvider.of(context);
    return(InkWell(
      onTap: () => router.setPath(context, "test?id=1",values: {"id": 2}),
      child: const Text("Log in"),
    )
    );
  } 
}