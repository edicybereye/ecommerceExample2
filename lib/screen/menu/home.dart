import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_ecommerce/model/productModel.dart';
import 'package:training_ecommerce/network/network.dart';
import 'package:training_ecommerce/screen/produk/addProduct.dart';
import 'package:http/http.dart' as http;
import 'package:training_ecommerce/screen/produk/productDetail.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final price = NumberFormat("#,##0", 'en_US');

class _HomeState extends State<Home> {
  var loading = false;
  List<ProductModel> list = [];
  getProduct() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(NetworkUrl.getProduct());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (Map i in data) {
          list.add(ProductModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> onRefresh() async {
    getProduct();
  }

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProduct(),
                ));
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.blue,
            ),
            child: Text(
              "Add Product",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: onRefresh,
                child: GridView.builder(
                  itemCount: list.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, i) {
                    final a = list[i];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetail(a)));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Image.network(
                                "http://192.168.65.2/ecommerce/product/${a.cover}",
                                fit: BoxFit.cover,
                                height: 180,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "${a.productName}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Rp. ${price.format(a.sellingPrice)}",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.orange,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ));
  }
}
