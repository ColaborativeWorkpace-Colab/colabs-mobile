import 'package:flutter/material.dart';

class ProjectVersionListView extends StatefulWidget {
  final List<String> files;
  const ProjectVersionListView({super.key, required this.files});

  @override
  ProjectVersionListViewState createState() => ProjectVersionListViewState();
}

class ProjectVersionListViewState extends State<ProjectVersionListView> {
  final List<Widget> _listItems = <Widget>[];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _loadItems();
  }

  void _loadItems() {
    Future<void>(() async {
      for (int i = 0; i < widget.files.length; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 80), () {
          _listItems.add(SizedBox(
              height: 50,
              width: 65,
              child: Row(children: <Widget>[
                (widget.files.length - 1 == i)
                    ? CustomPaint(
                        painter: _SemiCirclePainter(const Color(0xff5521B5)),
                        child: const CircleAvatar(radius: 20))
                    : const CircleAvatar(
                        radius: 15,
                      ),
                (widget.files.length - 1 != i)
                    ? const Icon(Icons.arrow_right)
                    : const SizedBox()
              ])));
          _listKey.currentState?.insertItem(_listItems.length - 1);
        });
      }
    }).whenComplete(() {
      if (scrollController.hasClients == true) {
        scrollController.animateTo(widget.files.length * 65,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInExpo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 50,
      color: Colors.transparent,
      width: screenWidth,
      child: AnimatedList(
          key: _listKey,
          controller: scrollController,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(top: 10),
          initialItemCount: _listItems.length,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) {
            return SlideTransition(
                position:
                    CurvedAnimation(curve: Curves.easeOut, parent: animation)
                        .drive(Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: const Offset(0, 0))),
                child: _listItems[index]);
          }),
    );
  }
}

class _SemiCirclePainter extends CustomPainter {
  final Color color;

  _SemiCirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    Path path = Path()
      ..lineTo(0, radius)
      ..arcToPoint(
        Offset(size.width, radius),
        radius: Radius.circular(radius),
      )
      ..quadraticBezierTo(
          size.width, size.height - 3, size.width + 3, size.height)
      ..lineTo(-3, size.height)
      ..quadraticBezierTo(-3, size.height, 0, size.height - 7)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
