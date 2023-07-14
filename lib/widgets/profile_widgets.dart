import 'package:flutter/material.dart';

class ProfileTextFieldView extends StatelessWidget {

  final String fieldTitle;
  final String fieldValue;
  const ProfileTextFieldView(this.fieldTitle, this.fieldValue, {super.key});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fieldTitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xff03ecd4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    fieldValue,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[850]),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}