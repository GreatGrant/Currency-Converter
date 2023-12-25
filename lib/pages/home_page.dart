import 'package:flutter/material.dart';
import 'package:currency_converter/models/currency.dart';

class CurrencyInput extends StatelessWidget {
  final TextEditingController controller;
  final bool hasError;
  final Function(String) onSubmitted;

  const CurrencyInput({super.key, required this.controller, required this.hasError, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.transfer_within_a_station),
        labelText: "Enter amount",
        error: Text(hasError ? "Please enter a valid amount" : ""),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        focusColor: Colors.deepPurpleAccent,
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(color: Colors.red)),
      ),
      onSubmitted: onSubmitted,
    );
  }
}

class CurrencyDropdown extends StatelessWidget {
  final List<Currency> currencies;
  final Currency selectedCurrency;
  final Function(Currency?) onChanged;

  const CurrencyDropdown({super.key, required this.currencies, required this.selectedCurrency, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Currency>(
      value: selectedCurrency,
      items: currencies
          .map<DropdownMenuItem<Currency>>(
            (Currency currency) => DropdownMenuItem<Currency>(
          value: currency,
          child: Text("${currency.code.name} ${currency.flag}"),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class ConversionResult extends StatelessWidget {
  final String amount;
  final double convertedAmount;
  final Currency selectedCurrency;
  final Currency targetCurrency;

  const ConversionResult(
      {
        super.key, required this.amount,
        required this.convertedAmount,
        required this.selectedCurrency,
        required this.targetCurrency
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: 50,
        width: double.infinity,
        color: Colors.grey,
        child: Center(
          child: Text(
            "$amount ${selectedCurrency.code.name} = $convertedAmount ${targetCurrency.code.name}",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CurrencyConverterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CurrencyConverterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor:  Colors.white,
          minimumSize: const Size(double.infinity, 40),
        ),
        child:  const Text("Convert")
    );
  }
}

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

  void convertCurrency() {
    setState(() {
      if (_amountController.text.isNotEmpty) {
        _convertedAmount = Currency.convert(
            double.parse(_amountController.text), selectedCurrency.code, targetCurrency.code);
        _amountValidationError = false;
      } else {
        _amountValidationError = true;
      }
    });
  }

  void swapCurrencies(){
    setState(() {
      final temp = selectedCurrency;
      selectedCurrency = targetCurrency;
      targetCurrency = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              CurrencyInput(
                controller: _amountController,
                hasError: _amountValidationError,
                onSubmitted: (String value) {
                  convertCurrency();
                },
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CurrencyDropdown(
                    currencies: _currencies,
                    selectedCurrency: selectedCurrency,
                    onChanged: (Currency? value) {
                      setState(() {
                        if(value == targetCurrency){
                          swapCurrencies();
                        }else{
                          selectedCurrency = value!;
                        }

                      });
                    },
                  ),
                  IconButton(
                      onPressed: swapCurrencies,
                      icon: const Icon(Icons.swap_horiz)
                  ),
                  CurrencyDropdown(
                    currencies: _currencies,
                    selectedCurrency: targetCurrency,
                    onChanged: (Currency? value) {
                      setState(() {
                        if(value == selectedCurrency){
                          swapCurrencies();
                        }else{
                          targetCurrency = value!;
                        }

                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CurrencyConverterButton(
                onPressed: convertCurrency,
              ),
              const SizedBox(height: 10),
              ConversionResult(
                amount: _amountController.text,
                convertedAmount: _convertedAmount,
                selectedCurrency: selectedCurrency,
                targetCurrency: targetCurrency,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
