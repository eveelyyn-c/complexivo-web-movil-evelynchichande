class Categoria {
  final int idcategoria;
  final String nombre;

  Categoria({
    required this.idcategoria,
    required this.nombre,
  });


  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
    idcategoria: json["idcategoria"],
    nombre: json["nombre"],
  );

  Map<String, dynamic> toJson() => {
    "idcategoria": idcategoria,
    "nombre": nombre,
  };
}