
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CryptoPage(),
    );
  }
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  late Future<List<dynamic>> cryptoData;

  @override
  void initState() {
    super.initState();
    cryptoData = fetchCrypto();
  }

  Future<List<dynamic>> fetchCrypto() async {
    final url = Uri.parse(
      'https://api.coinlore.net/api/tickers/',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['data'];
    } else {
      throw Exception('Gagal mengambil data cryptocurrency');
    }
  }

  void refreshData() {
    setState(() {
      cryptoData = fetchCrypto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: refreshData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Refresh'),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: cryptoData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Gagal memuat data'),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: refreshData,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  final coins = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: coins.length,
                    itemBuilder: (context, index) {
                      final coin = coins[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF2CC),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.orange.shade200,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 55,
                              child: Column(
                                children: [
                                  const Text(
                                    'Rank',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    '${coin['rank']}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${coin['name']}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    '${coin['symbol']}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'USD',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    '${coin['price_usd']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
