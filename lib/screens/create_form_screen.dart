import 'dart:developer' as dev;

import 'package:dynamic_form_app/models/field_type_model.dart';
import 'package:dynamic_form_app/services/form_service.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_form_app/widgets/form_field_builder.dart';
import 'package:get/get.dart';

class CreateFormScreen extends StatefulWidget {
  const CreateFormScreen({super.key});

  @override
  _CreateFormScreenState createState() => _CreateFormScreenState();
}

class _CreateFormScreenState extends State<CreateFormScreen> {
  List<FieldTypeModel> fields = [];
  final List<FieldTypeModel> _selectedFields = [];
  final FormService _formService = Get.find<FormService>();

  @override
  void initState() {
    super.initState();
    initiFields();
  }

  void addSelectedField(FieldTypeModel field) {
    setState(() {
      _selectedFields.add(field);
    });
  }

  void removeSelectedField(int index) {
    setState(() {
      _selectedFields.removeAt(index);
    });
  }

  void initiFields() async {
    final data = await _formService.getFormFieldsTypes();
    setState(() {
      fields = data;
    });
  }

  void openModal() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 0.8,
            minChildSize: 0.25,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Selecciona un campo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: fields.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final field = fields[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: TextButton.icon(
                            onPressed: () {
                              addSelectedField(field);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added field: ${field.name}'),
                                ),
                              );
                            },
                            label: Text(
                              field.name,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            icon: Icon(Icons.add, color: Colors.grey[700]),
                            style: TextButton.styleFrom(
                              minimumSize: const Size(
                                double.infinity,
                                60,
                              ), // Full width button
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  void saveForm() async {
    try {
      // final forms = await formService.getForms();
      final formData = {'name': 'Formulario de prueba'};
      final newForm = await _formService.createForm(formData);

      final fieldsData =
          _selectedFields.map((field) {
            return {'field_type_id': field.id};
          }).toList();

      await _formService.createFormFields(newForm.id, fieldsData);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Formulario guardado')));
      setState(() {
        _selectedFields.clear();
      });
    } catch (e) {
      dev.log('[FORM_SCREEN] Error saving form: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear Formulario',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        actions:
            _selectedFields.isEmpty
                ? []
                : [
                  IconButton(icon: const Icon(Icons.save), onPressed: saveForm),
                ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            // render selected fields
            _selectedFields.isNotEmpty
                ? Expanded(
                  child: ListView.builder(
                    itemCount: _selectedFields.length,
                    itemBuilder: (context, index) {
                      final field = _selectedFields[index];
                      return Row(
                        children: [
                          Expanded(child: CustomFormFieldBuilder(field: field)),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => removeSelectedField(index),
                          ),
                        ],
                      );
                    },
                  ),
                )
                : const Center(
                  child: Text(
                    'No hay campos seleccionados',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openModal(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
