import 'dart:developer';

import 'package:attend_app/core/Errors/dio_error.dart';
import 'package:attend_app/core/Services/shared_preference_services.dart';
import 'package:attend_app/core/Utils/constant_manager.dart';
import 'package:attend_app/core/modals/course_list_model.dart';
import 'package:attend_app/data/data_source/login_remote_data_source.dart';
import 'package:attend_app/domain/entity/login_response_entity.dart';
import 'package:attend_app/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource _loginRemoteDataSource;

  LoginRepositoryImpl(this._loginRemoteDataSource);
final coursesList=CourseListModel();
  @override
  Future<Either<DioFailure, LoginResponseEntity>> login(
      String username, String password) async {
    var response = await _loginRemoteDataSource.login(username, password);
    log("Response $response");
    try {
      if (response.statusCode == 200) {
        var data =LoginResponseEntity.fromJson(response.data);
        log(data.toString());
        SharedPreferenceServices.saveData(
            AppConstants.token, data.token.toString());
        log(data.token.toString());
        coursesList.coursesList = data.data!.courses ?? [];
        log(coursesList.coursesList.map((e) => {'id': e.id, 'name': e.courseName}).toList().toString());


        await SharedPreferenceServices.saveData(
            AppConstants.studentId, data.data!.id.toString());
        log(data.data!.id.toString());
        return Right(data);
      } else {
        return Left(
            ServerFailure.BadfromResponse(response.statusCode!, response.data));
      }
    } catch (e, s) {
      log(s.toString());
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else if (e is NetworkFailure) {
        return Left(NetworkFailure(e.errorMessage));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
