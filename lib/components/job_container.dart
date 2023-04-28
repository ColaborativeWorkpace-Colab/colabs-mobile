import 'package:flutter/material.dart';

class JobContainer extends StatelessWidget {
  final List<String>? requirements;
  final String jobTitle;
  final String? description;
  final DateTime timeStamp;
  final bool isVerified;

  const JobContainer({
    super.key,
    required this.jobTitle,
    required this.timeStamp,
    this.requirements,
    this.description,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 5)
        ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.all(15),
                  child: Text(
                    jobTitle,
                    style: const TextStyle(fontSize: 25),
                  )),
              (requirements != null)
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 50,
                      width: screenWidth * .9,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: requirements!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Chip(label: Text(requirements![index])));
                          }),
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Text(description ?? '')),
              (description != null)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          Container(height: screenHeight * .5));
                                },
                                child: const Text('More',
                                    style: TextStyle(
                                        color: Color(0xFF5521B5),
                                        fontWeight: FontWeight.bold))),
                          )
                        ])
                  : const SizedBox(),
              Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Chip(
                      backgroundColor: isVerified
                          ? const Color(0xFF5521B5)
                          : Colors.grey[300],
                      label: isVerified
                          ? SizedBox(
                              width: 150,
                              child: Row(children: const <Widget>[
                                Icon(
                                  Icons.payment,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text('Payment Verified',
                                    style: TextStyle(color: Colors.white)),
                              ]))
                          : SizedBox(
                              width: 170,
                              child: Row(children: const <Widget>[
                                Icon(Icons.payment, color: Colors.white),
                                SizedBox(width: 10),
                                Text('Payment Unverified',
                                    style: TextStyle(color: Colors.white)),
                              ]))))
            ]));
  }
}
