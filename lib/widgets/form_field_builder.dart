import 'package:dynamic_form_app/models/field_type_model.dart';
import 'package:flutter/material.dart';

class CustomFormFieldBuilder extends StatelessWidget {
  final FieldTypeModel field;

  const CustomFormFieldBuilder({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    Widget formField;

    switch (field.name) {
      case 'text':
        formField = TextFormField(
          decoration: InputDecoration(
            labelText: field.name,
            hintText: field.name,
            prefixIcon: Icon(
              Icons.text_fields_rounded,
              size: 16,
            ), // Ajusta al tamaño del texto
            prefixIconConstraints: BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ), //
            filled: true,
            fillColor: Colors.grey[200],
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 16, color: Colors.black),
          readOnly: true,
        );
        break;
      case 'number':
        formField = TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.format_list_numbered,
              size: 16,
            ), // Ajusta al tamaño del texto
            prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
            labelText: field.name,
            hintText: field.name,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 16, color: Colors.black),
        );
        break;
      // case 'dropdown':
      //   formField = DropdownButtonFormField<String>(
      //     decoration: InputDecoration(
      //       labelText: field.name,
      //       border: InputBorder.none,
      //       contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      //     ),
      //     items: field.options.map<DropdownMenuItem<String>>((String value) {
      //       return DropdownMenuItem<String>(
      //         value: value,
      //         child: Text(value),
      //       );
      //     }).toList(),
      //     onChanged: (String? newValue) {},
      //   );
      //   break;
      case 'image':
        formField = GestureDetector(
          onTap: () {
            // Handle image selection
          },
          child: Container(
            height: 150,
            color: Colors.grey[200],
            child: Center(child: Text('Tap to select image')),
          ),
        );
        break;
      case 'date':
        formField = TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.calendar_today, size: 16),
            prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
            labelText: field.name,
            hintText: 'Select date',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              // Handle date selection
            }
          },
        );
        break;
      case 'checkbox':
        formField = CheckboxListTile(
          title: Text(field.name),
          value: false,
          onChanged: (bool? newValue) {},
        );
        break;
      default:
        formField = Text('Unsupported field type');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        color: Colors.grey[200], // Change background color here
        child: formField,
      ),
    );
  }
}
