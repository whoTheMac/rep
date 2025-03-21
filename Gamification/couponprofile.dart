import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRewardsPage extends StatefulWidget {
  @override
  _UserRewardsPageState createState() => _UserRewardsPageState();
}

class _UserRewardsPageState extends State<UserRewardsPage> {
  List<String> couponCodes = []; // To store all the coupon codes
  bool isLoading = true; // To indicate loading state

  @override
  void initState() {
    super.initState();
    _fetchClaimedCoupons(); // Fetch the coupon codes when the page is loaded
  }

  // Function to fetch the claimed rewards from Supabase
  Future<void> _fetchClaimedCoupons() async {
    final user = Supabase.instance.client.auth.currentUser;
    String userEmail = user?.email ?? 'Anonymous';

    try {
      // Fetch the claimed rewards from Supabase using `select()` and handle the response directly
      final response = await Supabase.instance.client
          .from('claimed_rewards')
          .select('coupon_code')
          .eq('email', userEmail);

      // Check if response is not null and contains rows
      if (response != null && response.isNotEmpty) {
        setState(() {
          // Explicitly cast the response to List<String> by mapping it
          couponCodes = response
              .map<String>((item) => item['coupon_code'] as String) // Cast the coupon_code as String
              .toList();
          isLoading = false; // Set loading to false once data is fetched
        });
      } else {
        setState(() {
          couponCodes = []; // If no rewards are found, set it to an empty list
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Set loading to false in case of an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching rewards! Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent,title: Text('V O U C H E R S', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show a loading indicator
            : couponCodes.isEmpty
            ? Center(child: Text('You have not claimed any rewards yet.')) // If no rewards are found
            : ListView.builder(
          itemCount: couponCodes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Coupon Code: ${couponCodes[index]}', style:TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                subtitle: Text('Reward Claimed',  style: TextStyle(color: Color(0xFFad7b91), fontWeight: FontWeight.bold)),
                leading: Icon(Icons.card_giftcard, color: Color(0xFFad7b91),),
                tileColor:  Color(0xFFf4ebe2), // Customize tile color
                contentPadding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
