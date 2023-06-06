import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/models/project.dart';
import 'package:colabs_mobile/types/task_status.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProjectOverviewTab extends StatelessWidget {
  final Project project;
  const ProjectOverviewTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    RESTService restService = Provider.of<RESTService>(context);
    LayoutController layoutController = Provider.of<LayoutController>(context);
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
            (!restService.isFetching) ? ListView.builder(
              itemCount: restService.commits.length,
              itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                      // ignore: avoid_dynamic_calls
                      title: Text(restService.commits[index]['commit']['committer']['name']),
                      // ignore: avoid_dynamic_calls
                      subtitle: Text(restService.commits[index]
                              ['commit']['message']),
                      trailing: Text(
                          DateFormat('M/dd/yyyy').format(
                              // ignore: avoid_dynamic_calls
                              DateTime.parse(restService.commits[index]['commit']['committer']
                                  ['date'])))));
            }) : Container(
              margin: EdgeInsets.only(top: screenHeight * .25), 
              child: Column(
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 30),
                  Text('Fetching Data')
                ]
              )
            ),
            ListView.builder(
                itemCount: project.tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListTile(
                          leading: Checkbox(
                              value: project.tasks[index].status ==
                                  TaskStatus.completed,
                              onChanged: (bool? value) async {
                                bool taskUpdated =
                                    await restService.updateTaskStatusRequest(
                                        project.projectId,
                                        // ignore: always_specify_types
                                        {
                                      "taskId": project.tasks[index].taskId,
                                      "status": value == true
                                          ? TaskStatus.completed.name
                                          : TaskStatus.queued.name
                                    });
                                if (taskUpdated) {
                                  project.tasks[index].status = value == true
                                      ? TaskStatus.completed
                                      : TaskStatus.queued;
                                  layoutController.refresh(true);
                                }
                              }),
                          title: Text(project.tasks[index].taskTitle,
                              style: TextStyle(
                                  decoration: project.tasks[index].status ==
                                          TaskStatus.completed
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none)),
                          subtitle: project.tasks[index].description.isNotEmpty
                              ? Text(project.tasks[index].description)
                              : null));
                })
          ]))
        ]));
  }
}
