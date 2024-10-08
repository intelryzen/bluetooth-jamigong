import 'package:bluetooth/src/model/sensors.dart';
import 'package:bluetooth/src/model/settings_min_max.dart';
import 'package:bluetooth/src/provider/bluetooth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bluetoothProvider);
    double teValue = double.parse(state.thresh.temp.toStringAsFixed(1));
    double liValue = double.parse(state.thresh.li.toStringAsFixed(1));
    double huValue = double.parse(state.thresh.hum.toStringAsFixed(1));
    double s1Value = double.parse(state.thresh.soi1.toStringAsFixed(1));
    double s2Value = double.parse(state.thresh.soi2.toStringAsFixed(1));
    double s3Value = double.parse(state.thresh.soi3.toStringAsFixed(1));
    double s4Value = double.parse(state.thresh.soi4.toStringAsFixed(1));

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          buildSensorSlider(koSensorNames['temp']!, teValue, minValues['TE']!,
              maxValues['TE']!, (value) {
            ref
                .read(bluetoothProvider.notifier)
                .updateThreshValue("temp", value);
          }),
          buildSensorSlider(
              koSensorNames['li']!, liValue, minValues['LI']!, maxValues['LI']!,
              (value) {
            ref
                .read(bluetoothProvider.notifier)
                .updateThreshValue("li", value);
          }),
          buildSensorSlider(koSensorNames['hum']!, huValue, minValues['HU']!,
              maxValues['HU']!, (value) {
            ref
                .read(bluetoothProvider.notifier)
                .updateThreshValue("hum", value);
          }),
          buildSensorSlider(koSensorNames['soi1']!, s1Value, minValues['S1']!,
              maxValues['S1']!, (value) {
            ref
                .read(bluetoothProvider.notifier)
                .updateThreshValue("soi1", value);
          }),
          buildSensorSlider(koSensorNames['soi2']!, s2Value, minValues['S2']!,
              maxValues['S2']!, (value) {
            ref
                .read(bluetoothProvider.notifier)
                .updateThreshValue("soi2", value);
          }),
          buildSensorSlider(koSensorNames['soi3']!, s3Value, minValues['S3']!,
              maxValues['S3']!, (value) {
            ref
                .read(bluetoothProvider.notifier)
                .updateThreshValue("soi3", value);
          }),
          buildSensorSlider(koSensorNames['soi4']!, s4Value, minValues['S4']!,
              maxValues['S4']!, (value) {
            ref
                .read(bluetoothProvider.notifier)
                .updateThreshValue("soi4", value);
          }),
        ],
      ),
    );
  }

  Widget buildSensorSlider(String sensorName, double currentValue, double min,
      double max, ValueChanged<double> onChanged) {
    bool isIntegerSensor = sensorName == 'LI';
    int divisions =
        isIntegerSensor ? (max - min).toInt() : ((max - min) * 10).toInt();

    return ListTile(
      title: Text(
        isIntegerSensor
            ? '$sensorName: ${currentValue.round()}'
            : '$sensorName: ${currentValue.toStringAsFixed(1)}',
      ),
      subtitle: Slider(
        value: currentValue,
        min: min,
        max: max,
        divisions: divisions,
        label: isIntegerSensor
            ? currentValue.round().toString()
            : currentValue.toStringAsFixed(1),
        onChanged: onChanged,
      ),
    );
  }
}
