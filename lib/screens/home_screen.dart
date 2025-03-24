import 'package:dynamic_form_app/app/app_router.dart';
import 'package:dynamic_form_app/services/form_service.dart';
import 'package:dynamic_form_app/widgets/form_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormService>(
      builder:
          (formService) => Scaffold(
            appBar: AppBar(title: const Text('DynamicForm App')),
            body: FutureBuilder(
              future: formService.getForms(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay formularios creados aun',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx, index) {
                    final form = snapshot.data![index];
                    return FormCard(form: form);
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.toNamed(AppRouter.createForm),
              child: const Icon(Icons.add),
            ),
          ),
    );
  }
}
