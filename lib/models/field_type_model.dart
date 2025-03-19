class FieldTypeModel {
  final int id;
  final String name;

  FieldTypeModel({required this.id, required this.name});

  factory FieldTypeModel.fromJson(Map<String, dynamic> json) {
    return FieldTypeModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJSON() {
    return {'id': id, 'name': name};
  }
}
