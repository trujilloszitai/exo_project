import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlphaVantage extends StatefulWidget {
  const AlphaVantage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AlphaVantageState createState() => _AlphaVantageState();
}

class _AlphaVantageState extends State<AlphaVantage> {
  late Future<AlphaV> futurDataFromAlphaVantage;

  @override
  void initState() {
    super.initState();
    futurDataFromAlphaVantage = fetchDataFromAlphaVantage();
  }

  Future<AlphaV> fetchDataFromAlphaVantage() async {
    const token = 'GL6PWL42O1GZ5V3Q';
    final url = Uri.parse(
        'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=IBM&apikey=${token}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      print('Response: ${response.body}');
      return AlphaV.fromJson(jsonBody);
    } else {
      throw Exception('Error al obtener datos de AlphaVantage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Aplicación'),
      ),
      body: Center(
        child: FutureBuilder<AlphaV>(
          future: futurDataFromAlphaVantage,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.globalQuote.the01Symbol);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class AlphaV {
  GlobalQuote globalQuote;

  AlphaV({
    required this.globalQuote,
  });

  factory AlphaV.fromJson(Map<String, dynamic> json) => AlphaV(
        globalQuote: GlobalQuote.fromJson(json["Global Quote"]),
      );

  Map<String, dynamic> toJson() => {
        "Global Quote": globalQuote.toJson(),
      };
}

class GlobalQuote {
  String the01Symbol;
  String the02Open;
  String the03High;
  String the04Low;
  String the05Price;
  String the06Volume;
  DateTime the07LatestTradingDay;
  String the08PreviousClose;
  String the09Change;
  String the10ChangePercent;

  GlobalQuote({
    required this.the01Symbol,
    required this.the02Open,
    required this.the03High,
    required this.the04Low,
    required this.the05Price,
    required this.the06Volume,
    required this.the07LatestTradingDay,
    required this.the08PreviousClose,
    required this.the09Change,
    required this.the10ChangePercent,
  });

  factory GlobalQuote.fromJson(Map<String, dynamic> json) => GlobalQuote(
        the01Symbol: json["01. symbol"],
        the02Open: json["02. open"],
        the03High: json["03. high"],
        the04Low: json["04. low"],
        the05Price: json["05. price"],
        the06Volume: json["06. volume"],
        the07LatestTradingDay: DateTime.parse(json["07. latest trading day"]),
        the08PreviousClose: json["08. previous close"],
        the09Change: json["09. change"],
        the10ChangePercent: json["10. change percent"],
      );

  Map<String, dynamic> toJson() => {
        "01. symbol": the01Symbol,
        "02. open": the02Open,
        "03. high": the03High,
        "04. low": the04Low,
        "05. price": the05Price,
        "06. volume": the06Volume,
        "07. latest trading day":
            "${the07LatestTradingDay.year.toString().padLeft(4, '0')}-${the07LatestTradingDay.month.toString().padLeft(2, '0')}-${the07LatestTradingDay.day.toString().padLeft(2, '0')}",
        "08. previous close": the08PreviousClose,
        "09. change": the09Change,
        "10. change percent": the10ChangePercent,
      };
}
