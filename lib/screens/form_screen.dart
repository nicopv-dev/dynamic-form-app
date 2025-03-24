import 'package:dynamic_form_app/models/form_field_model.dart';
import 'package:dynamic_form_app/models/form_model.dart';
import 'package:dynamic_form_app/services/form_service.dart';
import 'package:dynamic_form_app/widgets/form_field_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = Get.arguments as FormModel;
    final FormService formService = Get.find<FormService>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.yellow,
            expandedHeight: 140,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(form.name),
              centerTitle: true,
              background: Container(color: Colors.yellow),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<List<FormFieldModel>>(
                future: formService.getFormFields(form.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No fields available'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final field = snapshot.data![index];
                        return CustomFormFieldBuilder(field: field.type!);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
