import 'package:dynamic_form_app/app/app_router.dart';
import 'package:dynamic_form_app/models/form_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormCard extends StatelessWidget {
  final FormModel form;

  const FormCard({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRouter.form, arguments: form),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            Icon(Icons.library_books_sharp, size: 40, color: Colors.yellow),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '24/05/25',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text('${form.name} ${form.id}'),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}
