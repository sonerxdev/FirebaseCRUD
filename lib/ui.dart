import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String ad, id, kategori;
  double fiyat;

  urunAdiAl(urunAdi) {
    this.ad = urunAdi;
  }

  urunIdsiAl(urunIdsi) {
    this.id = urunIdsi;
  }

  urunKategorisiAl(urunKategorisi) {
    this.kategori = urunKategorisi;
  }

  urunFiyatiAl(urunFiyati) {
    //double falan olursa bu dönüştürme işlemini yapmalisin.
    this.fiyat = double.parse(urunFiyati);
  }

  veriEkle() {
    print("eklendi.");

    //veritabanı Yolu

    DocumentReference veriYolu =
        FirebaseFirestore.instance.collection("Urunler").doc(ad);

    // Çoklu veriler Map ile gönderilir
    //textformfield ile aldıgımız verileri onchanged ile almistik.
    //aldigimiz verileri olusturdugumuz degiskenlere aktarmistik.
    //simdi de burada olusturdugumuz degiskenleri firebasedeki tablolara esitleyerek yolluyoruz.
    Map<String, dynamic> urunler = {
      "urunAdi": ad,
      "urunId": id,
      "urunKategori": kategori,
      "urunFiyat": fiyat
    };
    veriYolu.set(urunler).whenComplete(() {
      print(ad + "eklendi");
    });
  }

  veriOku() {
    // Firebaseden veri okuma.
    DocumentReference veriYolu =
        FirebaseFirestore.instance.collection("Urunler").doc(ad);

    veriYolu.get().then((alinanVeri) {
      print(alinanVeri.data()["urunAdi"]);
      print(alinanVeri.data()["urunId"]);
      print(alinanVeri.data()["urunKategori"]);
      print(alinanVeri.data()["urunFiyat"]);
    });
  }

  veriGuncelle() {
    // veriYolu

    DocumentReference veriYolu =
        FirebaseFirestore.instance.collection("Urunler").doc(ad);

    // Map ile çoklu veri göndericez.

    Map<String, dynamic> urunGuncelVeri = {
      "urunAdi": ad,
      "urunId": id,
      "urunKategori": kategori,
      "urunFiyat": fiyat,
    };

    veriYolu.update(urunGuncelVeri).whenComplete(() {
      print(ad + " Güncellendi.");
    });
  }

  veriSil() {
    // Veri Yolu

    DocumentReference veriYolu =
        FirebaseFirestore.instance.collection("Urunler").doc(ad);
    //sildirme işlemi

    veriYolu.delete().whenComplete(() {
      print(ad + " Silindi.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Ürün Envanteri",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(25.0),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Ürün Adı"),
              onChanged: (String urunAdi) {
                urunAdiAl(urunAdi);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(25.0),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Ürün ID"),
              onChanged: (String urunIdsi) {
                urunIdsiAl(urunIdsi);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(25.0),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Ürün Kategorisi"),
              onChanged: (String urunKategorisi) {
                urunKategorisiAl(urunKategorisi);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(25.0),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Ürün Fiyatı"),
              onChanged: (String urunFiyati) {
                urunFiyatiAl(urunFiyati);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text("Ekle"),
                  textColor: Colors.white,
                  color: Colors.cyan,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onPressed: () {
                    veriEkle();
                  },
                ),
                RaisedButton(
                  child: Text("Oku"),
                  textColor: Colors.white,
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onPressed: () {
                    veriOku();
                  },
                ),
                RaisedButton(
                  child: Text("Güncelle"),
                  textColor: Colors.white,
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onPressed: () {
                    veriGuncelle();
                  },
                ),
                RaisedButton(
                  child: Text("Sil"),
                  textColor: Colors.white,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onPressed: () {
                    veriSil();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text("Ürün Adı"),
                ),
                Expanded(
                  child: Text("Ürün ID"),
                ),
                Expanded(
                  child: Text("Ürün Kategori"),
                ),
                Expanded(
                  child: Text("Ürün Fiyat"),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("Urunler").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot dokumanSnapshot =
                          snapshot.data.documents[index];

                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              dokumanSnapshot["urunAdi"],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              dokumanSnapshot["urunId"],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              dokumanSnapshot["urunKategori"],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              dokumanSnapshot["urunFiyat"].toString(),
                            ),
                          ),
                        ],
                      );
                    });
              }
            },
          )
        ],
      ),
    );
  }
}
