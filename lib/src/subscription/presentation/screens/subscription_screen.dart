
import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seasonal Subscriptions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          SubscriptionCard(
            season: 'Spring',
            description: 'Fresh scents and vibrant colors to welcome the new season.',
            image: 'assets/images/spring.jpg',
          ),
          SubscriptionCard(
            season: 'Summer',
            description: 'Everything you need for fun in the sun.',
            image: 'assets/images/summer.jpg',
          ),
          SubscriptionCard(
            season: 'Autumn',
            description: 'Cozy up with warm and comforting essentials.',
            image: 'assets/images/autumn.jpg',
          ),
          SubscriptionCard(
            season: 'Winter',
            description: 'Stay warm and festive with our winter collection.',
            image: 'assets/images/winter.jpg',
          ),
        ],
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String season;
  final String description;
  final String image;

  const SubscriptionCard({
    super.key,
    required this.season,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Image.asset(
            image,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 50),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  season,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8.0),
                Text(description),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Subscribe'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
