//seller page

import 'package:bookbytes/shared/mydrawer.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class OrderPage extends StatefulWidget {
  final User userdata;
  const OrderPage({super.key, required this.userdata});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //CircleAvatar(backgroundImage: AssetImage('')),
                Text(
                  "Sells Book",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            )),
        drawer: MyDrawer(
          page: 'seller',
          userdata: widget.userdata,
        ),
        body: const Center(
          child: Text("SELLER PAGE"),
        ));
  }
}
