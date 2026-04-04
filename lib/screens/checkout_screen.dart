import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/cart_state.dart';
import 'confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressField = TextEditingController();
  final _phoneField = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _placing = false;

  @override
  void dispose() {
    _addressField.dispose();
    _phoneField.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _placing = true);
    await Future.delayed(const Duration(seconds: 1)); // simulated network call

    final cart = context.read<CartState>();
    final orderTotal = cart.totalPrice;
    final itemCount = cart.totalItems;
    cart.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmationScreen(
          address: _addressField.text,
          phone: _phoneField.text,
          total: orderTotal,
          itemCount: itemCount,
        ),
      ),
          (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order summary',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...cart.items.map(
                    (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.product.name} x${item.quantity}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                      Text('\$${item.subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '\$${cart.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Delivery details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressField,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Delivery address',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v!.length < 10 ? 'Please enter your full address' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneField,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v!.length < 11 ? 'Enter a valid phone number' : null,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _placing ? null : _placeOrder,
                  child: _placing
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Place order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
