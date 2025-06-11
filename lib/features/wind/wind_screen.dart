import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/permissions/permissions_service.dart';
import '../wind/wind_provider.dart';
import '../../sensors/wind/wind_model.dart';

class WindScreen extends ConsumerStatefulWidget {
  const WindScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WindScreen> createState() => _WindScreenState();
}

class _WindScreenState extends ConsumerState<WindScreen> {
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _initializeBle();
  }

  Future<void> _initializeBle() async {
    try {
      final permissionService = PermissionsService();
      final granted = await permissionService.requestBlePermissions();

      if (!granted) {
        setState(() {
          _error = "BLE permissions denied.";
          _isLoading = false;
        });
        return;
      }

      final windService = ref.read(windServiceProvider);
      await windService.connect();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "BLE init failed: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final windData = ref.watch(windProvider);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(_error)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Wind Sensor")),
      body: Center(  // SAFE FIX: keep state wiring stable
        child: windData.when(
          data: (data) => Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "${data.aws.toStringAsFixed(1)} kn",
                    style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "${data.awa.toStringAsFixed(0)}°",
                    style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text("Error: $e"),
        ),
      ),
    );
  }
}