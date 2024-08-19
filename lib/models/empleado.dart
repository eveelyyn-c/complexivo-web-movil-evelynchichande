import 'departamento.dart';

class Empleado { /*LATE= esa asignacion de valor la haremos despues*/
  late int? idempleado;
  late String? nombre;
  late String? username;
  late String? password;
  late String? dni;
  late String? apellido;
  late dynamic verificationToken;
  late String? role;
  late Departamento? departamento;
  late bool? enabled;
  late bool? accountNonLocked;
  late bool? credentialsNonExpired;
  late bool? accountNonExpired;

  Empleado({
    required this.idempleado,
    required this.nombre,
    required this.username,
    required this.password,
    required this.dni,
    required this.apellido,
    required this.verificationToken,
    required this.role,
    required this.departamento,
    required this.enabled,
    required this.accountNonLocked,
    required this.credentialsNonExpired,
    required this.accountNonExpired,
  });

  Empleado.save(
      this.idempleado,
      this.role,
      );


  factory Empleado.fromJson(Map<String, dynamic> json) => Empleado(
    idempleado: json["idempleado"],
    nombre: json["nombre"],
    username: json["username"],
    password: json["password"],
    dni: json["dni"],
    apellido: json["apellido"],
    verificationToken: json["verificationToken"],
    role: json["role"],
    departamento: Departamento.fromJson(json["departamento"]),
    enabled: json["enabled"],
    accountNonLocked: json["accountNonLocked"],
    credentialsNonExpired: json["credentialsNonExpired"],
    accountNonExpired: json["accountNonExpired"],
  );

  Map<String, dynamic> toJson() => {
    "idempleado": idempleado,
    "nombre": nombre,
    "username": username,
    "password": password,
    "dni": dni,
    "apellido": apellido,
    "verificationToken": verificationToken,
    "role": role,
    "departamento": departamento?.toJson(), /*Si departamento no es NULO Ejecuta el metodo toJson en cualquier metodo*/
    "enabled": enabled,
    "accountNonLocked": accountNonLocked,
    "credentialsNonExpired": credentialsNonExpired,
    "accountNonExpired": accountNonExpired,
  };

  Map<String, dynamic> toJsonSaveShoes() => {
    "idempleado": idempleado,
    "role": role,
  };
}