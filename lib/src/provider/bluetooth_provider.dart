import 'dart:async';
import 'dart:convert';
import 'package:bluetooth/src/model/data_model.dart';
import 'package:bluetooth/src/model/iot_model.dart';
import 'package:bluetooth/src/model/thres_data_model.dart';
import 'package:bluetooth/src/provider/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final bluetoothProvider =
    StateNotifierProvider.autoDispose<BluetoothNotifier, IotModel>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);

    return BluetoothNotifier(prefs);
  },
);

class BluetoothNotifier extends StateNotifier<IotModel> {
  final SharedPreferences prefs;
  StreamSubscription? _lastValueSubscription;

  BluetoothNotifier(this.prefs)
      : super(
          IotModel(
            device: null,
            write: null,
            subscribe: null,
            thresh: ThresDataModel.fromPrefs(prefs),
            sensor: DataModel(),
          ),
        ) {
    reconnectDevice();
  }

  Future<void> reconnectDevice() async {
    final remoteId = prefs.getString("remoteId");

    if (remoteId != null) {
      try {
        var device = BluetoothDevice.fromId(remoteId);
        await connectDevice(device);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<bool> connectDevice(BluetoothDevice device) async {
    await disconnectDevice();
    await device.connect();
    state = state.copyWith(device: device);

    prefs.setString("remoteId", device.remoteId.str);

    List<BluetoothService> services = await device.discoverServices();

    if (services.isNotEmpty) {
      for (BluetoothCharacteristic characteristic
          in services[0].characteristics) {
        if (characteristic.properties.read) {
          await updateSubscribe(characteristic);
        } else {
          updateWrite(characteristic);
        }
      }
    }

    // 처음 연결시 세팅값 보냄.
    final json = state.thresh.toRawJson();
    json.keys.forEach((key) async {
      try {
        await sendText(json[key]!);
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    return true;
  }

  Future disconnectDevice() async {
    await _lastValueSubscription?.cancel();
    await state.device?.disconnect();
    prefs.remove("remoteId");
    state = state.copyWith(resetDevice: true);
  }

  Future updateSubscribe(BluetoothCharacteristic char) async {
    state = state.copyWith(subscribe: char);

    await _lastValueSubscription?.cancel();
    _lastValueSubscription = char.lastValueStream.listen((value) async {
      final List<int> list = [];
      final str = utf8.decode(list);

      debugPrint("받아온 값: $str");
      if (str == "TIME") {
        writeNow();
      } else {
        updateSensorData(str);
      }
    });
  }

  String get _now {
    final time = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    return "TIME$time";
  }

  Future writeNow() async {
    try {
      sendText(_now);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future updateThreshValue(String key, num value) async {
    if (key == "li") {
      await prefs.setInt('liValue', value.toInt());
    } else {
      await prefs.setDouble('${key}Value', value.toDouble());
    }

    state = state.copyWith(thresh: ThresDataModel.fromPrefs(prefs));

    try {
      await sendText(state.thresh.toRawJson()[key]!);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future sendText(String text) async {
    final data = utf8.encode(text);
    if (state.write != null) {
      await state.write!.write(data,
          withoutResponse: state.write!.properties.writeWithoutResponse);
    }
  }

  void updateWrite(BluetoothCharacteristic char) {
    state = state.copyWith(write: char);
  }

  void updateThreshData(String str) {
    state = state.copyWith(thresh: ThresDataModel.fromStr(str, state.thresh));
  }

  void updateSensorData(String str) {
    state = state.copyWith(sensor: DataModel.fromStr(str, state.sensor));
  }
}
