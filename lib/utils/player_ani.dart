import 'package:flutter/material.dart';

class PlayerAni extends StatefulWidget {
  final int duration;
  final Color color;
  final bool? height;

  const PlayerAni(
      {Key? key, required this.duration, required this.color, this.height})
      : super(key: key);

  @override
  _PlayerAniState createState() => _PlayerAniState();
}

class _PlayerAniState extends State<PlayerAni>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.decelerate,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    animationController.repeat(reverse: true);
  }

  void stopAnimation() {
    animationController.stop();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.height! ? 5 : 10,
      height: widget.height! ? animation.value / 2 : animation.value,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class MusicVisualizer extends StatelessWidget {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.yellowAccent,
  ];
  List<int> duration = [900, 700, 600, 800, 500];
  bool? height;

  MusicVisualizer({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(
          10,
          (index) => PlayerAni(
                duration: duration[index % 5],
                color: colors[index % 4],
                height: height,
              )),
    );
  }
}
