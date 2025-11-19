import 'package:flutter/material.dart';
import '../../data/models/customer_model.dart';
import '../../utils/app_constants.dart';

class CustomerDetailScreen extends StatelessWidget {
  final CustomerModel customer;

  const CustomerDetailScreen({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        (customer.imagePath != null &&
            customer.imagePath!.isNotEmpty)
        ? "${ApiConstants.imageBase}${customer.imagePath}"
        : "";

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text("Customer Details")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 32,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Hero(
                    tag: 'customer_image_${customer.id}',
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) =>
                                        _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    customer.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (customer.email != null &&
                      customer.email!.isNotEmpty)
                    Text(
                      customer.email!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDetailCard(
                    Icons.phone,
                    "Phone",
                    customer.phone ?? "N/A",
                  ),
                  _buildDetailCard(
                    Icons.location_on,
                    "Address",
                    customer.address ?? "N/A",
                  ),
                  _buildDetailCard(
                    Icons.attach_money,
                    "Total Due",
                    "\$${customer.totalDue.toStringAsFixed(2)}",
                    isHighlighted: true,
                  ),
                  _buildDetailCard(
                    Icons.calendar_today,
                    "Last Transaction",
                    customer.lastTransactionDate ?? "N/A",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Icon(
        Icons.person,
        size: 60,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildDetailCard(
    IconData icon,
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isHighlighted
                ? Colors.red.shade50
                : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isHighlighted ? Colors.red : Colors.blue,
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isHighlighted
                ? Colors.red
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}
