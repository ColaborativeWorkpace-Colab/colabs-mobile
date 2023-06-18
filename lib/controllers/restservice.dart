import 'dart:convert';
import 'package:colabs_mobile/controllers/authenticator.dart';
import 'package:colabs_mobile/controllers/chat_controller.dart';
import 'package:colabs_mobile/controllers/job_controller.dart';
import 'package:colabs_mobile/controllers/project_controller.dart';
import 'package:colabs_mobile/models/chat.dart';
import 'package:colabs_mobile/models/job.dart';
import 'package:colabs_mobile/models/message.dart';
import 'package:colabs_mobile/models/post.dart';
import 'package:colabs_mobile/models/post_comment.dart';
import 'package:colabs_mobile/models/project.dart';
import 'package:colabs_mobile/models/task.dart';
import 'package:colabs_mobile/models/user.dart';
import 'package:colabs_mobile/types/chat_type.dart';
import 'package:colabs_mobile/types/job_status.dart';
import 'package:colabs_mobile/types/task_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class RESTService extends ChangeNotifier {
  final String urlHost = dotenv.env['DEV_URL']!;
  Authenticator? authenticator;
  ChatController? chatController;
  JobController? jobController;
  ProjectController? projectController;
  final List<User> _userConnections = <User>[];
  final List<Post> _socialFeedPosts = <Post>[];
  final List<Post> _exploreFeedPosts = <Post>[];
  final List<String> _queuedProjectFiles = <String>[];
  List<dynamic> commits = <dynamic>[];
  Map<String, dynamic> trees = <String, dynamic>{};
  // ignore: always_specify_types
  Map<String, dynamic> _profileInfo = {};
  bool _isPosting = false;
  bool _isRefreshing = false;
  bool _isFetching = false;

  RESTService();

  Future<bool> getSocialFeedRequest() async {
    try {
      http.Response response = await http
          .get(Uri.http(urlHost, '/api/v1/social/${authenticator!.getUserId}'));

      if (response.statusCode == 200) {
        _populateFeed(response.body, false);
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  void _populateFeed(String body, bool isExploring) {
    Map<String, dynamic> decodedJsonBody = json.decode(body);
    List<dynamic> rawPosts = decodedJsonBody['posts'];

    for (Map<String, dynamic> rawPost in rawPosts) {
      List<String> tags = (rawPost['tags'] as List<dynamic>)
          // ignore: always_specify_types
          .map((tag) => tag as String)
          .toList();
      Post post = Post(
          rawPost['_id'],
          rawPost['userId'],
          rawPost['textContent'],
          rawPost['imageContent'],
          DateTime.parse(rawPost['createdAt']),
          tags,
          rawPost['likes'],
          _populatePostComments(rawPost['comments']),
          rawPost['donatable']);

      if (isExploring) {
        _exploreFeedPosts.add(post);
      } else {
        if (!_postExists(rawPost['_id'])) {
          _socialFeedPosts.add(post);
        }
      }
    }
  }

  bool _postExists(String postId) {
    for (Post post in _socialFeedPosts) {
      if (post.postId == postId) return true;
    }

    return false;
  }

  List<PostComment> _populatePostComments(List<dynamic> rawComments) {
    List<PostComment> comments = <PostComment>[];

    for (Map<String, dynamic> rawComment in rawComments) {
      comments.add(PostComment(rawComment['userId'], rawComment['comment']));
    }

    return comments;
  }

  Future<bool> postContentRequest(Map<String, dynamic> body) async {
    try {
      http.Response response = await http.post(
          Uri.http(urlHost, '/api/v1/social/${authenticator!.getUserId}'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode(body));

      if (response.statusCode == 200) {
        _addPost(response);
        return Future<bool>.value(true);
      } else
        // ignore: curly_braces_in_flow_control_structures
        return Future<bool>.value(false);
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  // Future<bool> uploadFile() async {
  //   var request = http.MultipartRequest("POST", uri)
  //     ..fields['id'] = body['id'].toString()
  //     ..fields['deviceid'] = body['deviceid'] as String
  //     ..fields['startdest'] = body['startdest'] as String
  //     ..files.add(http.MultipartFile.fromBytes(
  //         'customer_picture', await image.readAsBytes(),
  //         filename:
  //             '${body['customer_name']}-${DateTime.now().toString().replaceAll(' ', '').replaceAll('.', '').replaceAll(':', '')}.jpg'));
  // }

  Future<bool> likePostRequest(String postId) async {
    try {
      http.Response response = await http.put(Uri.http(
          urlHost, '/api/v1/social/${authenticator!.getUserId}/$postId/like'));

      if (response.statusCode == 200)
        // ignore: curly_braces_in_flow_control_structures
        return Future<bool>.value(true);
      else
        // ignore: curly_braces_in_flow_control_structures
        return Future<bool>.value(false);
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  Future<bool> commentPostRequest(String postId, String comment) async {
    try {
      http.Response response = await http.put(
          Uri.http(urlHost,
              '/api/v1/social/${authenticator!.getUserId}/$postId/comment'),
          headers: <String, String>{'Content-Type': 'application/json'},
          // ignore: always_specify_types
          body: json.encode({'comment': comment}));

      if (response.statusCode == 200)
        // ignore: curly_braces_in_flow_control_structures
        return Future<bool>.value(true);
      else
        // ignore: curly_braces_in_flow_control_structures
        return Future<bool>.value(false);
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  void _addPost(http.Response response) {
    Map<String, dynamic> body = json.decode(response.body);
    Map<String, dynamic> rawPost = body['post'];
    List<String> tags = (rawPost['tags'] as List<dynamic>)
        // ignore: always_specify_types
        .map((requirement) => requirement as String)
        .toList();
    _socialFeedPosts.insert(
        0,
        Post(
            rawPost['_id'],
            rawPost['userId'],
            rawPost['textContent'],
            rawPost['imageContent'],
            DateTime.parse(rawPost['createdAt']),
            tags,
            rawPost['likes'],
            _populatePostComments(rawPost['comments']),
            rawPost['donatable']));
  }

  Future<List<Post>> getPostData({String? postTag}) async {
    try {
      http.Response response =
          await http.get(Uri.http(urlHost, '/api/v1/social/explore/$postTag'));

      if (response.statusCode == 200) {
        _populateFeed(response.body, true);
        return Future<List<Post>>.value(_exploreFeedPosts);
      } else {
        // ignore: always_specify_types
        return Future<List<Post>>.value([]);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      // ignore: always_specify_types
      return Future<List<Post>>.value([]);
    }
  }

  Future<bool> getUserConnectionsRequest() async {
    try {
      http.Response response = await http.get(Uri.http(
          urlHost, '/api/v1/social/connections/${authenticator!.getUserId}'));

      if (response.statusCode == 200) {
        _populateUserConnections(response.body);
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  void _populateUserConnections(String body, {bool initial = true}) {
    Map<String, dynamic> decodedJsonBody = json.decode(body);
    List<dynamic> connections = initial
        // ignore: avoid_dynamic_calls
        ? decodedJsonBody['profile']['connections']
        : decodedJsonBody['connections'];

    for (dynamic connection in connections) {
      if (!_userConnections.contains(connection)) {
        _userConnections.add(User(connection));
      }
    }
  }

  Future<bool> getMessagesRequest({bool listen = false}) async {
    try {
      http.Response response = await http.get(
          Uri.http(urlHost, '/api/v1/messaging/${authenticator!.getUserId}'));

      if (response.statusCode == 200) {
        _populateChats(response.body, listen);
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  Future<bool> getLastSeenRequest({bool listen = false}) async {
    try {
      String userIds = '';
      for (User user in _userConnections) {
        userIds += '${user.userId},';
      }
      http.Response response = await http.post(
          // ignore: always_specify_types
          body: json.encode({'userIds': userIds}),
          headers: <String, String>{'Content-Type': 'application/json'},
          Uri.http(urlHost, '/api/v1/messaging/lastSeen'));

      if (response.statusCode == 200) {
        _populateUserSeenStatus(response.body);
        //_populateChats(response.body, listen);
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  void _populateUserSeenStatus(String body) {
    List<dynamic> data = json.decode(body);

    for (Map<String, dynamic> userStatus in data) {
      for (User user in _userConnections) {
        if (user.userId == userStatus['userId']) {
          user.userName = userStatus['userName'];
          user.isOnline = userStatus['isOnline'];
          user.lastSeen = DateTime.parse(userStatus['lastSeen']);
        }
      }
    }
  }

  void _populateChats(String body, bool listen) {
    Map<String, dynamic> decodedJsonBody = json.decode(body);
    List<dynamic> chats = decodedJsonBody['messages'];

    for (Map<String, dynamic> chat in chats) {
      List<dynamic> members = chat['members'];
      List<Message> messages =
          _populateMessages(chat['totalMessages'], chat['inbox']);

      members.remove(authenticator!.getUserId);

      chatController!.addChat(
          Chat(
              members[0],
              messages,
              (chat['type'] == 'Private') ? ChatType.private : ChatType.group,
              chat['_id']),
          listen);
    }
  }

  List<Message> _populateMessages(
      List<dynamic> rawMessages, List<dynamic> rawUnreadMessages) {
    List<Message> messages = <Message>[];
    for (Map<String, dynamic> rawMessage in rawMessages) {
      messages.add(Message(
          rawMessage['messageId'],
          rawMessage['sender'],
          rawMessage['message'],
          DateTime.fromMicrosecondsSinceEpoch(
              (rawMessage['timestamp'] as int) * 1000),
          rawUnreadMessages.contains(rawMessage['messageId'] as String)
              ? false
              : true));
    }

    return messages;
  }

  Future<bool> getJobsRequest({bool listen = false}) async {
    try {
      http.Response response = await http
          .get(Uri.http(urlHost, '/api/v1/jobs/${authenticator!.getUserId}'));

      if (response.statusCode == 200) {
        _populateJobs(response.body, listen);
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  void _populateJobs(String body, bool listen) {
    Map<String, dynamic> decodedJsonBody = json.decode(body);
    List<dynamic> jobs = decodedJsonBody['jobs'];

    for (Map<String, dynamic> job in jobs) {
      List<String> workers = (job['workers'] as List<dynamic>)
          // ignore: always_specify_types
          .map((worker) => worker as String)
          .toList();
      List<String> requirements = (job['requirements'] as List<dynamic>)
          // ignore: always_specify_types
          .map((requirement) => requirement as String)
          .toList();
      List<String> pendingWorkers = (job['pendingworkers'] as List<dynamic>)
          // ignore: always_specify_types
          .map((worker) => worker as String)
          .toList();
      jobController!.addJob(
          Job(
              job['_id'],
              job['title'],
              job['description'],
              mapJobStatusEnum(job['status']),
              workers,
              requirements,
              // ignore: always_specify_types
              double.parse(job['earnings'].toString()),
              job['owner'],
              job['paymentVerified'],
              pendingWorkers),
          listen);
    }
  }

  void _populateJobsFromProfile(List<dynamic> rawJobs, bool listen) {
    for (Map<String, dynamic> job in rawJobs) {
      List<String> workers = (job['workers'] as List<dynamic>)
          // ignore: always_specify_types
          .map((worker) => worker as String)
          .toList();
      List<String> requirements = (job['requirements'] as List<dynamic>)
          // ignore: always_specify_types
          .map((requirement) => requirement as String)
          .toList();
      List<String> pendingWorkers = (job['pendingworkers'] as List<dynamic>)
          // ignore: always_specify_types
          .map((worker) => worker as String)
          .toList();
      jobController!.addJob(
          Job(
              job['_id'],
              job['title'],
              job['description'],
              mapJobStatusEnum(job['status']),
              workers,
              requirements,
              // ignore: always_specify_types
              double.parse(job['earnings'].toString()),
              job['owner'],
              job['paymentVerified'],
              pendingWorkers),
          listen);
    }
  }

  Future<bool> applyJobRequest(String jobId, Map<String, dynamic> body) async {
    try {
      http.Response response = await http.post(
          Uri.http(urlHost, '/api/v1/jobs/$jobId/apply'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode(body));

      if (response.statusCode == 200) {
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  Future<bool> jobReadyRequest(String jobId, Map<String, dynamic> body) async {
    try {
      http.Response response = await http.put(
          Uri.http(urlHost, '/api/v1/jobs/$jobId/ready'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode(body));

      if (response.statusCode == 200) {
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  Future<bool> updateTaskStatusRequest(
      String projectId, Map<String, dynamic> body) async {
    try {
      http.Response response = await http.put(
          Uri.http(urlHost,
              '/api/v1/workspaces/projects/$projectId/updateTaskStatus'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode(body));

      if (response.statusCode == 200) {
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  Future<dynamic> getProfileInfoRequest(
      {String? userId, bool listen = false}) async {
    try {
      http.Response response = await http.get(Uri.http(urlHost,
          '/api/v1/profile/${(userId == null) ? authenticator!.getUserId : userId}'));

      if (response.statusCode == 200) {
        if (userId == null) {
          _loadProfileInfo(response.body);
          _populateUserConnections(response.body);

          return Future<bool>.value(true);
        } else {
          return Future<Map<String, dynamic>>.value(
              // ignore: avoid_dynamic_calls
              json.decode(response.body)['profile']);
        }
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  Future<bool> editProfileRequest(Map<String, dynamic> body,
      {bool listen = false}) async {
    try {
      http.Response response = await http.put(
          Uri.http(urlHost, '/api/v1/profile/${authenticator!.getUserId}'),
          headers: <String, String>{'Content-Type': 'application/json'},
          // ignore: always_specify_types
          body: json.encode({'data': body}));

      if (response.statusCode == 200) {
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  void updateProfileInfo(Map<String, dynamic> updatedInfo) {
    _profileInfo['firstName'] = updatedInfo['firstName'];
    _profileInfo['lastName'] = updatedInfo['lastName'];
    _profileInfo['bio'] = updatedInfo['bio'];
    _profileInfo['occupation'] = updatedInfo['occupation'];
    _profileInfo['location'] = updatedInfo['location'];
    _profileInfo['isOnline'] = updatedInfo['isOnline'];
    _profileInfo['lastSeen'] = updatedInfo['lastSeen'];
    notifyListeners();
  }

  void _loadProfileInfo(String body) {
    Map<String, dynamic> decodedJsonBody = json.decode(body);
    _profileInfo = decodedJsonBody['profile'];
    _populateJobsFromProfile(_profileInfo['jobs'], false);
  }
  
  //TODO: Implement approve request for recruiter
  
  Future<bool> getProjectsRequest({bool listen = false}) async {
    try {
      http.Response response = await http.get(Uri.http(
          urlHost, '/api/v1/workspaces/dashboard/${authenticator!.getUserId}'));

      if (response.statusCode == 200) {
        _populateProjects(response.body, listen);
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  void _populateProjects(String body, bool listen) {
    Map<String, dynamic> decodedJsonBody = json.decode(body);
    List<dynamic> rawProjects = decodedJsonBody['projects'];

    for (Map<String, dynamic> rawProject in rawProjects) {
      List<Task> tasks = _populateTasks(rawProject['tasks']);
      List<String> members = (rawProject['members'] as List<dynamic>)
          // ignore: always_specify_types
          .map((member) => member as String)
          .toList();

      projectController!.addProject(
          Project(rawProject['_id'], rawProject['name'], tasks,
              rawProject['files'], members),
          listen);
    }
  }

  List<Task> _populateTasks(List<dynamic> rawTasks) {
    List<Task> temp = <Task>[];

    for (Map<String, dynamic> rawTask in rawTasks) {
      List<String> assignees = (rawTask['assignees'] as List<dynamic>)
          // ignore: always_specify_types
          .map((assignee) => assignee as String)
          .toList();
      temp.add(Task(rawTask['id'], rawTask['title'], rawTask['description'],
          mapTaskStatusEnum(rawTask['status']), assignees,
          deadline: DateTime.parse(rawTask['deadline'])));
    }

    return temp;
  }

  Future<bool> getProjectFilesRequest(String projectId,
      {bool listen = false}) async {
    try {
      http.Response response = await http
          .get(Uri.http(urlHost, '/api/v1/workspaces/projects/$projectId'));

      if (response.statusCode == 200) {
        Map<String, dynamic> rawJson = json.decode(response.body);
        // ignore: avoid_dynamic_calls
        commits.addAll(rawJson['commits']['data']);
        // ignore: avoid_dynamic_calls
        trees.addAll(rawJson['trees']['data']);
        _isFetching = false;
        notifyListeners();
        return Future<bool>.value(true);
      } else {
        _isFetching = false;
        notifyListeners();
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      _isFetching = false;
      notifyListeners();
      return Future<bool>.value(false);
    }
  }

  Future<bool> getTrees(String projectId, String sha,
      {bool needsReload = false}) async {
    try {
      http.Response response = await http.get(
          Uri.http(urlHost, '/api/v1/workspaces/projects/$projectId/$sha'));

      if (response.statusCode == 200) {
        if (needsReload) {
          Map<String, dynamic> rawJson = json.decode(response.body);
          trees.clear();
          // ignore: avoid_dynamic_calls
          trees.addAll(rawJson['trees']['data']);
        } else {
          _addTreeToBase(sha, response.body);
        }
        _isFetching = false;
        notifyListeners();
        return Future<bool>.value(true);
      } else {
        _isFetching = false;
        notifyListeners();
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      _isFetching = false;
      notifyListeners();
      return Future<bool>.value(false);
    }
  }

  void _addTreeToBase(String sha, String body) {
    Map<String, dynamic> rawJson = json.decode(body);
    // ignore: avoid_dynamic_calls
    List<dynamic> tree = rawJson['trees']['data']['tree'];
    _recursiveInsert(sha, trees['tree'], tree);
  }

  void _recursiveInsert(
      String sha, List<dynamic> baseTree, List<dynamic> newTree) {
    for (dynamic element in baseTree) {
      // ignore: avoid_dynamic_calls
      if (element['sha'] == sha) {
        // ignore: avoid_dynamic_calls
        element['children'] = newTree;
        return;
      }

      // ignore: avoid_dynamic_calls
      if (element['children'] != null) {
        // ignore: avoid_dynamic_calls
        _recursiveInsert(sha, element['children'], newTree);
      }
    }
  }

  Future<bool> addMembersRequest(
      String projectId, Map<String, dynamic> body) async {
    try {
      http.Response response = await http.put(
          Uri.http(
              urlHost, '/api/v1/workspaces/projects/$projectId/addMembers'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode(body));

      if (response.statusCode == 200) {
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } on Exception catch (error) {
      debugPrint(error.toString());
      return Future<bool>.value(false);
    }
  }

  User? getUserInfo(String userId) {
    for (User connection in _userConnections) {
      if (connection.userId == userId) return connection;
    }

    return null;
  }

  void queueProjectFiles(String projectId) {
    _queuedProjectFiles.add(projectId);
    notifyListeners();
  }

  void unqueueProjectFiles(String projectId) {
    _queuedProjectFiles.remove(projectId);
    notifyListeners();
  }

  void clearQueue() {
    _queuedProjectFiles.clear();
    notifyListeners();
  }

  set setAuthenticator(Authenticator value) {
    authenticator = value;
  }

  set setChatController(ChatController value) {
    chatController = value;
  }

  set setJobController(JobController value) {
    jobController = value;
  }

  set setProjectController(ProjectController value) {
    projectController = value;
  }

  set isPosting(bool value) {
    _isPosting = value;
    notifyListeners();
  }

  set isRefreshing(bool value) {
    _isRefreshing = value;
    notifyListeners();
  }

  set isFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  List<User> get getUserConnections => _userConnections;
  List<Post> get getSocialFeedPosts => _socialFeedPosts;
  List<Post> get getExploreFeedPosts => _exploreFeedPosts;
  List<String> get getQueuedProjectFiles => _queuedProjectFiles;
  Map<String, dynamic> get getProfileInfo => _profileInfo;
  bool get isPosting => _isPosting;
  bool get isRefreshing => _isRefreshing;
  bool get isFetching => _isFetching;
}
