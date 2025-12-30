import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import '../../../data/models/storage_location.dart';
import '../../../data/repositories/storage_location_repository.dart';
import '../../../features/auth/data/auth_service.dart';
import '../../../widgets/season_box_app_bar.dart';
import '../../../core/services/label_service.dart';

class PrintLabelsScreen extends StatefulWidget {
  const PrintLabelsScreen({super.key});

  @override
  State<PrintLabelsScreen> createState() => _PrintLabelsScreenState();
}

class _PrintLabelsScreenState extends State<PrintLabelsScreen> {
  List<StorageLocation> _locations = [];
  Set<String> _selectedIds = {};
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    try {
      final authService = context.read<AuthService>();
      final familyId = await authService.getCurrentUserFamilyId();
      if (familyId == null) throw Exception('No family ID found');

      if (!mounted) return;
      final locations = await context
          .read<StorageLocationRepository>()
          .getLocations(familyId);
      if (mounted) {
        setState(() {
          _locations = locations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading storage locations: $e')),
        );
      }
    }
  }

  void _toggleSelection(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  void _toggleAll(bool select) {
    setState(() {
      if (select) {
        _selectedIds = _locations.map((l) => l.id).toSet();
      } else {
        _selectedIds.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Build hierarchy map
    final Map<String?, List<StorageLocation>> childrenMap = {};
    for (var l in _locations) {
      childrenMap.putIfAbsent(l.parentId, () => []).add(l);
    }

    final topLevel = childrenMap[null] ?? [];
    topLevel
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return Scaffold(
      appBar: SeasonBoxAppBar(
        title: l10n.printLabels_title,
        actions: [
          TextButton(
            onPressed: () =>
                _toggleAll(_selectedIds.length < _locations.length),
            child: Text(
              _selectedIds.length < _locations.length
                  ? l10n.printLabels_selectAll
                  : l10n.printLabels_deselectAll,
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.printLabels_searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: topLevel
                        .map((l) => _buildHierarchicalItem(l, childrenMap, 0))
                        .toList(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedIds.isEmpty
                    ? null
                    : () {
                        final selectedLocations = _locations
                            .where((l) => _selectedIds.contains(l.id))
                            .toList();
                        LabelService.printLabels(selectedLocations);
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l10n.printLabels_printButton(_selectedIds.length)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHierarchicalItem(StorageLocation location,
      Map<String?, List<StorageLocation>> childrenMap, int level) {
    final children = childrenMap[location.id] ?? [];
    children
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final isSelected = _selectedIds.contains(location.id);
    final query = _searchController.text.toLowerCase();

    // If searching, hide items that don't match AND don't have children that match
    if (query.isNotEmpty) {
      final matchesSelf = location.name.toLowerCase().contains(query) ||
          location.type.toLowerCase().contains(query);
      bool hasMatchingChild = false;

      void checkChildren(String id) {
        for (var child in (childrenMap[id] ?? [])) {
          if (child.name.toLowerCase().contains(query) ||
              child.type.toLowerCase().contains(query)) {
            hasMatchingChild = true;
            return;
          }
          checkChildren(child.id);
        }
      }

      checkChildren(location.id);

      if (!matchesSelf && !hasMatchingChild) return const SizedBox.shrink();
    }

    return Column(
      children: [
        CheckboxListTile(
          value: isSelected,
          onChanged: (val) => _toggleSelection(location.id, val),
          title: Text(location.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(location.type),
          secondary: Padding(
            padding: EdgeInsets.only(left: 16.0 * level),
            child: Icon(_getIconForType(location.type),
                color: _getColorForType(location.type)),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        if (children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: children
                  .map((c) => _buildHierarchicalItem(c, childrenMap, level + 1))
                  .toList(),
            ),
          ),
      ],
    );
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
        return Colors.blue;
      case 'closet':
        return Colors.green;
      case 'area':
        return Colors.purple;
      case 'shelf':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
