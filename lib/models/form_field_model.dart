/// A model representing a form with various attributes.
///
/// The [FormModel] class contains information about a form, including its
/// unique identifier, label, type, and whether it is required.
///
/// Example usage:
/// ```dart
/// FormModel form = FormModel(
///   id: '1',
///   label: 'Name',
///   type: FormType.text,
///   required: true,
/// );
/// ```
///
/// The [FormModel] class also provides a factory constructor to create an
/// instance from a JSON object.
library;

import 'package:dynamic_form_app/models/field_type_model.dart';
import 'package:dynamic_form_app/models/form_model.dart';

class FormFieldModel {
  final int id;
  final int formTypeId;
  final int formId;

  final FieldTypeModel? type;
  final FormModel? form;

  FormFieldModel({
    required this.id,
    required this.formTypeId,
    required this.formId,
    this.type,
    this.form,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      id: json['id'],
      formTypeId: json['field_type_id'],
      formId: json['form_id'],
      form: json['form'] != null ? FormModel.fromJson(json['form']) : null,
      type: json['type'] != null ? FieldTypeModel.fromJson(json['type']) : null,
    );
  }
}
