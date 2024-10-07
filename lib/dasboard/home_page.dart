import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_app/dasboard/cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _itemController =
      FirebaseFirestore.instance.collection('product');

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        body: ListView(
      children: [
        Container(
          color: Colors.white,
          height: height,
          width: width,
          child: Padding(
            padding: EdgeInsets.only(right: width / 10, left: width / 10),
            child: Container(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, right: 20, bottom: 20),
                    child: Container(
                      height: height,
                      width: width / 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200],
                          image: DecorationImage(
                              image: AssetImage('home_image1.png'),
                              fit: BoxFit.contain)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    height: height,
                    width: width / 4,
                    child: Column(
                      children: [
                        Container(
                          height: height / 5,
                          width: width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('home_image2.png'))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: height / 2.1,
                          width: width / 4,
                          child: Column(
                            children: [
                              Text(
                                'ULTIMATE',
                                style: TextStyle(
                                    fontSize: 60, fontWeight: FontWeight.bold),
                              ),
                              Stack(
                                children: [
                                  Text(
                                    'SALE',
                                    style: TextStyle(
                                      fontSize: 100,
                                      fontWeight: FontWeight.w900,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 6
                                        ..color =
                                            const Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  Text(
                                    'SALE',
                                    style: TextStyle(
                                        fontSize: 100,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Text(
                                'NEW COLLECTION',
                                style: TextStyle(fontSize: 20),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'SHOP NOW',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.black),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: height / 5,
                          width: width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('home_image4.png'))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      height: height,
                      width: width / 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200],
                          image: DecorationImage(
                              image: AssetImage('home_image3.png'),
                              fit: BoxFit.contain)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
            color: Colors.white,
            height: height,
            width: width,
            child: Column(
              children: [
                SizedBox(
                  height: height / 10,
                ),
                Text(
                  'New Arrivals',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(right: width / 4, left: width / 4),
                  child: Text(
                    'Dont miss out on the seasons hottest looks! Be among the first to shop our exclusive new pieces and elevate your wardrobe. With limited stock, now is the time to find your new favorite outfit.',
                    maxLines: 2,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: height / 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: width / 10),
                  height: height / 2,
                  width: width,
                  child: StreamBuilder(
                      stream: _itemController.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        var items = snapshot.data!.docs;

                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              var item = items[index];
                              String nama = item['nama'];
                              String jenis = item['jenis'];
                              int harga = item['harga'];
                              String img = item['img'];

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Card(
                                    color: Colors.grey,
                                    shadowColor: Colors.black,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 20),
                                      height: height / 2,
                                      width: width / 4,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: height / 4,
                                            width: width / 6,
                                            child: Image.network(img),
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          Text(
                                            nama,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(jenis),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: 30, left: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  harga.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CartPage()));
                                                    },
                                                    icon: Icon(
                                                        Icons.shopping_cart))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            });
                      }),
                ),
                SizedBox(
                  height: height / 15,
                ),
                TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.black, elevation: 20),
                    child: Text(
                      'More Product',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ))
              ],
            )),
        Container(
          color: Colors.white,
          width: width,
          height: height,
          child: Column(
            children: [
              SizedBox(
                height: height / 10,
              ),
              Text(
                'Follow Us on Instagram',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height / 20,
              ),
              Padding(
                padding: EdgeInsets.only(right: width / 4, left: width / 4),
                child: Text(
                  'Dont miss out on the seasons hottest looks! Be among the first to shop our exclusive new pieces and elevate your wardrobe. With limited stock, now is the time to find your new favorite outfit.',
                  maxLines: 2,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: height / 6,
              ),
              Container(
                width: width,
                height: height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('home_follow.png'),
                        fit: BoxFit.contain)),
              )
            ],
          ),
        ),
        Container(
          color: Colors.white,
          height: height,
          width: width,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                height: height / 1.2,
                width: width / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('image_subs1.png'),
                )),
              ),
              Container(
                height: height / 2,
                width: width / 3,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Text(
                      'Subscribe To Our Newslater',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    Padding(
                      padding: EdgeInsets.only(),
                      child: Text(
                        'Dont miss out on the seasons hottest looks! Be among the first to shop our exclusive new pieces and elevate your wardrobe. With limited stock, now is the time to find your new favorite outfit.',
                        maxLines: 2,
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: height / 10,
                    ),
                    Text(
                      'Agung@gmail.com',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: Text('Subscribe Now'))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(30),
                height: height / 1.2,
                width: width / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('image_subs2.png'),
                        fit: BoxFit.contain)),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
