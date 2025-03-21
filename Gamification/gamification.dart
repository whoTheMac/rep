import 'package:flutter/material.dart';
import 'package:hadaf7/Gamification/rewa.dart';
import 'package:hadaf7/Gamification/trasurehunt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GamificationPage extends StatefulWidget {
  @override
  _GamificationPageState createState() => _GamificationPageState();
}

class _GamificationPageState extends State<GamificationPage> {
  bool task1Completed = false;
  bool task2Completed = false;
  bool task3Completed = false;
  bool task4Completed = false;

  final String task1Description = 'Try a traditional Arctic dish';
  final String task2Description = 'Participate in a local cleanup event';
  final String task3Description = 'Visit the arctic cathedral';
  final String task4Description = 'Watch the northern lights';

  void showCodeDialog(BuildContext context, String correctCode, int taskNumber) async {
    TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Code'),
          content: TextField(
            controller: codeController,
            decoration: InputDecoration(hintText: "Enter code"),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (codeController.text == correctCode) {
                  setState(() {
                    if (taskNumber == 1) {
                      task1Completed = true;
                    } else if (taskNumber == 2) {
                      task2Completed = true;
                    } else if (taskNumber == 3) {
                      task3Completed = true;
                    } else if (taskNumber == 4) {
                      task4Completed = true;
                    }
                  });

                  final user = Supabase.instance.client.auth.currentUser;
                  String userEmail = user?.email ?? 'Anonymous';

                  // Insert data into Supabase table
                  await Supabase.instance.client.from('task_completions').insert([
                    {
                      'email': userEmail,
                      'task_number': taskNumber,
                      'points': 25,
                    }
                  ]);

                  Navigator.of(context).pop(); // Close the code dialog

                  // Show the congratulatory popup dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(0xFFbfb699),
                        content: Container(
                          width: 500,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/girl.jpg',
                                width: 200,
                                height: 200,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Congrats! You earned 20 points.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the popup
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Incorrect code! Please try again.'),
                  ));
                  Navigator.of(context).pop(); // Close the code dialog
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the code dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> hasTaskBeenCompleted(String userEmail, int taskNumber) async {
    final response = await Supabase.instance.client
        .from('task_completions')
        .select()
        .eq('email', userEmail)
        .eq('task_number', taskNumber)
        .single();

    return response != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'G A M I F I C A T I O N',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width:189,
                    height: 250,
                    child: TaskContainer(
                      taskNumber: 1,
                      taskCompleted: task1Completed,
                      taskDescription: task1Description,
                      onDoneButtonPressed: () {
                        showCodeDialog(context, 'REWARD001', 1);
                      },
                      containerColor: Color(0xFFf4ebe2),
                      textColor: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(height:250,width:189,
                    child: TaskContainer(
                      taskNumber: 2,
                      taskCompleted: task2Completed,
                      taskDescription: task2Description,
                      onDoneButtonPressed: () {
                        showCodeDialog(context, 'REWARD002', 2);
                      },
                      containerColor: Color(0xFFe6d4c2),
                      textColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(height:250,width:189,
                    child: TaskContainer(
                      taskNumber: 3,
                      taskCompleted: task3Completed,
                      taskDescription: task3Description,
                      onDoneButtonPressed: () {
                        showCodeDialog(context, 'REWARD003', 3);
                      },
                      containerColor: Color(0xFFcbb197),
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(height:250,width:189,
                    child: TaskContainer(
                      taskNumber: 4,
                      taskCompleted: task4Completed,
                      taskDescription: task4Description,
                      onDoneButtonPressed: () {
                        showCodeDialog(context, 'REWARD004', 4);
                      },
                      containerColor: Color(0xFFa68563),
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Rewards Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClaimRewardsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown, // Brown background color
                  minimumSize: Size(500, 50), // Set the width to 500 and height to 50
                ),
                child: Text(
                  'SEE REWARDS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to the second page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TreasureHuntPage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://i.pinimg.com/474x/a4/b5/98/a4b59841bc965a2af1916a6713f4e3d8.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8, spreadRadius: 2),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          'TREASURE HUNT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskContainer extends StatelessWidget {
  final int taskNumber;
  final bool taskCompleted;
  final String taskDescription;
  final VoidCallback onDoneButtonPressed;
  final Color containerColor;
  final Color textColor;

  TaskContainer({
    required this.taskNumber,
    required this.taskCompleted,
    required this.taskDescription,
    required this.onDoneButtonPressed,
    required this.containerColor,
    required this.textColor,
  });

  Future<bool> hasTaskBeenCompleted(String userEmail, int taskNumber) async {
    final response = await Supabase.instance.client
        .from('task_completions')
        .select()
        .eq('email', userEmail)
        .eq('task_number', taskNumber)
        .single();

    return response != null;
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    String userEmail = user?.email ?? 'Anonymous';

    return FutureBuilder<bool>(
      future: hasTaskBeenCompleted(userEmail, taskNumber),
      builder: (context, snapshot) {
        bool taskCompletedInDB = snapshot.data ?? false;

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$taskNumber: $taskDescription',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    taskCompletedInDB || taskCompleted ? 'Task Completed' : 'Mark as done',
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: (taskCompletedInDB || taskCompleted) ? null : onDoneButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Points: 25',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
