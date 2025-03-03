// import 'package:flutter/material.dart';

// import 'editprofile_view.dart';

// class MyProfileView extends StatelessWidget {
//   const MyProfileView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//           const Center(
//             child: CircleAvatar(
//               radius: 60,
//               backgroundImage: AssetImage(
//                   "assets/images/profile.jpg"), // Change to your image path
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             "Sandhya Nepal",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const Text("sandhyanepal54@gmail.com",
//               style: TextStyle(color: Colors.grey)),
//           const SizedBox(height: 20),

//           // Profile options
//           ListTile(
//             leading: const Icon(Icons.edit, color: Color(0xFF004AAD)),
//             title: const Text("Edit Profile"),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const EditProfileView()),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings, color: Color(0xFF004AAD)),
//             title: const Text("Settings"),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: const Icon(Icons.notifications, color: Color(0xFF004AAD)),
//             title: const Text("Notifications"),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: const Icon(Icons.help_outline, color: Color(0xFF004AAD)),
//             title: const Text("FAQ"),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: const Icon(Icons.info, color: Color(0xFF004AAD)),
//             title: const Text("About App"),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Color(0xFF004AAD)),
//             title: const Text("Logout"),
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }
