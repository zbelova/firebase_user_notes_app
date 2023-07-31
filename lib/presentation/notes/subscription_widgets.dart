import 'dart:async';

import 'package:flutter/material.dart';

class PremiumTimerWidget extends StatefulWidget {
  final int start;
  final Function onTimerEnd;

  const PremiumTimerWidget({super.key, required this.start, required this.onTimerEnd});

  @override
  State<PremiumTimerWidget> createState() => _PremiumTimerWidgetState();
}

class _PremiumTimerWidgetState extends State<PremiumTimerWidget> {
  int _current = 0;
  Timer? _timer;

  int get _start => widget.start;

  void startTimer() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(
      duration,
      (Timer timer) => setState(() {
        if (_current <= 0) {
          timer.cancel();
          widget.onTimerEnd();
        } else {
          _current--;
        }
      }),
    );
  }

  void resetTimer() {
    _timer!.cancel();
    setState(() {
      _current = _start;
    });
  }

  @override
  void initState() {
    super.initState();
    _current = _start;
    startTimer();
  }

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xfffdc40c),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                'Premium подписка истекает через: ',
              ),
              Text(
                '$_current секунд',
                style: const TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivateSubscriptionWidget extends StatelessWidget {
  const ActivateSubscriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

