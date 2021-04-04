import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flex/services/base_managers/network.dart';
import 'package:flutter/foundation.dart';


const List<int> successCodes = [200, 201, 202, 203, 204];
class NoResponse {}

class NetworkService extends ServiceManager {
  @override
  Future<T> onResult<T>(result) {
    // TODO: implement onResult
    throw UnimplementedError();
  }

  // Future<T> networkRequest<T>(String url, String action,
  //   {List<dynamic> parameters = const [], bool showError = true}) async {
  //   try{
  //     return await _doWebRequest<T>(url, action, parameters, showError);
  //   }
  //   catch(e, stacktrace){
  //     print(e);
  //
  //     if(showError){
  //       SkeletonException odooException = GeneralException(
  //         e.toString(),
  //         e is SkeletonException ? e.type : ExceptionTypes.UNIMPLEMENTED_EXCEPTION,
  //       );
  //
  //       super.onError(Error(odooException,stacktrace));
  //     }
  //
  //     return null;
  //   }
  // }
  //
  // Future<T> httpNetworkRequest<T>(String url, Map<String, dynamic> body, {HttpAction action = HttpAction.POST}) async {
  //   try{
  //     return await _doHttpRequest<T>(url, body, action);
  //   }
  //   catch(e, stacktrace){
  //     print(e);
  //
  //     SkeletonException odooException = GeneralException(
  //       e.toString(),
  //       e is SkeletonException ? e.type : ExceptionTypes.UNIMPLEMENTED_EXCEPTION,
  //     );
  //
  //     super.onError(Error(odooException,stacktrace));
  //
  //     return null;
  //   }
  // }
  //
  // Future<T> _doWebRequest<T>(String url, String action, List<dynamic> parameters, bool showError) async {
  //   try{
  //     print(parameters);
  //     var result = await xml_rpc.call(url, action, parameters);
  //     print("Result: $result");
  //
  //     //If parameters are wrong, result is false.
  //     if(showError && result is bool && !result){
  //       throw GeneralException("Request Invalid, please check parameters", ExceptionTypes.REQUEST_ERROR);
  //     }
  //
  //     return onResult<T>(result);
  //   }
  //   on TimeoutException {
  //     throw GeneralException("Your request has timed out! Please retry", ExceptionTypes.TIMEOUT_EXCEPTION);
  //   }
  //   on SocketException {
  //     throw GeneralException("Bad connection! Please retry", ExceptionTypes.SOCKET_EXCEPTION);
  //   }
  // }
  //
  // Future<T> _doHttpRequest<T>(String url, Map<String, dynamic> body, HttpAction action) async {
  //   try{
  //     print("Body: $body");
  //     var response;
  //
  //     switch (action){
  //
  //       case HttpAction.GET:
  //         response = await http.get(url);
  //         break;
  //       case HttpAction.POST:
  //         response = await http.post(url, body: body != null ? json.encoder.convert(body) : "");
  //         break;
  //       case HttpAction.POST_ENCODED_URL:
  //         response = await http.post(url, headers: {'Content-Type':"application/x-www-form-urlencoded"}, body: body);
  //         break;
  //       case HttpAction.PUT:
  //         response = await http.put(url, body: body != null ? json.encoder.convert(body) : "");
  //         break;
  //       case HttpAction.DELETE:
  //         response = await http.delete(url);
  //         break;
  //     }
  //
  //     print("Result: ${response.body}");
  //
  //     //If response is not a success code
  //     if(!successCodes.contains(response.statusCode)){
  //       throw GeneralException(
  //         "Request Invalid! ${response.statusCode}: ${response.reasonPhrase}",
  //         ExceptionTypes.REQUEST_ERROR,
  //       );
  //     }
  //
  //     // break request response parsing if return type is NoResponse
  //     if(T == NoResponse){
  //       return onResult<T>(NoResponse());
  //     }
  //
  //     if (response.body == null || response.body == "") {
  //       return onResult<T>(true);
  //     } else {
  //       return onResult<T>(json.decode(response.body));
  //     }
  //   }
  //   on TimeoutException {
  //     throw GeneralException("Your request has timed out! Please retry", ExceptionTypes.TIMEOUT_EXCEPTION);
  //   }
  //   on SocketException {
  //     throw GeneralException("Bad connection! Please retry", ExceptionTypes.SOCKET_EXCEPTION);
  //   }
  // }
  //
  // @override
  // Future<T> onResult<T>(result) async {
  //   Map<String, dynamic> map = {
  //     "type": T,
  //     "response": result,
  //   };
  //   // Parse into model class using a new isolate
  //   T res = await compute(getModel, map);
  //   return res;
  // }

}