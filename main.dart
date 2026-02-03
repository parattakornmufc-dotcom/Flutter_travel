import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'travel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'travel API',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<travel>> products;

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  Future<List<travel>> fetchProducts() async {
    final response = await http.get(
      Uri.parse(
        'http://localhost/flutter_travel/php_api/travel.php',
        // ถ้าเป็น Flutter Web เปลี่ยนเป็น localhost
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData =
          json.decode(response.body);

      if (jsonData['success'] == true) {
        List list = jsonData['data'];
        return list.map((e) =>travel.fromJson(e)).toList();
      } else {
        throw Exception('API ส่ง success = false');
      }
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลได้');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ชื่อสถานที่ท่องเที่ยว'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<travel>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'เกิดข้อผิดพลาด:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
                child: Text('ไม่พบข้อมูลสินค้า'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      child:
                          Text(item.id.toString()),
                    ),
                    title: Text(item.name),
                    subtitle: Text(
                        'คำอธิบายสถานที่ท่องเที่ยว ${item.description} '),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
