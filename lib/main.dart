import 'package:diversitree_mobile/components/header.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/views/WorkspaceInit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Diversitree());
}

class Diversitree extends StatefulWidget {
  const Diversitree({super.key});

  @override
  DiversitreeState createState() {
    return DiversitreeState();
  }
}

class DiversitreeState extends State<Diversitree> {
  String selectedValue = 'Semua';

  final List<Map<String, dynamic>> workspace = [
    {"judul": "Workspace A", "status": {"judul": "Inisiasi Workspace"}, "create_at": "2025-01-01"},
    {"judul": "Workspace B", "status": {"judul": "Menentukan Area"}, "create_at": "2025-01-02"},
    {"judul": "Workspace C", "status": {"judul": "Pemotretan Pohon"}, "create_at": "2025-01-03"},
    {"judul": "Workspace D", "status": {"judul": "Table Shannon Wanner"}, "create_at": "2025-01-04"},
    {"judul": "Workspace E", "status": {"judul": "Inisiasi Workspace"}, "create_at": "2025-01-05"},
    {"judul": "Workspace F", "status": {"judul": "Menentukan Area"}, "create_at": "2025-01-06"},
    {"judul": "Workspace G", "status": {"judul": "Pemotretan Pohon"}, "create_at": "2025-01-07"},
    {"judul": "Workspace H", "status": {"judul": "Table Shannon Wanner"}, "create_at": "2025-01-08"},
    {"judul": "Workspace I", "status": {"judul": "Inisiasi Workspace"}, "create_at": "2025-01-09"},
    {"judul": "Workspace J", "status": {"judul": "Menentukan Area"}, "create_at": "2025-01-10"},
  ];

  int currentPage = 1, lowerBoundIndex = 0, upperBoundIndex = 4;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diversitree App',
      home: Scaffold(
        appBar: header(),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Workspace',
                        style: TextStyle(
                          fontSize: 24, // Larger font size for the header
                          fontWeight: FontWeight.bold, // Bold text for emphasis
                          color: Colors.black54, // Text color
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Future.delayed(Duration(seconds: 1), () {
                            if (mounted) {  // Only navigate if the widget is still part of the widget tree
                              print("detected");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WorkspaceInit()),
                              );
                            } else {
                              print("not detected");
                            }
                          });
                        },
                        label: Text("Tambah"), icon: Icon(Icons.add, color: Colors.white),style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: bgColor,
                        foregroundColor: Colors.white
                      ),)
                    ],
                  ),

                  Text(
                    'Filter',
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedValue,
                    decoration: InputDecoration(
                    labelText: "Pilih Status", // Floating label
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded border
                      ),
                    ),
                    items: [
                      'Semua',
                      'Inisiasi Workspace',
                      'Menentukan Area',
                      'Pemotretan Pohon',
                      'Table Shannon Wanner'
                    ].map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = (newValue ?? "Semua");
                      });
                    },
                  ),
              
                  SizedBox(height: 20),
              
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Cari", // Floating label
                      suffixIcon: Icon(Icons.search), // Search icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded border
                      ),
                    ),
                  ),
              
                  SizedBox(height: 20),
              
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true, 
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: workspace.length,
                      itemBuilder: (context, index) {
                        if(index < lowerBoundIndex || index > upperBoundIndex ) return null;
                        return Card(
                          child: ListTile(
                            onTap: () {
                              //
                            },
                            leading: Image.network(
                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            trailing: const Icon(Icons.more_vert),
                            title: Text(workspace[index]["judul"] ?? "Tanpa Judul"), // Dynamic Title
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(workspace[index]["create_at"] ?? "-"), // Dynamic Subtitle 2
                                Text(workspace[index]["status"]["judul"] ?? "-"), // Dynamic Subtitle 1
                              ],
                            ),
                            tileColor: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
            
            
                ],
              ),
            ),

            // SizedBox(height: 50),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: bgColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your action here
                      },
                      child: Icon(Icons.arrow_left, color: bgColor),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Text(
                      '${lowerBoundIndex + 1}-${upperBoundIndex + 1} dari ${workspace.length}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add your action here
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WorkspaceInit()),
                        );
                      },
                      child: Icon(Icons.arrow_right, color: bgColor),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
