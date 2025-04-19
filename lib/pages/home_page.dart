import 'package:easygarden/components/my_drawer.dart';
import 'package:easygarden/components/my_list_tile.dart';
import 'package:easygarden/database/firestore.dart';
import 'package:easygarden/pages/job_detail_page.dart';
import 'package:easygarden/pages/job_post_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("AVAILABLE JOBS"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the JobPostScreen when FAB is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobPostPage()),
          );
        },
        tooltip: "Post a New Job",
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: Column(
        children: [
          // job list data from firestore
          StreamBuilder(
            stream: database.getJobsStream(), 
            builder: (context, snapshot) {
              // show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // get all posts
              final jobs = snapshot.data!.docs;

              // no data?
              if (snapshot.data == null || jobs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("Sorry, there are NO available jobs...")
                  ),
                );
              }

              // return as a list
              return Expanded(
                child: ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    // get each individual post
                    final job = jobs[index];
                    final data = job.data() as Map<String, dynamic>;

                    // get data from each post
                    final title = data['title'] ?? 'No Title';
                    final description = data['description'] ?? '';
                    final location = data['location'] ?? '';
                    final budget = data['budget'] ?? '';
                    final contact = data['contact'] ?? '';

                    // return as a list tile
                    return MyListTile(
                      title: title,
                      location: location,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailsPage(
                              title: title,
                              description: description,
                              location: location,
                              budget: budget,
                              contact: contact,
                            ),
                          ),
                        );
                      }
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}