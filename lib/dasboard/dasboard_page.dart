import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/auth/loginpage.dart';
import 'package:flutter_firebase_app/dasboard/cart_page.dart';
import 'package:flutter_firebase_app/dasboard/chat_page.dart';
import 'package:flutter_firebase_app/dasboard/home_page.dart';
import 'package:flutter_firebase_app/dasboard/shop_pages.dart';
import 'package:flutter_firebase_app/responsive.dart';

class DasboardPages extends StatefulWidget {
  @override
  State<DasboardPages> createState() => _DasboardPagesState();
}

class _DasboardPagesState extends State<DasboardPages> {
  final List screen = [HomePage(), CartPage(), ChatPage()];

  var scaffoldkey = GlobalKey<ScaffoldState>();
  final CollectionReference _itemController =
      FirebaseFirestore.instance.collection('cart');
  final CollectionReference _itemControllerShop =
      FirebaseFirestore.instance.collection('pesanan');

  User? user = FirebaseAuth.instance.currentUser;

  int index = 0;
  String Email = '';
  String UserId = '';
  String ProductId = '';
  bool productStatus = false;
  String statuspesanan = '';

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isHovering = false;
    final Size size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    return Scaffold(
      endDrawer: drawer(),
      key: scaffoldkey,
      appBar: Responsive.Ismobile(context)
          ? PreferredSize(
              preferredSize: Size(size.width, 50),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 5, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'FOOD',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      InkWell(
                        onTap: () => scaffoldkey.currentState?.openEndDrawer(),
                        child: Icon(
                          Icons.legend_toggle_outlined,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
              ))
          : PreferredSize(
              preferredSize: Size(size.width, 50),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.only(right: width * 0.1, left: width * 0.1),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.02,
                      ),
                      const Text(
                        'AMEERA',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  index = 0;
                                });
                                ;
                              },
                              child: Text('Home'),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       index = 1;
                            //     });
                            //     ;
                            //   },
                            //   child: Text('Shop'),
                            // ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  index = 1;
                                });
                                ;
                              },
                              child: Text('Shop'),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  index = 2;
                                });
                                ;
                              },
                              child: Text('Chat'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            child: Icon(Icons.search),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          InkWell(
                            onTap: () =>
                                scaffoldkey.currentState?.openEndDrawer(),
                            child: Icon(Icons.shopping_cart_checkout_outlined),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          (Email != null)
                              ? Text(
                                  Email,
                                  style: TextStyle(color: Colors.black),
                                )
                              : InkWell(
                                  child: Text('BELUM BERHASIL',
                                      style: TextStyle(color: Colors.black)),
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              onPressed: () async {
                                await Logout();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Loginpage()));
                              },
                              child: Text(
                                'Logout',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ))
                    ],
                  ),
                ),
              )),
      body: screen[index],
    );
  }

  Widget drawer() {
    return Drawer(
        backgroundColor: Colors.white,
        child: StreamBuilder(
            stream: _itemController.doc(UserId).collection('items').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              var items = snapshot.data!.docs;

              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];
                    String DocumentsId = item.id;
                    String nama = item['nama'];
                    String jenis = item['jenis'];
                    int total_harga = item['total_harga'];
                    int jumlah = item['jumlah'];
                    String img = item['img'];
                    return Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.white,
                        height: 200,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(img))),
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nama,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  jenis,
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  total_harga.toString(),
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            productStatus = true;
                                            addDataShop(
                                                ProductId,
                                                nama,
                                                jenis,
                                                total_harga,
                                                jumlah,
                                                img,
                                                statuspesanan);
                                          });
                                        },
                                        child: (productStatus == false)
                                            ? Text('Boy To get')
                                            : Text(
                                                'In Progres',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                    IconButton(
                                        onPressed: () {
                                          deleteDataCart(DocumentsId);
                                        },
                                        icon: Icon(Icons.remove_circle_outline))
                                  ],
                                )
                              ],
                            ),
                          ],
                        ));
                  });
            }));
  }

  Future<void> deleteDataCart(String DocumentsId) async {
    await _itemController
        .doc(UserId)
        .collection('items')
        .doc(DocumentsId)
        .delete();
  }

  void getEmail() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        UserId = user.uid;
        Email = user.email!;
      });
    }
  }

  Future<void> Logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> addDataShop(String ProductId, String nama, String jenis,
      int total_harga, int Jumlah, String img, String StatusPesanan) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String Userid = user.uid;

      if (Userid != null) {
        await _itemControllerShop.doc(Userid).collection('items').add({
          'verify': StatusPesanan,
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
