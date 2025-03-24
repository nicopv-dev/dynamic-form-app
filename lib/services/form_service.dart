import 'dart:developer' as dev;

import 'package:dynamic_form_app/app/app_router.dart';
import 'package:dynamic_form_app/controllers/network_controller.dart';
import 'package:dynamic_form_app/helpers/database_helper.dart';
import 'package:dynamic_form_app/models/field_type_model.dart';
import 'package:dynamic_form_app/models/form_field_model.dart';
import 'package:dynamic_form_app/models/form_model.dart';
import 'package:dynamic_form_app/utils/constants.dart';
import 'package:get/get.dart';

class FormService extends GetxController {
  final DatabaseHelper _db = DatabaseHelper();
  final NetworkController _networkController = Get.find<NetworkController>();

  Future<FormModel> createForm(Map<String, dynamic> data) async {
    if (_networkController.isConnected) {
      final form = FormModel(id: 1, name: 'Form from API');
      return form;
    } else {
      dev.log('Save to local database');
      await _db.insertData(Constants.formsTable, data);
      dev.log('[FORM_SERVICE] Created form');
      final form = await getLastModel();
      return form;
    }
  }

  // Future<void> createFormWithFields(
  //   formId,
  //   List<Map<String, dynamic>> fields,
  // ) async {
  //   final database = await _db.database;
  //   await database.transaction((txn) async {
  //     final formId = await txn.insert(Constants.formsTable, form);
  //     for (final field in fields) {
  //       await txn.insert(Constants.formFieldsTable, {
  //         'label': 'prueba',
  //         'form_id': formId,
  //         'field_type_id': field['field_type_id'],
  //       });
  //     }
  //   });
  // }

  Future<void> createFormFields(
    int formId,
    List<Map<String, int>> fieldsData,
  ) async {
    final database = await _db.database;

    if (_networkController.isConnected) {
      dev.log('saved data into API');
      Get.toNamed(AppRouter.home);
      return;
    }

    await database.transaction((txn) async {
      for (final fieldId in fieldsData) {
        await txn.insert(Constants.formFieldsTable, {
          'form_id': formId,
          'field_type_id': fieldId['field_type_id'],
        });
      }
    });
    dev.log('Created form fields', name: 'FORM_SERVICE');
    Get.toNamed(AppRouter.home);
  }

  Future<List<FormModel>> getForms() async {
    final database = await _db.database;
    final forms = await database.query(Constants.formsTable);
    dev.log('Fetched forms: $forms', name: 'FORM_SERVICE');
    final formsList = forms.map((form) => FormModel.fromJson(form)).toList();
    return formsList;
  }

  Future<FormModel> getForm(int id) async {
    final database = await _db.database;
    final form = await database.query(
      Constants.formsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    final fields = await database.query(
      Constants.formFieldsTable,
      where: 'form_id = ?',
      whereArgs: [id],
    );

    final formMap = form.first;
    formMap['fields'] = fields;
    return FormModel.fromJson(formMap);
  }

  Future<FormModel> getLastModel() async {
    final database = await _db.database;
    final formList = await database.query(
      Constants.formsTable,
      orderBy: 'id DESC',
      limit: 1,
    );

    final form = formList.first;
    return FormModel.fromJson(form);
  }

  Future<List<FieldTypeModel>> getFormFieldsTypes() async {
    final fieldsDb = await _db.getData(Constants.fieldTypesTable);

    final fields =
        fieldsDb.map((field) => FieldTypeModel.fromJson(field)).toList();
    return fields;
  }

  Future<List<FormFieldModel>> getFormFields(int formId) async {
    final database = await _db.database;
    final fields = await database.query(
      Constants.formFieldsTable,
      where: 'form_id = ?',
      whereArgs: [formId],
    );

    final fieldsList = await Future.wait(
      fields.map((field) async {
        final fieldType = await database.query(
          Constants.fieldTypesTable,
          where: 'id = ?',
          whereArgs: [field['field_type_id']],
        );

        final mutableField = Map<String, dynamic>.from(field);

        mutableField['type'] = fieldType.first;

        return FormFieldModel.fromJson(mutableField);
      }).toList(),
    );

    return fieldsList;
  }
}
