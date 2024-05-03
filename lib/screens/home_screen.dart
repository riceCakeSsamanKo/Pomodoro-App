import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int settedSecond = 3;
  int totalSecond = settedSecond; // 25 min == 2500 sec
  int minute = settedSecond ~/ 60;
  int second = settedSecond % 60;

  late Timer timer; // late는 즉시 이 property를 초기화 하지는 않지만, 사용전에는 반드시 초기화를 하겠다는 의미.
  bool isRunning = false;

  int totalPomodoro = 0;

  String format(int totalSecond) {
    var duration = Duration(seconds: totalSecond);
    return duration.toString().split(".").first.substring(2, 7);
  }

  void onTick(Timer timer) {
    if (totalSecond == 0) {
      setState(() {
        totalSecond = settedSecond;
        minute = totalSecond ~/ 60; // ~/: 몫
        second = totalSecond % 60; // %: 나머지
        totalPomodoro += 1;
        onPausePressed();
      });
    } else {
      setState(() {
        totalSecond -= 1;
        minute = totalSecond ~/ 60; // ~/: 몫
        second = totalSecond % 60; // %: 나머지
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1), // 1초마다
      onTick, // onTick 메서드를 실행함.
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel(); // 타이머 멈춤
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    onPausePressed();
    setState(() {
      totalSecond = settedSecond;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          const SizedBox(
            height: 58,
          ),
          Flexible(
            // Flexible: 하드 코딩해야하는 값을 비율(flex)로 간단하게 표시 가능
            flex: 1,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 13,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CurrentTime(),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    format(totalSecond),
                    style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontSize: 89,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 120,
                    onPressed: isRunning ? onPausePressed : onStartPressed,
                    color: Theme.of(context).cardColor,
                    icon: Icon(isRunning
                        ? Icons.pause_circle_filled_outlined
                        : Icons.play_circle_outline_outlined),
                  ),
                  IconButton(
                    onPressed: resetTimer,
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    icon: const Icon(Icons.restore_rounded),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  // 전체 화면으로 확장
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pomodoros",
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.backgroundColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Text("$totalPomodoro",
                            style: const TextStyle(
                                fontSize: 60, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentTime extends StatelessWidget {
  const CurrentTime({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(
          width: 3.0,
          color: Theme.of(context).cardColor,
        ),
        color: Colors.transparent, // 투명색
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: TimerBuilder.periodic(
          const Duration(seconds: 1),
          builder: (context) {
            return Text(
              formatDate(DateTime.now(), [hh, ':', nn, ':', ss, ' ', am]),
              style: TextStyle(
                color: Theme.of(context).cardColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ),
    );
  }
}
