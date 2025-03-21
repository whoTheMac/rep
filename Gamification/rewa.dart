import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClaimRewardsPage extends StatefulWidget {
  @override
  _ClaimRewardsPageState createState() => _ClaimRewardsPageState();
}

class _ClaimRewardsPageState extends State<ClaimRewardsPage> {
  final TextEditingController _codeController = TextEditingController();
  final List<Map<String, String>> rewards = [
    {'reward_number': '1', 'description': 'Reward 1: Free ride', 'coupon_code': 'REWARD001'},
    {'reward_number': '2', 'description': 'Reward 2: 5% off on next booking', 'coupon_code': 'REWARD002'},
    {'reward_number': '3', 'description': 'Reward 3: Free Service', 'coupon_code': 'REWARD003'},
    {'reward_number': '4', 'description': 'Reward 4: Cashback', 'coupon_code': 'REWARD004'},
  ];

  Future<bool> _hasClaimedReward(int rewardNumber) async {
    final user = Supabase.instance.client.auth.currentUser;
    String userEmail = user?.email ?? 'Anonymous';

    final response = await Supabase.instance.client
        .from('claimed_rewards')
        .select('reward_number')
        .eq('email', userEmail)
        .eq('reward_number', rewardNumber)
        .single();

    return response != null;
  }

  void _showClaimDialog(int rewardNumber, String couponCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Code'),
          content: TextField(
            controller: _codeController,
            decoration: InputDecoration(hintText: "Enter code"),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (_codeController.text == couponCode) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(0xFFbfb699),
                        title: Text('Reward Claimed'),
                        content: Container(
                          width: 500,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/girl2.jpg'),
                              Text('You have claimed the reward!'),
                              Text('Coupon Code: $couponCode'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              final user = Supabase.instance.client.auth.currentUser;
                              String userEmail = user?.email ?? 'Anonymous';

                              await Supabase.instance.client.from('claimed_rewards').insert([
                                {
                                  'email': userEmail,
                                  'reward_number': rewardNumber,
                                  'coupon_code': couponCode,
                                }
                              ]);

                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context).pop(); // Close the code input dialog
                            },
                            child: Text('Claim Voucher'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Incorrect code! Please try again.')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'C L A I M  R E W A R D S',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: rewards.length,
          itemBuilder: (context, index) {
            final reward = rewards[index];
            final rewardNumber = int.parse(reward['reward_number']!);

            // Color list for each container
            final List<Color> containerColors = [
              Color(0xFFf4ebe2), // First container - pink
              Color(0xFFe6d4c2), // Second container - green
              Color(0xFFcbb197), // Third container - yellow
              Color(0xFFa68563), // Fourth container - white
            ];

            return FutureBuilder<bool>(
              future: _hasClaimedReward(rewardNumber),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Replace the CircularProgressIndicator with a custom loading message
                  return Center(
                    child: Text('Loading, please wait...', style: TextStyle(color: Colors.grey, fontSize: 18)),
                  );
                }

                final hasClaimed = snapshot.data ?? false;
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: containerColors[index], // Use the color based on index
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(reward['description']!, style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Reward: ${reward['reward_number']}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: hasClaimed
                            ? null
                            : () => _showClaimDialog(rewardNumber, reward['coupon_code']!),
                        child: Text('Claim Reward', style: TextStyle(color: Colors.brown)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, // Grey background
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
