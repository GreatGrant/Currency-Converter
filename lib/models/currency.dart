class Currency{
  final CurrencyType code;
  final String name;
  final String flag;

  const Currency({
    required this.code,
    required this.name,
    required this.flag
  });

  static List<Currency> getCurrencies(){
    return [
      const Currency(code: CurrencyType.USD, name: 'US ', flag: '🇺🇸'),
      const Currency(code: CurrencyType.GBP, name: 'British ', flag: '🇬🇧'),
      const Currency(code: CurrencyType.CAD, name: 'Canadian ', flag: '🇨🇦'),
      const Currency(code: CurrencyType.NGN, name: 'Nigerian ', flag: '🇳🇬'),
    ];
  }

  static double convert(double amount, CurrencyType source, CurrencyType target){
    double exchangeRate = getExchangeRate(source, target);

    // Perform the conversion
    double convertedAmount = amount * exchangeRate;

    return convertedAmount;
  }

  static double getExchangeRate(CurrencyType source, CurrencyType target) {
    Map<CurrencyType, Map<CurrencyType, double>> exchangeRates = {
      CurrencyType.USD: {
        CurrencyType.GBP: 0.75,
        CurrencyType.CAD: 1.25,
        CurrencyType.NGN: 500,
      },
      CurrencyType.GBP: {
        CurrencyType.USD: 1.33,
        CurrencyType.CAD: 1.67,
        CurrencyType.NGN: 600,
      },
      CurrencyType.CAD: {
        CurrencyType.USD: 0.8,
        CurrencyType.GBP: 0.6,
        CurrencyType.NGN: 450,
      },
      CurrencyType.NGN: {
        CurrencyType.USD: 0.002,
        CurrencyType.GBP: 0.0017,
        CurrencyType.CAD: 0.0022,
      },
    };

    return exchangeRates[source]![target]!;
  }

}


enum CurrencyType{
  USD,
  GBP,
  CAD,
  NGN
}