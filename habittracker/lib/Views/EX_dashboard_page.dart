import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habittracker/Views/profile_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, int> categories = {
    'Habits': 12,
    'Meditation': 5,
    'Reading': 9,
    'Daily stuff': 25,
  };

  double progressBar1 = 0.7;
  double progressBar2 = 0.6;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      QuerySnapshot categorySnapshot =
      await _firestore.collection('categories').get();

      if (categorySnapshot.docs.isNotEmpty) {
        Map<String, int> loadedCategories = {};
        for (var doc in categorySnapshot.docs) {
          loadedCategories[doc['name']] = doc['activities'];
        }

        setState(() {
          categories = loadedCategories;
        });
      }

      DocumentSnapshot progressSnapshot =
      await _firestore.collection('progress').doc('weekly').get();

      if (progressSnapshot.exists) {
        setState(() {
          progressBar1 = progressSnapshot['bar1'] ?? 0.7;
          progressBar2 = progressSnapshot['bar2'] ?? 0.6;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('My Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            //functionality ig
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality ig
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weekly status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progressBar1,
                      backgroundColor: Colors.blue[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progressBar2,
                      backgroundColor: Colors.blue[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                      minHeight: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Categories grid
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16.0),
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                ...categories.entries.map((entry) =>
                    CategoryTile(
                      title: entry.key,
                      count: entry.value,
                      onTap: () => _navigateToCategoryDetail(entry.key),
                    ),
                ).toList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddActivityDialog(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _navigateToCategoryDetail(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailScreen(
          category: category,
          activitiesCount: categories[category] ?? 0,
        ),
      ),
    );
  }

  void _showAddActivityDialog() {
    String selectedCategory = categories.keys.first;
    String activityName = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.keys.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                selectedCategory = value!;
              },
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ),
            TextField(
              onChanged: (value) {
                activityName = value;
              },
              decoration: const InputDecoration(
                labelText: 'Activity Name',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (activityName.isNotEmpty) {
                _addActivity(selectedCategory, activityName);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addActivity(String category, String activityName) async {
    try {
      await _firestore.collection('activities').add({
        'category': category,
        'name': activityName,
        'completed': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      int currentCount = categories[category] ?? 0;
      await _firestore.collection('categories')
          .doc(category.toLowerCase().replaceAll(' ', '_'))
          .set({
        'name': category,
        'activities': currentCount + 1,
      });

      setState(() {
        categories[category] = (categories[category] ?? 0) + 1;
      });
    } catch (e) {
      print('Error adding activity: $e');
    }
  }
}

class CategoryTile extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onTap;

  const CategoryTile({
    Key? key,
    required this.title,
    required this.count,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$count activities',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryDetailScreen extends StatefulWidget {
  final String category;
  final int activitiesCount;

  const CategoryDetailScreen({
    Key? key,
    required this.category,
    required this.activitiesCount,
  }) : super(key: key);

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late Stream<QuerySnapshot> _activitiesStream;

  @override
  void initState() {
    super.initState();
    _activitiesStream = FirebaseFirestore.instance
        .collection('activities')
        .where('category', isEqualTo: widget.category)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${widget.activitiesCount} activities',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _activitiesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No activities yet. Add some!'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    bool isCompleted = data['completed'] ?? false;

                    return ListTile(
                      title: Text(
                        data['name'] ?? 'Unnamed Activity',
                        style: TextStyle(
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      leading: Checkbox(
                        value: isCompleted,
                        onChanged: (_) => _toggleActivityStatus(doc.id, isCompleted),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteActivity(doc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddActivityDialog(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey[400],
      ),
    );
  }

  Future<void> _toggleActivityStatus(String docId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('activities')
          .doc(docId)
          .update({'completed': !currentStatus});

      _updateWeeklyProgress();
    } catch (e) {
      print('Error toggling activity status: $e');
    }
  }

  Future<void> _deleteActivity(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('activities')
          .doc(docId)
          .delete();

      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.category.toLowerCase().replaceAll(' ', '_'))
          .update({
        'activities': FieldValue.increment(-1),
      });

      _updateWeeklyProgress();
    } catch (e) {
      print('Error deleting activity: $e');
    }
  }

  Future<void> _updateWeeklyProgress() async {
    try {
      QuerySnapshot allActivities = await FirebaseFirestore.instance
          .collection('activities')
          .where('category', isEqualTo: widget.category)
          .get();

      QuerySnapshot completedActivities = await FirebaseFirestore.instance
          .collection('activities')
          .where('category', isEqualTo: widget.category)
          .where('completed', isEqualTo: true)
          .get();

      double completionRatio = allActivities.docs.isEmpty
          ? 0.0
          : completedActivities.docs.length / allActivities.docs.length;

      if (widget.category == 'Habits' || widget.category == 'Meditation') {
        await FirebaseFirestore.instance
            .collection('progress')
            .doc('weekly')
            .update({
          'bar1': completionRatio,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('progress')
            .doc('weekly')
            .update({
          'bar2': completionRatio,
        });
      }
    } catch (e) {
      print('Error updating progress: $e');
    }
  }

  void _showAddActivityDialog() {
    String activityName = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New ${widget.category} Activity'),
        content: TextField(
          onChanged: (value) {
            activityName = value;
          },
          decoration: const InputDecoration(
            labelText: 'Activity Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (activityName.isNotEmpty) {
                _addActivity(activityName);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addActivity(String activityName) async {
    try {
      // Add to Firestore
      await FirebaseFirestore.instance.collection('activities').add({
        'category': widget.category,
        'name': activityName,
        'completed': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update category count
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.category.toLowerCase().replaceAll(' ', '_'))
          .update({
        'activities': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error adding activity: $e');
    }
  }
}