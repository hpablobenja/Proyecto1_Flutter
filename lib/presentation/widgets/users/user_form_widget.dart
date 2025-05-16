import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/users/user_form_provider.dart';
import '../../../domain/entities/user.dart';

class UserFormWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userFormProvider);

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Nombre'),
          onChanged: (value) {
            if (user != null) {
              ref
                  .read(userFormProvider.notifier)
                  .setUser(
                    User(
                      id: user.id,
                      identificationCode: user.identificationCode,
                      name: value,
                      type: user.type,
                    ),
                  );
            }
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Código de Identificación'),
          onChanged: (value) {
            if (user != null) {
              ref
                  .read(userFormProvider.notifier)
                  .setUser(
                    User(
                      id: user.id,
                      identificationCode: value,
                      name: user.name,
                      type: user.type,
                    ),
                  );
            }
          },
        ),
      ],
    );
  }
}
