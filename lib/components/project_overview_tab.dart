import 'package:colabs_mobile/models/task.dart';
import 'package:colabs_mobile/types/task_status.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectOverviewTab extends StatelessWidget {
  final List<Task> tasks;
  const ProjectOverviewTab({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
        length: 2,
        child: Column(children: <Widget>[
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: screenHeight * .3,
              width: screenWidth,
              child: LineChart(LineChartData(
                  lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                            return touchedSpots
                                .map((LineBarSpot touchedSpot) =>
                                    LineTooltipItem(
                                        DateFormat('M/dd/yyyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                touchedSpot.x.toInt())),
                                        const TextStyle()))
                                .toList();
                          })),
                  titlesData: FlTitlesData(
                      bottomTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: true, reservedSize: 50)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false))),
                  gridData: FlGridData(drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: <LineChartBarData>[
                    //TODO: Load actual data
                    LineChartBarData(isCurved: true, spots: <FlSpot>[
                      FlSpot(
                          DateTime(2010, 9, 19)
                              .millisecondsSinceEpoch
                              .toDouble(),
                          10700),
                      FlSpot(
                          DateTime(2017, 9, 19)
                              .millisecondsSinceEpoch
                              .toDouble(),
                          107000),
                      FlSpot(
                          DateTime(2019, 9, 20)
                              .millisecondsSinceEpoch
                              .toDouble(),
                          117000),
                      FlSpot(
                          DateTime(2020, 9, 21)
                              .millisecondsSinceEpoch
                              .toDouble(),
                          97000),
                      FlSpot(
                          DateTime(2022, 9, 22)
                              .millisecondsSinceEpoch
                              .toDouble(),
                          107500),
                      FlSpot(
                          DateTime(2023, 9, 23)
                              .millisecondsSinceEpoch
                              .toDouble(),
                          117000)
                    ])
                  ]))),
          Container(
              color: Colors.grey[200]!,
              child: TabBar(
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  indicator: BoxDecoration(
                      boxShadow: const <BoxShadow>[
                        BoxShadow(color: Colors.black26, blurRadius: 5)
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  tabs: const <Widget>[
                    Tab(
                        child: Text('Commits',
                            style: TextStyle(color: Color(0xff5521B5)))),
                    Tab(
                        child: Text('Tasks',
                            style: TextStyle(color: Color(0xff5521B5))))
                  ])),
          Expanded(
              child: TabBarView(children: <Widget>[
            ListView.builder(itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                      title: const Text('Commiter'),
                      subtitle: const Text('Commit Message'),
                      trailing: Text(
                          DateFormat('M/dd/yyyy').format(DateTime.now()))));
            }),
            ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListTile(
                          leading: Checkbox(
                              value:
                                  tasks[index].status == TaskStatus.completed,
                              onChanged: (bool? value) {
                                //TODO: Implement task complete request
                              }),
                          title: Text(tasks[index].taskTitle),
                          subtitle: tasks[index].description.isNotEmpty
                              ? Text(tasks[index].description)
                              : null));
                })
          ]))
        ]));
  }
}
