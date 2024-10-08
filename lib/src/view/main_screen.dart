import 'package:bluetooth/src/component/dialog.dart';
import 'package:bluetooth/src/component/sensor_box.dart';
import 'package:bluetooth/src/model/sensors.dart';
import 'package:bluetooth/src/provider/bluetooth_provider.dart';
import 'package:bluetooth/src/view/bluetooth_scan_page.dart';
import 'package:bluetooth/src/view/setting_page.dart';
import 'package:bluetooth/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bluetoothProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              state.device == null
                  ? '연결된 기기 없음'
                  : state.device?.platformName == null ||
                          state.device?.platformName == ""
                      ? "자미공"
                      : state.device!.platformName,
            ),
            // const Icon(Icons.keyboard_arrow_down),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              if (ref.read(bluetoothProvider).device == null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const BluetoothScanPage();
                }));
              } else {
                alreadyConnectedDialog(context, () async {
                  await ref.read(bluetoothProvider.notifier).disconnectDevice();
                });
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        // 1행에 2개의 항목을 표시
        crossAxisCount: 2,
        // 그리드 간의 간격을 설정
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        // 총 6개의 항목을 그리드에 표시
        children: sensorNames.map((e) {
          return SensorBox(
            sensorName: koSensorNames[e]!,
            value: state.sensor.toJson()[e],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SettingPage();
          }));
        },
        backgroundColor: Palette.greyColor,
        elevation: 0,
        child: const Text("설정"),
      ),
    );
  }
}
