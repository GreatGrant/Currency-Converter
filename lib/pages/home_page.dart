import 'package:flutter/material.dart';
import 'package:currency_converter/models/currency.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final _currencies = Currency.getCurrencies();
  final TextEditingController _amountController = TextEditingController();
  late double _convertedAmount = 0.0;

  late Currency selectedCurrency;
  late Currency targetCurrency;
  bool _amountValidationError = false;


  @override
  void initState() {
    super.initState();
    selectedCurrency = _currencies[0];
    targetCurrency = _currencies[1];
  }

  @override
  Widget build(BuildContext context) {

    void convertCurrency() {
      setState(() {
        if (_amountController.text.isNotEmpty) {
          _convertedAmount = Currency.convert(
              double.parse(_amountController.text),
              selectedCurrency.code,
              targetCurrency.code
          );
          _amountValidationError = false;
        }else{
          _amountValidationError = true;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Currency Converter",
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.balance,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.transfer_within_a_station),
                  hintText: "Enter amount",
                  error:
                  Text(_amountValidationError ? "Please enter a valid amount": ""),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                onSubmitted: (String value) {
                  convertCurrency();
                },
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<Currency>(
                    value: selectedCurrency,
                    items: _currencies
                        .map<DropdownMenuItem<Currency>>(
                          (Currency currency) => DropdownMenuItem<Currency>(
                        value: currency,
                        child: Text("${currency.name} ${currency.code.name} ${currency.flag}"),
                      ),
                    ).toList(),
                    onChanged: (Currency? value) {
                      setState(() {
                        selectedCurrency = value!;
                      });
                    },
                  ),
                  DropdownButton<Currency>(
                    value: targetCurrency,
                    items: _currencies
                        .map<DropdownMenuItem<Currency>>(
                          (Currency currency) => DropdownMenuItem<Currency>(
                        value: currency,
                        child: Text("${currency.name} ${currency.code.name} ${currency.flag}"),
                      ),
                    ).toList(),
                    onChanged: (Currency? value) {
                      setState(() {
                        targetCurrency = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: convertCurrency,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                  ),
                  child: const Text(
                      "Convert",
                    style: TextStyle(color: Colors.white),
                  ),

                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.grey,
                  child: Center(
                      child: Text(
                        "${_amountController.text} ${selectedCurrency.code.name} = $_convertedAmount ${targetCurrency.code.name}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
