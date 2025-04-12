import 'package:flutter/material.dart';

void main() {
  runApp(TripGuideApp());
}

class TripGuideApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripGuide',
      home: TripGuideHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Destination {
  final String name;
  final String type;
  final String description;

  Destination({required this.name, required this.type, required this.description});
}

class TripGuideHome extends StatefulWidget {
  @override
  _TripGuideHomeState createState() => _TripGuideHomeState();
}

class _TripGuideHomeState extends State<TripGuideHome> {
  List<Destination> allDestinations = [
    Destination(name: 'Bali', type: 'Beach', description: 'A beautiful island paradise in Indonesia.'),
    Destination(name: 'Paris', type: 'City', description: 'The city of lights and love in France.'),
    Destination(name: 'Swiss Alps', type: 'Mountain', description: 'Snow-capped peaks and scenic train rides.'),
    Destination(name: 'Kyoto', type: 'City', description: 'Historic temples and cherry blossoms in Japan.'),
    Destination(name: 'Maldives', type: 'Beach', description: 'Crystal clear waters and luxury villas.'),
    Destination(name: 'Rocky Mountains', type: 'Mountain', description: 'Nature and hiking in North America.'),
  ];

  String selectedType = 'All';

  List<Destination> get filteredDestinations {
    if (selectedType == 'All') return allDestinations;
    return allDestinations.where((d) => d.type == selectedType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TripGuide'),
      ),
      body: Column(
        children: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedType,
              isExpanded: true,
              items: ['All', 'Beach', 'City', 'Mountain']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedType = value);
                }
              },
            ),
          ),

          // Destination List
          Expanded(
            child: ListView.builder(
              itemCount: filteredDestinations.length,
              itemBuilder: (context, index) {
                final dest = filteredDestinations[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    title: Text(dest.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${dest.type} • ${dest.description}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
