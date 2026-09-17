class Transactions {
  int? id;
  double amount;
  String note;
  DateTime date;
  String type;
  String? categoryName;
  String? categoryIcon;
  int categoryId;
  int walletId;

  Transactions({
    this.id,
    required this.amount,
    required this.note,
    required this.date,
    required this.type,
     this.categoryName,
     this.categoryIcon,
    required this.categoryId,
    required this.walletId,
  });

  factory Transactions.fromMap(Map<String, dynamic> json) => Transactions(
    id: json['id'],
    amount: json['amount'],
    note: json['note'],
    date: DateTime.parse(json['date']),
    type: json['type'],
    categoryName: json['categoryName'],
    categoryIcon: json['categoryIcon'],
    categoryId: json['categoryId'],
    walletId: json['walletId'],
  );
  
  Map<String,dynamic> toMap() =>{
    'id': id,
    'amount': amount,
    'note': note,
    'date': date.toIso8601String(),
    'type': type,
    'categoryName': categoryName,
    'categoryIcon': categoryIcon,
    'categoryId': categoryId,
    'walletId': walletId,
  };
}
