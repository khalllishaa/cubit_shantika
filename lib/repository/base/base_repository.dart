import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:cubit_shantika/utils/data_state.dart';

abstract class BaseRepository {
  Future<DataState<T>> getStateOf<T>({
    required Future<HttpResponse<T>> Function() request,
  }) async {
    try {
      final httpResponse = await request();

      if (httpResponse.response.statusCode == 200) {
        return DataStateSuccess(httpResponse.data);
      } else {
        return DataStateError(
          DioException(
            requestOptions: httpResponse.response.requestOptions,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } on DioException catch (e) {
      return DataStateError(e);
    } catch (e) {
      return DataStateError(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }
}