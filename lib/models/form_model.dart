// guarda los datos de los formularios
class FormModel {
  final int id;
  final String name;

  FormModel({required this.id, required this.name});

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJSON() {
    return {'id': id, 'name': name};
  }
}
