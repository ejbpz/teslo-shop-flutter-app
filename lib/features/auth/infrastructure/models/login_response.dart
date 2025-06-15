class LoginResponse {
  final String id;
  final String email;
  final String fullName;
  final bool isActive;
  final List<String> roles;
  final String token;

  LoginResponse({
      required this.id,
      required this.email,
      required this.fullName,
      required this.isActive,
      required this.roles,
      required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
      id: json["id"],
      email: json["email"],
      fullName: json["fullName"],
      isActive: json["isActive"],
      roles: List<String>.from(json["roles"].map((x) => x)),
      token: json["token"],
  );
}