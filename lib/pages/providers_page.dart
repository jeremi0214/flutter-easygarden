import 'package:easygarden/components/my_home_button.dart';
import 'package:easygarden/components/provider_card.dart';
import 'package:easygarden/database/firestore.dart';
import 'package:easygarden/pages/provider_detail_page.dart';
import 'package:flutter/material.dart';

class ServiceProviderPage extends StatelessWidget {
  ServiceProviderPage({super.key});

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Service Providers"),
        leading: const BackButton(), 
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: MyHomeButton(),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const SizedBox(height: 10),

          // provider list data from firestore
          StreamBuilder(
            stream: database.getProvidersStream(), 
            builder: (context, snapshot) {
              // show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // get all providers
              final providers = snapshot.data!.docs;

              // no data?
              if (snapshot.data == null || providers.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("Sorry, there are NO available gardeners...")
                  ),
                );
              }

              // return as a list
              return Expanded(
                child: ListView.builder(
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    // get each individual provider
                    final provider = providers[index];
                    final data = provider.data() as Map<String, dynamic>;

                    // get data from each provider
                    final name = data['name'] ?? 'No name';
                    final contact = data['contact'] ?? 'No contact';
                    final email = data['email'] ?? 'No email';
                    final location = data['location'] ?? 'No location';
                    final services = data['services'] ?? '';

                    // return as a list tile
                    return ProviderCard(
                      name: name,
                      location: location,
                      services: services,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProviderDetailsPage(
                              name: name,
                              contact: contact,
                              email: email,
                              location: location,
                              services: services,
                            ),
                          ),
                        );
                      },
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