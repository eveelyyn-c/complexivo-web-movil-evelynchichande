import 'categoria.dart';
import 'empleado.dart';

class Zapato {
  final int? id;
  final String nombre;
  final double precio;
  final int cantidad;
  final String descripcion;
  final bool estado;
  final Categoria? categoria;
  final Empleado? empleados;

  Zapato({
    this.id,
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.descripcion,
    required this.estado,
    this.categoria,
    this.empleados,
  });


  factory Zapato.fromJson(Map<String, dynamic> json) => Zapato(
    id: json["id"],
    nombre: json["nombre"],
    precio: json["precio"],
    cantidad: json["cantidad"],
    descripcion: json["descripcion"],
    estado: json["estado"],
    categoria: Categoria.fromJson(json["categoria"]),
    empleados: Empleado.fromJson(json["empleados"]),
  );

  factory Zapato.fromJsonSave(Map<String, dynamic> json) => Zapato(
    id: json["id"],
    nombre: json["nombre"],
    precio: json["precio"],
    cantidad: json["cantidad"],
    descripcion: json["descripcion"],
    estado: json["estado"],
  );

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "precio": precio,
    "cantidad": cantidad,
    "descripcion": descripcion,
    "estado": estado,
    "categoria": categoria?.toJson(),
    "empleados": empleados?.toJsonSaveShoes(),
  };
}