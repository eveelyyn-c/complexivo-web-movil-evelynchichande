class Departamento {
  final int iddepartamento;
  final String nombre;

  Departamento({
    required this.iddepartamento,
    required this.nombre,
  });

  factory Departamento.fromJson(Map<String, dynamic> json) => Departamento(
    iddepartamento: json["iddepartamento"],
    nombre: json["nombre"],
  );

  Map<String, dynamic> toJson() => {
    "iddepartamento": iddepartamento,
    "nombre": nombre,
  };
}