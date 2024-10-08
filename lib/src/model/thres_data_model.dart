import 'package:shared_preferences/shared_preferences.dart';

class ThresDataModel {
  final double temp;
  final int li;
  final double hum;
  final double soi1;
  final double soi2;
  final double soi3;
  final double soi4;

  ThresDataModel({
    this.temp = 0,
    this.li = 0,
    this.hum = 0,
    this.soi1 = 0,
    this.soi2 = 0,
    this.soi3 = 0,
    this.soi4 = 0,
  });

  ThresDataModel copyWith({
    double? temp,
    int? li,
    double? hum,
    double? soi1,
    double? soi2,
    double? soi3,
    double? soi4,
  }) =>
      ThresDataModel(
        temp: temp ?? this.temp,
        li: li ?? this.li,
        hum: hum ?? this.hum,
        soi1: soi1 ?? this.soi1,
        soi2: soi2 ?? this.soi2,
        soi3: soi3 ?? this.soi3,
        soi4: soi4 ?? this.soi4,
      );

  Map toJson() {
    return {
      "temp": temp,
      "li": li,
      "hum": hum,
      "soi1": soi1,
      "soi2": soi2,
      "soi3": soi3,
      "soi4": soi4,
    };
  }

  Map<String, String> toRawJson() {
    String formatSensorValue(double value, int totalDigits) {
      int intValue = (value * 10).round(); // 소수점을 제거하고 정수로 변환
      String strValue = intValue.toString().padLeft(totalDigits, '0');
      return strValue;
    }

    String tempStr =  "TE${formatSensorValue(temp, 3)}";
    String liStr = "LI${li.toString().padLeft(6, '0')}";
    String humStr ="HU${formatSensorValue(hum, 3)}";
    String soi1Str ="S1${formatSensorValue(soi1, 3)}";
    String soi2Str ="S2${formatSensorValue(soi2, 3)}";
    String soi3Str ="S3${formatSensorValue(soi3, 3)}";
    String soi4Str ="S4${formatSensorValue(soi4, 3)}";

    return {
      "temp": tempStr,
      "li": liStr,
      "hum": humStr,
      "soi1": soi1Str,
      "soi2": soi2Str,
      "soi3": soi3Str,
      "soi4": soi4Str,
    };
  }

  // @override
  // String toString() {
  //   return "TE${temp}LI${li}HU${hum}S1${soi1}S2${soi2}S3${soi3}S4${soi4}";
  // }

  factory ThresDataModel.fromPrefs(SharedPreferences prefs) {
    return ThresDataModel(
      temp: prefs.getDouble('tempValue') ?? 0.0,
      li: prefs.getInt('liValue') ?? 0,
      hum: prefs.getDouble('humValue') ?? 0.0,
      soi1: prefs.getDouble('soi1Value') ?? 0.0,
      soi2: prefs.getDouble('soi2Value') ?? 0.0,
      soi3: prefs.getDouble('soi3Value') ?? 0.0,
      soi4: prefs.getDouble('soi4Value') ?? 0.0,
    );
  }

  static ThresDataModel fromStr(String str, ThresDataModel current) {
    if (str.startsWith('TE')) {
      final temp = double.parse(str.replaceAll('TE', ''));
      return current.copyWith(temp: temp);
    } else if (str.startsWith('LI')) {
      final li = int.parse(str.replaceAll('LI', ''));
      return current.copyWith(li: li);
    } else if (str.startsWith('HU')) {
      final hum = double.parse(str.replaceAll('HU', ''));
      return current.copyWith(hum: hum);
    } else if (str.startsWith('S1')) {
      final soi1 = double.parse(str.replaceAll('S1', ''));
      return current.copyWith(soi1: soi1);
    } else if (str.startsWith('S2')) {
      final soi2 = double.parse(str.replaceAll('S2', ''));
      return current.copyWith(soi2: soi2);
    } else if (str.startsWith('S3')) {
      final soi3 = double.parse(str.replaceAll('S3', ''));
      return current.copyWith(soi3: soi3);
    } else if (str.startsWith('S4')) {
      final soi4 = double.parse(str.replaceAll('S4', ''));
      return current.copyWith(soi4: soi4);
    }
    return current; // Return current state if no match
  }
}
