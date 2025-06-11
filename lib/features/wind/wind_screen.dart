import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wind_provider.dart';

class WindScreen extends ConsumerWidget {
  const WindScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final windAsync = ref.watch(windDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("SailIQWind")),
      body: Center(
        child: windAsync.when(
          data: (windData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("AWS: ${windData.aws.toStringAsFixed(1)} knots"),
                Text("AWA: ${windData.awa.toStringAsFixed(1)}°"),
                Text("TWS: ${windData.tws.toStringAsFixed(1)} knots"),
                Text("TWA: ${windData.twa.toStringAsFixed(1)}°"),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text("Error: $err"),
        ),
      ),
    );
  }
}