import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: Colors.blueAccent,
          iconTheme: IconThemeData(
            color: Colors.white,

          )
        ),
        bottomAppBarColor: Colors.transparent
      
      ),
      title: 'HTTOP Request',
      home: HomePage(),
    );
    
  }
}
class HomePage extends StatelessWidget {
  Future<List>getCurrencies()async{
    http.Response res=await http.Client().get("https://api.coinlore.com/api/tickers/");
    return json.decode(res.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.details),
        title: Text('Cryptocurrency'),
      ),
      body: Container(
        child: FutureBuilder(
          future: getCurrencies(),
            builder:(BuildContext context,AsyncSnapshot snapshot){
              if(!snapshot.hasData)return Center(child: CircularProgressIndicator());
              if(snapshot.hasError)return Center(child: Text('There is an error'));
              List data = snapshot.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context,int index){
                  Coin coin=Coin.fromMap(data[index]);
                  return ListTile(
                    title: Text(coin.name,style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                    
                    trailing: Text("\$${coin.priceUSD}",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
                    subtitle: Text(coin.symbol,style:TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                  );
                },
              );
            }
          
        ),
      ),
    );
  }
}
class Coin {
   String id;
   String name;
   String symbol;
   String priceUSD;

   Coin.fromMap(Map data):
      id=data['id'],
      name=data['name'],
      symbol=data['symbol'],
      priceUSD=data['price_usd'];
   }
  
