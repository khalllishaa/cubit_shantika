import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final DioException? exception;

  const DataState({this.data, this.exception});
}

class DataStateSuccess<T> extends DataState<T> {
  const DataStateSuccess(T data) : super(data: data);
}

class DataStateError<T> extends DataState<T> {
  const DataStateError(DioException exception) : super(exception: exception);
}