import 'package:bluetooth/theme/pallete.dart';
import 'package:flutter/material.dart';

class SensorBox extends StatelessWidget {
  final String sensorName;
  final num value;

  const SensorBox({
    super.key,
    required this.sensorName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.greyColor2,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  sensorName,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Palette.greyColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      border: Border(top: BorderSide())),
                  child: Switch.adaptive(
                    value: true,
                    onChanged: (_) {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
