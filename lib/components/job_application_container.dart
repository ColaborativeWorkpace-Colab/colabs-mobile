import 'package:flutter/material.dart';

class JobApplicationContainer extends StatefulWidget {
  final ScrollController scrollController;
  const JobApplicationContainer({super.key, required this.scrollController});

  @override
  // ignore: library_private_types_in_public_api
  _JobApplicationContainerState createState() =>
      _JobApplicationContainerState();
}

class _JobApplicationContainerState extends State<JobApplicationContainer>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  Future<void> _toggleContainer() async {
    if (_animation!.status != AnimationStatus.completed) {
      await _controller!.forward();
      await widget.scrollController.animateTo(300,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
    } else {
      await _controller!
          .animateBack(0, duration: const Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF5521B5), width: 1)),
        child: Column(children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: const Icon(Icons.favorite_border_outlined,
                        color: Colors.red),
                    onPressed: () {}),
                InkWell(
                    child: const Text('Apply Now',
                        style: TextStyle(color: Color(0xFF5521B5))),
                    onTap: () => _toggleContainer()),
                SizedBox(width: screenWidth * .1)
              ]),
          SizeTransition(
              sizeFactor: _animation!,
              axis: Axis.vertical,
              child: Form(
                  key: formKey,
                  child: Column(children: <Widget>[
                    const Text('Project Bid'),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Colors.grey[700]!, width: 1)),
                        child: Column(children: <Widget>[
                          SizedBox(
                              height: 50,
                              child: Row(children: <Widget>[
                                SizedBox(
                                    width: screenWidth * .4,
                                    height: 50,
                                    child: ListTile(
                                        title: const Text('By Milestone',
                                            style: TextStyle(fontSize: 13)),
                                        leading: Radio<String>(
                                            value: 'By Milestone',
                                            groupValue: 'By Milestone',
                                            onChanged: (String? value) {}))),
                                SizedBox(
                                    width: screenWidth * .38,
                                    height: 50,
                                    child: ListTile(
                                        title: const Text('By Project',
                                            style: TextStyle(fontSize: 13)),
                                        leading: Radio<String?>(
                                            value: 'By Project',
                                            groupValue: 'By Project',
                                            onChanged: (String? value) {})))
                              ])),
                          const Text(
                              "Divide the project into smaller segments, called milestones. You'll be paid for milestones as they are completed and approved.")
                        ])),
                    Container(
                        height: 50,
                        width: screenWidth * .8,
                        child: TextFormField()),
                    Row(children: <Widget>[
                      Container(
                          height: 50,
                          width: screenWidth * .4,
                          child: TextFormField()),
                      Container(
                          height: 50,
                          width: screenWidth * .4,
                          child: TextFormField())
                    ]),
                    const Text('Cover letter'),
                    Container(
                      height: 50,
                      width: screenWidth * .8,
                      child: TextFormField(
                        minLines: 5,
                        maxLines: 5,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Submit Proposal'))
                  ])))
        ]));
  }
}
