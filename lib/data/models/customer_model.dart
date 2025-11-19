class CustomerModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? imagePath;
  final double totalDue;
  final String? lastTransactionDate;
  var address;

  CustomerModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.imagePath,
    required this.totalDue,
    this.lastTransactionDate,
  });

  factory CustomerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerModel(
      id: json['Id'] ?? 0,
      name: json['Name'] ?? '',
      email: json['Email'],
      phone: json['Phone'],
      imagePath: json['ImagePath'],

      totalDue:
          (json['TotalDue'] as num?)?.toDouble() ?? 0.0,
      lastTransactionDate: json['LastTransactionDate'],
    );
  }
}
