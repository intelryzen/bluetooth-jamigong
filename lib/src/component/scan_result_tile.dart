import 'dart:async';
import 'package:bluetooth/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({
    super.key,
    required this.result,
    this.onTap,
  });

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription =
        widget.result.device.connectionState.listen((state) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  String getNiceManufacturerData(List<List<int>> data) {
    return data
        .map((val) => '${getNiceHexArray(val)}')
        .join(', ')
        .toUpperCase();
  }

  String getNiceServiceData(Map<Guid, List<int>> data) {
    return data.entries
        .map((v) => '${v.key}: ${getNiceHexArray(v.value)}')
        .join(', ')
        .toUpperCase();
  }

  String getNiceServiceUuids(List<Guid> serviceUuids) {
    return serviceUuids.join(', ').toUpperCase();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Widget _buildTitle(BuildContext context) {
    if (widget.result.device.platformName.isNotEmpty) {
      return Text(
        widget.result.device.platformName,
        style: const TextStyle(fontSize: 20),
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return Text(
        widget.result.device.remoteId.str,
        style: const TextStyle(fontSize: 20),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool available = widget.result.advertisementData.connectable;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: available && !isConnected ? widget.onTap : null,
      child: Container(
        height: 68,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: available ? Palette.greyColor : Palette.greyColor2,
            borderRadius: BorderRadius.circular(20)),
        child: _buildTitle(context),
      ),
    );
  }
}
