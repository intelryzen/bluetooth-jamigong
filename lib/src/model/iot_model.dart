import 'package:bluetooth/src/model/data_model.dart';
import 'package:bluetooth/src/model/thres_data_model.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class IotModel {
  final BluetoothDevice? device;
  final BluetoothCharacteristic? write;
  final BluetoothCharacteristic? subscribe;
  final ThresDataModel thresh;
  final DataModel sensor;

  IotModel({
    required this.device,
    required this.write,
    required this.subscribe,
    required this.thresh,
    required this.sensor,
  });

  IotModel copyWith({
    BluetoothDevice? device,
    BluetoothCharacteristic? write,
    BluetoothCharacteristic? subscribe,
    ThresDataModel? thresh,
    DataModel? sensor,
    bool resetDevice = false,
  })  =>
      IotModel(
        device: resetDevice ? null : (device ?? this.device),
        write: write ?? this.write,
        subscribe: subscribe ?? this.subscribe,
        thresh: thresh ?? this.thresh,
        sensor: sensor ?? this.sensor,
      );
}
