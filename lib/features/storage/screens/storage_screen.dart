import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/models/storage_location.dart';
import '../../../data/repositories/storage_location_repository.dart';
import '../../../widgets/season_box_app_bar.dart';
import '../../../widgets/app_card.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  List<StorageLocation> _locations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    try {
      const familyId = 'test-family-id';
      final locations = await context
          .read<StorageLocationRepository>()
          .getLocations(familyId)
          .timeout(const Duration(seconds: 5));
      if (mounted) {
        setState(() {
          _locations = locations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading storage locations: $e')),
        );
      }
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'box':
        return Icons.inventory_2;
      case 'closet':
        return Icons.door_sliding;
      case 'area':
        return Icons.garage;
      case 'shelf':
        return Icons.shelves;
      default:
        return Icons.storage;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'box':
        return Colors.orange;
      case 'closet':
        return Colors.teal;
      case 'area':
        return Colors.indigo;
      case 'shelf':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const SeasonBoxAppBar(
        title: 'Storage',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _locations.isEmpty
              ? const Center(
                  child: Text('No storage locations added yet'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _locations.length,
                  itemBuilder: (context, index) {
                    final location = _locations[index];
                    final color = _getColorForType(location.type);
                    final icon = _getIconForType(location.type);

                    return AppCard(
                      onTap: () {
                        // TODO: Navigate to storage detail
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon, color: color, size: 32),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Type: ${location.type}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                if (location.description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    location.description,
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('/add-storage-location').then((_) => _loadLocations()),
        backgroundColor: const Color(0xFF6200EE),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
