import 'package:flutter/material.dart';



class PrefixWidget extends StatelessWidget {
  final String prefixText;

  const PrefixWidget(
    this.prefixText, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 5),
          child: Text(
            "$prefixText:".toUpperCase(),
            style: TextStyle(color: Colors.grey[700]),
            //style: TextStyle(color: Colors.blue[700]),
          ),
        ),
      ],
    );
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({super.key, String? title, FormFieldSetter<bool>? onSaved, FormFieldValidator<bool>? validator, bool initialValue = false, bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return Column(
                children: [
                  CheckboxListTile(
                    dense: state.hasError,
                    title: Text(
                      title!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: state.value,
                    onChanged: state.didChange,
                    // subtitle: state.hasError
                    //     ? Builder(
                    //         builder: (BuildContext context) => Text(
                    //           state.errorText ?? "",
                    //           style: TextStyle(color: Theme.of(context).colorScheme.error),
                    //         ),
                    //       )
                    //     : null,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  if (state.hasError)
                    Builder(
                      builder: (BuildContext context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          //color: Colors.red,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            child: Text(
                              state.errorText ?? "",
                              style: const TextStyle(
                                fontFamily: 'Railway',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.white,

                                //..blendMode = BlendMode.lighten,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              );
            });
}

class ProfileTextFieldView extends StatelessWidget {

  String fieldTitle;
  String fieldValue;
  ProfileTextFieldView(this.fieldTitle, this.fieldValue, {super.key});


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
