import 'package:flutter/material.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int selectedPlan = 0;

  final List<Map<String, String>> plans = [
    {
      'title': 'Monthly',
      'price': '₹99',
      'period': '/ month',
    },
    {
      'title': 'Yearly',
      'price': '₹799',
      'period': '/ year',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'SERENG Premium',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 35),
        child: Column(
          children: [
            // Premium header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF7C3AED),
                    Color(0xFFEC4899),
                  ],
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    size: 65,
                    color: Colors.white,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'SERENG Premium',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'More music. More freedom.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Premium Benefits',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 14),

            const PremiumFeature(
              icon: Icons.block,
              title: 'Ad-Free Music',
              subtitle: 'Enjoy music without interruptions',
            ),

            const PremiumFeature(
              icon: Icons.download_rounded,
              title: 'Offline Downloads',
              subtitle: 'Listen to your favorite songs offline',
            ),

            const PremiumFeature(
              icon: Icons.high_quality,
              title: 'High Quality Audio',
              subtitle: 'Enjoy better sound quality',
            ),

            const PremiumFeature(
              icon: Icons.all_inclusive,
              title: 'Unlimited Listening',
              subtitle: 'Listen without daily limits',
            ),

            const PremiumFeature(
              icon: Icons.workspace_premium,
              title: 'Premium Badge',
              subtitle: 'Show your Premium membership',
            ),

            const SizedBox(height: 28),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose your plan',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: List.generate(
                plans.length,
                (index) {
                  final plan = plans[index];
                  final isSelected = selectedPlan == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPlan = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index == 0 ? 7 : 0,
                          left: index == 1 ? 7 : 0,
                        ),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141419),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.white12,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    size: 17,
                                  ),
                                if (isSelected)
                                  const SizedBox(width: 5),
                                Text(
                                  plan['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              plan['price']!,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              plan['period']!,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // Subscribe button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showComingSoon();
                },
                icon: const Icon(
                  Icons.workspace_premium_rounded,
                ),
                label: Text(
                  'Get Premium • ${plans[selectedPlan]['price']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                _showComingSoon();
              },
              child: const Text(
                'Restore Purchase',
                style: TextStyle(
                  color: Colors.white60,
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Subscription payment will be connected later. '
              'You can cancel according to the applicable store '
              'subscription rules.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white30,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Payment system will be connected later.',
        ),
      ),
    );
  }
}

class PremiumFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const PremiumFeature({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141419),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF24202D),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.white54,
            size: 20,
          ),
        ],
      ),
    );
  }
}
