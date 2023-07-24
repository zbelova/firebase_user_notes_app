import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileTextFieldView extends StatelessWidget {

  final String fieldTitle;
  final String fieldValue;

  const ProfileTextFieldView(this.fieldTitle, this.fieldValue, {super.key});


  @override
  Widget build(BuildContext context) {
    //  print(fieldTitle);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fieldTitle,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xff03ecd4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    fieldValue,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey[850]),
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

class PhotoImage extends StatelessWidget {
  final String? photoURL;
  final XFile? photoFile;

  const PhotoImage({super.key, this.photoURL, this.photoFile});

  @override
  Widget build(BuildContext context) {
    //print('photoURL = $photoURL');
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: const Color(0xff03ecd4), width: 5),
          //color: Colors.lightBlueAccent
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: AspectRatio(
                aspectRatio: 1,
                child: photoURL != null?

              photoURL == 'lib/assets/default.jpg'
                  ? Image.asset('lib/assets/default.jpg')
                  : FadeInImage.assetNetwork(
                placeholder: 'lib/assets/default.jpg',
                image: photoURL!,
                fit: BoxFit.cover,
              ): Image.file(File(photoFile!.path), fit: BoxFit.cover,),

            // child: photo == 'lib/assets/default.jpg'
            //     ? Image.asset('lib/assets/default.jpg')
            //     : FadeInImage.assetNetwork(
            //   placeholder: 'lib/assets/default.jpg',
            //   image: photo,
            //   fit: BoxFit.cover,
            // ),

    ),)
    ,
    );
  }
}
