import '../../domain/entity/login_response_entity.dart';


class CourseListModel {
  static final CourseListModel _instance = CourseListModel._internal();

  factory CourseListModel() => _instance;

  CourseListModel._internal();
  List<Courses> coursesList=[];
}