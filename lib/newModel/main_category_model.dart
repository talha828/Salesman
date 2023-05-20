class MainCategoryModel {
  String userId;
  String username;
  String email;
  String cell;
  String designation;
  String empNo;
  List<Role> roles;

  MainCategoryModel({
     this.userId,
     this.username,
     this.email,
     this.cell,
     this.designation,
     this.empNo,
     this.roles,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> rolesJson = json['ROLES'];

    List<Role> roles = rolesJson.map((roleJson) {
      if (roleJson != null) {
        return Role(
          roleId: roleJson['ROLE_ID'],
          roleName: roleJson['ROLENAME'],
        );
      }
      return null;
    }).toList();

    return MainCategoryModel(
      userId: json['USERID'],
      username: json['USERNAME'],
      email: json['EMAIL'],
      cell: json['CELL'],
      designation: json['DESIGNATION'],
      empNo: json['EMPNO'],
      roles: roles,
    );
  }
}

class Role {
  int roleId;
  String roleName;

  Role({
    this.roleId,
    this.roleName,
  });
}
