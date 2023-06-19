class Response {
  int? status;
  String? message;
  bool? success;
  dynamic data;

  Response(
      {required this.status,
      required this.message,
      required this.success,
      required this.data});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
        status: json['status'] as int,
        message: json['message'] as String,
        success: json['success'] as bool,
        data: json['data'] as dynamic);
  }
}
