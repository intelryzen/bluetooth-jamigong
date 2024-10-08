import 'dart:async';
import 'dart:io';
import 'package:bluetooth/src/component/scan_result_tile.dart';
import 'package:bluetooth/src/provider/bluetooth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BluetoothScanPage extends ConsumerStatefulWidget {
  const BluetoothScanPage({super.key});

  @override
  ConsumerState<BluetoothScanPage> createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends ConsumerState<BluetoothScanPage> {
  List<ScanResult> _scanResults = [];
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription? _adapterStateSubscription;

  @override
  void initState() {
    super.initState();
    onScan();
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    super.dispose();
  }

  Future onScan() async {
    if (await FlutterBluePlus.isSupported == false) {
      debugPrint("Bluetooth not supported by this device");
      return;
    }

    _adapterStateSubscription = FlutterBluePlus.adapterState
        .listen((BluetoothAdapterState state) async {
      if (state == BluetoothAdapterState.on) {
        if (Platform.isAndroid) {
          await FlutterBluePlus.turnOn();
        }

        /// 스캔 시작
        _scanResultsSubscription =
            FlutterBluePlus.scanResults.listen((results) {
          _scanResults = results;
          if (mounted) {
            setState(() {});
          }
        }, onError: (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Scan Error: $e"),
              duration: const Duration(seconds: 5),
            ));
          }
        });
      } else {
        debugPrint("Bluetooth not enabled");
      }
    });

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Start Scan Error: $e"),
          duration: const Duration(seconds: 5),
        ));
      }
    }
  }

  Future<void> onConnectPressed(BluetoothDevice device) async {
    try {
      final result =
          await ref.read(bluetoothProvider.notifier).connectDevice(device);

      if (result && mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Connect Error: $e"),
          duration: const Duration(seconds: 5),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "블루투스 검색",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        color: Colors.black,
        backgroundColor: Colors.white,
        child: ListView.separated(
          itemCount: _scanResults.length,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          itemBuilder: (context, index) {
            final r = _scanResults[index];
            return ScanResultTile(
              result: r,
              onTap: () => onConnectPressed(r.device),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 8,
            );
          },
        ),
      ),
    );
  }

  Future onRefresh() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(const Duration(milliseconds: 500));
  }
// List<Widget> _buildSystemDeviceTiles(BuildContext context) {
//   return _systemDevices
//       .map(
//         (d) => SystemDeviceTile(
//       device: d,
//       onOpen: () => Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => DeviceScreen(device: d),
//           settings: RouteSettings(name: '/DeviceScreen'),
//         ),
//       ),
//       onConnect: () => onConnectPressed(d),
//     ),
//   )
//       .toList();
// }
//
// List<Widget> _buildScanResultTiles(BuildContext context) {
//   return _scanResults
//       .map(
//         (r) => ScanResultTile(
//       result: r,
//       onTap: () => onConnectPressed(r.device),
//     ),
//   )
//       .toList();
// }
}
