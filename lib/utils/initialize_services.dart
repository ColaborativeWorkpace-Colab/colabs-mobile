import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/chat_controller.dart';
import 'package:colabs_mobile/controllers/job_controller.dart';
import 'package:colabs_mobile/controllers/project_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void initServices(BuildContext context) {
  Authenticator authenticator =
      Provider.of<Authenticator>(context, listen: false);
  ChatController chatController =
      Provider.of<ChatController>(context, listen: false);
  RESTService restService = Provider.of<RESTService>(context, listen: false);
  JobController jobController =
      Provider.of<JobController>(context, listen: false);
  ProjectController projectController =
      Provider.of<ProjectController>(context, listen: false);

  authenticator.setIsAuthorized = true;
  restService.setAuthenticator = authenticator;
  restService.setChatController = chatController;
  restService.setJobController = jobController;
  restService.setProjectController = projectController;
  chatController.setAuthenticator = authenticator;

  if (authenticator.isUserAuthorized) {
    chatController.initSocket();
    restService.getProfileInfoRequest().whenComplete(() => restService.getLastSeenRequest());
    restService.getSocialFeedRequest();
    restService.getMessagesRequest();
    restService.getProjectsRequest();
    restService.getJobsRequest();
    restService.getLastSeenRequest();
  }
}
