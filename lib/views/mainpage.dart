//Buyer page

import 'dart:convert';
import 'package:bookbytes/models/book.dart';
import 'package:bookbytes/models/user.dart';
import 'package:bookbytes/shared/mydrawer.dart';
import 'package:bookbytes/shared/myserverconfig.dart';
import 'package:bookbytes/views/newbookpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  final User userdata;
  const MainPage({super.key, required this.userdata});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Book> bookList = <Book>[];
  late double screenWidth, screenHeight;
  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  int axiscount = 2;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //CircleAvatar(backgroundImage: AssetImage('')),
              Text(
                "BOOK LIST",
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
        page: "books",
        userdata: widget.userdata,
      ),
      body: bookList.isEmpty
          ? const Center(child: Text("no books available"))
          : Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(bookList.length, (index) {
                      return Card(
                          child: Column(
                        children: [
                          Flexible(
                            flex: 6,
                            child: Container(
                              width: screenWidth,
                              padding: const EdgeInsets.all(4.0),
                              child: Image.network(
                                  fit: BoxFit.fill,
                                  "${MyServerConfig.server}/bookbytes/assets/books/${bookList[index].bookId}.png"),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  truncateString(
                                      bookList[index].bookTitle.toString()),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text("RM ${bookList[index].bookPrice}"),
                                Text(
                                    "Available ${bookList[index].bookQty} unit"),
                              ],
                            ),
                          )
                        ],
                      ));
                    }),
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: newBook,
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromARGB(
          255, 243, 241, 241), // Set the background color here
    );
  }

  void newBook() {
    if (widget.userdata.id.toString() == "0") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please register an account"),
        backgroundColor: Colors.red,
      ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewBookPage(
                    userdata: widget.userdata,
                  )));
    }
  }

  String truncateString(String str) {
    if (str.length > 20) {
      str = str.substring(0, 20);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadBooks() {
    http.get(Uri.parse("${MyServerConfig.server}/mypasar/php/load_books.php"),
        headers: {
          // Add any headers if needed
        }).then((response) {
      // log(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          // Ensure that the response contains 'data' and 'books' keys
          if (data['data'] != null && data['data']['books'] != null) {
            bookList.clear();
            // 'books' key should be an array containing book information
            data['data']['books'].forEach((v) {
              bookList.add(Book.fromJson(v));
            });
          } else {
            // Handle the case where 'data' or 'books' keys are missing
            // You may need to define appropriate error handling here
          }
        } else {
          // Handle the case where 'status' is not 'success'
        }
      }
      setState(() {});
    });
  }
}
