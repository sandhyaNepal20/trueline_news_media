import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:trueline_news_media/core/common/snackbar/my_snackbar.dart';
import 'package:trueline_news_media/features/home/presentation/view_model/home_cubit.dart';
import 'package:trueline_news_media/features/home/presentation/view_model/home_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Flag to prevent multiple logout triggers in quick succession.
  bool _isShakeDetected = false;
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  // Shake threshold can be adjusted based on testing.
  final double _shakeThreshold = 15.0;

  @override
  void initState() {
    super.initState();
    // Listen for accelerometer events.
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      // Calculate the magnitude of acceleration.
      double acceleration =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      // Check if acceleration exceeds threshold and a shake is not already detected.
      if (!_isShakeDetected && acceleration > _shakeThreshold) {
        _isShakeDetected = true;
        // Optionally, show a snack bar before logging out.
        showMySnackBar(
          context: context,
          message: 'Shake detected. Logging out...',
          color: Colors.red,
        );
        // Trigger logout via HomeCubit.
        context.read<HomeCubit>().logout(context);
        // Reset the shake flag after 2 seconds to allow further shakes.
        Future.delayed(const Duration(seconds: 2), () {
          _isShakeDetected = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 50,
              ),
              const SizedBox(width: 8),
              const Text(
                'Trueline News',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          // Logout Icon Button
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              showMySnackBar(
                context: context,
                message: 'Logging out...',
                color: Colors.red,
              );
              context.read<HomeCubit>().logout(context);
            },
          ),
          // Notifications Icon Button
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              color: Colors.white,
              onPressed: () {
                // Handle notification icon press.
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return state.views.elementAt(state.selectedIndex);
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.save),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            backgroundColor: const Color(0xFF004AAD),
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.white,
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<HomeCubit>().onTabTapped(index);
            },
          );
        },
      ),
    );
  }
}
