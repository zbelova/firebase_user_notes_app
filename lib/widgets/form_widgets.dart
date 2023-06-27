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
          padding: EdgeInsets.only(left: 20, right: 5),
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
  CheckboxFormField({String? title, FormFieldSetter<bool>? onSaved, FormFieldValidator<bool>? validator, bool initialValue = false, bool autovalidate = false})
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
                      style: TextStyle(color: Colors.white),
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
//
// CheckboxListTile(
//
// value: _approve,
// onChanged: (bool? value) {
// setState(() => _approve = value!);
// });
