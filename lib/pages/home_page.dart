import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{
 final int _dollarRate = 1250;
 final TextEditingController _nairaRateController = TextEditingController();
 late double _toDollarConversion = 0;


  void convertCurrency(){
    setState(() {
      if(_nairaRateController.text.isNotEmpty){
        _toDollarConversion = double.parse(_nairaRateController.text) / _dollarRate;
      }else {
        _toDollarConversion = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "\$$_toDollarConversion",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 20),
              Text("The current rate is $_dollarRate"),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _nairaRateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter price in ₦",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))
                    )
                  ),
                  onSubmitted: (String value){
                    convertCurrency();
                    },
                ),
              ),
              ElevatedButton(
                  onPressed: convertCurrency,
                  child: const Text("Convert to dollar")
              )
              ],
        ),
      ),
    );
  }
}