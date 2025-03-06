// import 'package:flutter/material.dart';

// class NewsDetailsScreen extends StatelessWidget {
//   const NewsDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Details Screen"),
//         backgroundColor: Colors.blueAccent,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // News Image
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: Image.asset(
//                   'assets/images/news1.jpg',
//                   width: double.infinity,
//                   height: 250,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // News Title
//               const Text(
//                 "Prime Minister Oli, Foreign Minister Deuba brief President Paudel on China visit",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 5),

//               // Published Date
//               const Text(
//                 "Published on: November 30, 2024 | 19:33",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // News Content
//               const Text(
//                 "Prime Minister KP Sharma Oli and Foreign Minister Arzu Rana Deuba briefed President Ramchandra Paudel on the prime minister’s upcoming visit to China during a meeting at Sheetal Niwas on Saturday evening.\n\n"
//                 "During the meeting, Prime Minister Oli informed the President about his planned visit to the northern neighbour, according to the prime minister’s secretariat.\n\n"
//                 "Prime Minister Oli is scheduled to visit China from December 2-5 at the invitation of his Chinese counterpart Li Qian.\n\n"
//                 "The visit is expected to focus on the implementation of past agreements and signing new deals under the Belt and Road Initiative (BRI), among other bilateral matters.",
//                 style: TextStyle(fontSize: 16, height: 1.5),
//               ),
//               const SizedBox(height: 20),

//               // Like & Comment Section
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.thumb_up, color: Colors.blueAccent),
//                       SizedBox(width: 5),
//                       Text("1.2K"),
//                     ],
//                   ),
//                   Icon(Icons.share, color: Colors.black54),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Comment Box
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: "Type your comment here...",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.send, color: Colors.blueAccent),
//                     onPressed: () {},
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
