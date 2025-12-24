import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import '../game/iap_manager.dart';

class ShopScreen extends StatefulWidget {
  final VoidCallback onClose;

  const ShopScreen({super.key, required this.onClose});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final _iapManager = GetIt.I<IAPManager>();
  final _goldManager = GetIt.I<GoldManager>();
  bool _isLoading = false;

  Future<void> _handlePurchase(
    String title,
    String productId,
    int? goldAmount,
  ) async {
    setState(() => _isLoading = true);

    try {
      final success = await _iapManager.purchaseProduct(productId);

      if (!mounted) return;

      if (success) {
        if (goldAmount != null) {
          _goldManager.addGold(goldAmount);
        } else if (productId == 'remove_ads') {
          await _iapManager.removeAds();
          if (!mounted) return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchased $title successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Purchase failed');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to purchase $title'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Shop', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: widget.onClose,
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_goldManager.currentGold}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Special Offers'),
                ListenableBuilder(
                  listenable: _iapManager,
                  builder: (context, _) {
                    if (_iapManager.isAdRemoved) {
                      return const SizedBox.shrink();
                    }
                    return _buildShopItem(
                      title: 'Remove Ads',
                      description: 'Play without interruptions!',
                      price: '\$4.99',
                      icon: Icons.block,
                      color: Colors.redAccent,
                      onTap: () =>
                          _handlePurchase('Remove Ads', 'remove_ads', null),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Coin Packs'),
                _buildShopItem(
                  title: 'Small Handful',
                  description: '1,000 Gold Coins',
                  price: '\$0.99',
                  icon: Icons.monetization_on_outlined,
                  color: Colors.amber,
                  onTap: () =>
                      _handlePurchase('Small Handful', 'coins_small', 1000),
                ),
                _buildShopItem(
                  title: 'Pouch of Gold',
                  description: '5,500 Gold Coins',
                  price: '\$4.99',
                  icon: Icons.savings,
                  color: Colors.orange,
                  isPopular: true,
                  onTap: () =>
                      _handlePurchase('Pouch of Gold', 'coins_medium', 5500),
                ),
                _buildShopItem(
                  title: 'Chest of Gold',
                  description: '12,000 Gold Coins',
                  price: '\$9.99',
                  icon: Icons.account_balance,
                  color: Colors.purple,
                  onTap: () =>
                      _handlePurchase('Chest of Gold', 'coins_large', 12000),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildShopItem({
    required String title,
    required String description,
    required String price,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isPopular = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isPopular ? Border.all(color: Colors.orange, width: 2) : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isPopular)
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'MOST POPULAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
