
class Wallet {
  int? id;
  String name;
  double balance;
  String currency;

  Wallet({
    this.id,
    required this.name,
    required this.balance,
    required this.currency,
  });

  factory Wallet.fromMap(Map<String, dynamic> json) => Wallet(
    id: json['id'],
    name: json['name'],
    balance: json['balance'],
    currency: json['currency'],
  );

  Map<String,dynamic> toMap()=>{
    'id': id,
    'name': name,
    'balance': balance,
    'currency': currency,
  };
}
