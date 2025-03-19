import 'dart:developer' as dev;
import 'package:dynamic_form_app/helpers/database_helper.dart';
import 'package:dynamic_form_app/models/field_type_model.dart';
import 'package:dynamic_form_app/utils/constants.dart';

class FormFieldService {
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<FieldTypeModel>> fetchFields() async {
    final fieldsDb = await _db.getData(Constants.fieldTypesTable);
    dev.log('[FORM_FIELD_SERVICE] Fetched fields: $fieldsDb');
    final fields =
        fieldsDb.map((field) => FieldTypeModel.fromJson(field)).toList();
    return fields;
  }

  Future<void> createFormFields(
    int formId,
    List<Map<String, int>> fieldsData,
  ) async {
    final database = await _db.database;
    await database.transaction((txn) async {
      for (final fieldId in fieldsData) {
        await txn.insert(Constants.formFieldsTable, {
          'form_id': formId,
          'field_type_id': fieldId['field_type_id'],
        });
      }
    });
    dev.log('[FORM_FIELD_SERVICE] Created form fields');
  }
}
