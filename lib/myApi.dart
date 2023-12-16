import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class Crypto extends ChangeNotifier {
  List<dynamic> _cryptoData = [];

  List<dynamic> get cryptoData => _cryptoData;

  Future<void> fetchData() async {
    final url =
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=BTC,ETH,LTC";
    final ApiKey = {
      "X-CMC_PRO_API_KEY": "27ab17d1-215f-49e5-9ca4-afd48810c149",
    };

    final response = await http.get(Uri.parse(url), headers: ApiKey);

    if (response.statusCode == 200) {
      _cryptoData = json.decode(response.body)['data'].values.toList();
      notifyListeners();
    } else {
      throw Exception('Failed');
    }
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Crypto(),
      child: Consumer<Crypto>(
        builder: (context, provider, _) {
          if (provider.cryptoData.isEmpty) {
            provider.fetchData();
            return Scaffold(
              appBar: AppBar(
                title: Text('CoinRich'),
                centerTitle: true,
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('CoinRich'),
                centerTitle: true,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timelapse_outlined,
                              color: Colors.yellowAccent,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Show Chart',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow),
                            ),
                          ],
                        ),
                        Text(
                          'Count: ${provider.cryptoData.length}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.cryptoData.length,
                      itemBuilder: (context, index) {
                        var currency = provider.cryptoData[index];
                        var Coinname = currency['name'];
                        var cmcrank = currency['cmc_rank'];
                        var priceindollar = currency['quote']['USD']['price'];
                        var change24h =
                            currency['quote']['USD']['percent_change_24h'];

                        // Determine arrow color based on the change
                        IconData arrowIcon = Icons.arrow_upward;
                        Color arrowColor = Colors.green;
                        if (change24h < 0) {
                          arrowIcon = Icons.arrow_downward;
                          arrowColor = Colors.red;
                        }

                        return Card(
                          color: Colors.black,
                          margin: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '$Coinname',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.yellowAccent),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                arrowIcon,
                                                color: arrowColor,
                                              ),
                                              Text(
                                                '${change24h.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  color: change24h >= 0
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .grey, // Grey background color
                                              border: Border.all(
                                                color: Colors
                                                    .grey, // White border color
                                                width: 2, // Border width
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${currency['symbol']}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Price:       \$ ${priceindollar.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Text(
                                            'Rank $cmcrank',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      // Add your button functionality here
                                    },
                                    mini: true,
                                    child: Icon(Icons.arrow_forward),
                                    backgroundColor: Colors.yellow,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
