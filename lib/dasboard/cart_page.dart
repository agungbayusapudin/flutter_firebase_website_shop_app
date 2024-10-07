import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CollectionReference _itemController =
      FirebaseFirestore.instance.collection('product');

  final CollectionReference _itemControllercart =
      FirebaseFirestore.instance.collection('cart');
  final CollectionReference _userController =
      FirebaseFirestore.instance.collection('user');

  int indexing = 0;
  String image_product = '';
  String name_product = '';
  String jenis_product = '';
  int harga_product = 0;
  String ProductId = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        body: ListView(
      children: [
        Container(
          color: Colors.white,
          child: StreamBuilder(
              stream: _itemController.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                var items = snapshot.data!.docs;

                return Container(
                  height: height,
                  width: width,
                  child: Padding(
                      padding:
                          EdgeInsets.only(right: width / 10, left: width / 10),
                      child: Row(children: [
                        Container(
                          height: height / 1.5,
                          width: width / 15,
                          child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                var item = items[index];
                                String PID = item.id;
                                String img = item['img'];
                                String nama = item['nama'];
                                String jenis = item['jenis'];
                                int harga = item['harga'];
                                return InkWell(
                                    onTap: () {
                                      setState(() {
                                        image_product = img;
                                        name_product = nama;
                                        jenis_product = jenis;
                                        harga_product = harga;
                                        ProductId = PID;
                                      });
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Image.network(img)));
                              }),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: width / 3,
                          height: height / 1.5,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(image_product),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          width: width / 3,
                          height: height + height / 10,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: width / 18),
                                child: Text(
                                  'AMEERA',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                name_product,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                jenis_product,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '\Rp.${harga_product.toString()}',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[600],
                                ),
                              ),
                              SizedBox(height: height / 3),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            indexing++;
                                          });
                                        },
                                        icon: Icon(Icons.add_circle_outline),
                                        color: Colors.black,
                                      ),
                                      Text(
                                        indexing.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (indexing > 0) {
                                              indexing--;
                                            }
                                          });
                                        },
                                        icon: Icon(Icons.remove_circle_outline),
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      var total_harga =
                                          indexing * harga_product;
                                      (indexing == 0)
                                          ? indexing
                                          : addDataCart(
                                              ProductId,
                                              name_product,
                                              jenis_product,
                                              total_harga,
                                              indexing,
                                              image_product,
                                            );
                                    },
                                    icon: Icon(Icons.shopping_cart_outlined),
                                    label: Text('Add To Cart'),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 15,
                                      ),
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ])),
                );
              }),
        )
      ],
    ));
  }

  Future<void> addDataCart(String ProductId, String nama, String jenis,
      int total_harga, int Jumlah, String img) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String Userid = user.uid;

      if (Userid != null) {
        await _itemControllercart.doc(Userid).collection('items').add({
          'nama': nama,
          'jenis': jenis,
          'total_harga': total_harga,
          'jumlah': Jumlah,
          'img': img,
        });
      }
    }
  }
}
