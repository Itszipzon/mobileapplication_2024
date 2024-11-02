import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Jan extends ConsumerWidget {
  const Jan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider.notifier);
    return(InkWell(
      onTap: () => router.setPath(context, "test?id=1",values: {"id": 2}),
      child: const Text("Log in"),
    )
    );
  } 
}