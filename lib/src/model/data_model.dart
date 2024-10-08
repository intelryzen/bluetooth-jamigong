import 'package:shared_preferences/shared_preferences.dart';

class DataModel {
  final int temp;
  final int li;
  final int hum;
  final int soi1;
  final int soi2;
  final int soi3;
  final int soi4;

  DataModel({
    this.temp = 0,
    this.li = 0,
    this.hum = 0,
    this.soi1 = 0,
    this.soi2 = 0,
    this.soi3 = 0,
    this.soi4 = 0,
  });

  DataModel copyWith({
    int? temp,
    int? li,
    int? hum,
    int? soi1,
    int? soi2,
    int? soi3,
    int? soi4,
  }) =>
      DataModel(
        temp: temp ?? this.temp,
        li: li ?? this.li,
        hum: hum ?? this.hum,
        soi1: soi1 ?? this.soi1,
        soi2: soi2 ?? this.soi2,
        soi3: soi3 ?? this.soi3,
        soi4: soi4 ?? this.soi4,
      );

  @override
  String toString() {
    return "TE${temp}LI${li}HU${hum}S1${soi1}S2${soi2}S3${soi3}S4${soi4}";
  }

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

  static int toInt(num number) {
    return int.parse(number.toString().replaceAll(".", ""));
  }

  factory DataModel.fromPrefs(SharedPreferences prefs) {
    return DataModel(
      temp: toInt(prefs.getDouble('tempValue') ?? 0.0),
      li: toInt(prefs.getInt('liValue') ?? 0),
      hum: toInt(prefs.getDouble('humValue') ?? 0.0),
      soi1: toInt(prefs.getDouble('soi1Value') ?? 0.0),
      soi2: toInt(prefs.getDouble('soi2Value') ?? 0.0),
      soi3: toInt(prefs.getDouble('soi3Value') ?? 0.0),
      soi4: toInt(prefs.getDouble('soi4Value') ?? 0.0),
    );
  }

  static DataModel fromStr(String str, DataModel current) {
    if (str.startsWith('TE')) {
      final temp = int.parse(str.replaceAll('TE', ''));
      return current.copyWith(temp: temp);
    } else if (str.startsWith('LI')) {
      final li = int.parse(str.replaceAll('LI', ''));
      return current.copyWith(li: li);
    } else if (str.startsWith('HU')) {
      final hum = int.parse(str.replaceAll('HU', ''));
      return current.copyWith(hum: hum);
    } else if (str.startsWith('S1')) {
      final soi1 = int.parse(str.replaceAll('S1', ''));
      return current.copyWith(soi1: soi1);
    } else if (str.startsWith('S2')) {
      final soi2 = int.parse(str.replaceAll('S2', ''));
      return current.copyWith(soi2: soi2);
    } else if (str.startsWith('S3')) {
      final soi3 = int.parse(str.replaceAll('S3', ''));
      return current.copyWith(soi3: soi3);
    } else if (str.startsWith('S4')) {
      final soi4 = int.parse(str.replaceAll('S4', ''));
      return current.copyWith(soi4: soi4);
    }
    return current; // Return current state if no match
  }
}
