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
      print(alinanVeri.data);
    });
  }

  veriGuncelle() {
    print("Güncellendi.");
  }

  veriSil() {
    print("Silindi.");
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
          Row(
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
          )
        ],
      ),
    );
  }
}
