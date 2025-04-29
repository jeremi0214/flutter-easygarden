import 'package:easygarden/components/ad_banner.dart';
import 'package:easygarden/components/my_drawer.dart';
import 'package:easygarden/components/job_list_card.dart';
import 'package:easygarden/database/firestore.dart';
import 'package:easygarden/pages/job_detail_page.dart';
import 'package:easygarden/pages/job_post_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firestore access
  final FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    FocusScope.of(context).unfocus(); // Hide keyboard
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

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

      body: Column(
        children: [
          // Search bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title or location...',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
              ),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: _performSearch,
                ),
              ),
            ],
          ),

          // Job list
          Expanded(
            child: StreamBuilder(
              stream: database.getJobsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final jobs = snapshot.data?.docs ?? [];

                final trimmedQuery = _searchQuery.trim();
                final filteredJobs = trimmedQuery.isEmpty
                    ? jobs
                    : jobs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final title = data['title']?.toString().toLowerCase() ?? '';
                        final location = data['location']?.toString().toLowerCase() ?? '';
                        return title.contains(trimmedQuery) || location.contains(trimmedQuery);
                      }).toList();

                if (filteredJobs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text("No jobs found matching your search."),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job count
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text(
                        "${filteredJobs.length} job${filteredJobs.length == 1 ? '' : 's'} listed",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),

                    // Job list
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredJobs.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final job = filteredJobs[index];
                          final data = job.data() as Map<String, dynamic>;

                          final title = data['title'] ?? 'No Title';
                          final description = data['description'] ?? '';
                          final location = data['location'] ?? '';
                          final budget = data['budget'] ?? '';
                          final contact = data['contact'] ?? '';

                          return JobListCard(
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
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JobPostPage()),
          );
        },
        tooltip: "Post a New Job",
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Ad banner at the bottom (using bottomNavigationBar)
      bottomNavigationBar: const ImageAdBanner(
        imagePath: 'assets/garden_box_logo.png',
        targetUrl: 'https://www.gardenbox.co.nz/',
      ),
    );
  }
}