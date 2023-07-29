// import 'package:firebase_user_notes/domain/bloc/notes/notes_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../domain/bloc/notes/notes_bloc.dart';
// import '../../domain/bloc/notes/notes_event.dart';
//
// class NoteWidget extends StatelessWidget {
//   final VoidCallback onDelete;
//   final VoidCallback onEdit;
//   final LoadedNotesState state;
//   final int index;
//
//   const NoteWidget({super.key, required this.onDelete, required this.onEdit, required this.state, required this.index});
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (context) {
//       return Column(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: const Color(0xff03ecd4),
//             ),
//             child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: Text(
//                         state.notes[index].text,
//                         style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[850]),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit),
//                           constraints: const BoxConstraints(maxWidth: 25),
//                           onPressed: () {
//                             _showUpdateDialog(state, index, context);
//                             //widget.notesRepository.edit(_textController.text, note.path);
//                           },
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete),
//                           onPressed: () async {
//                             context.read<NotesBloc>().add(
//                               (DeleteNoteEvent(path: state.notes[index].path)),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 )),
//           ),
//         ],
//       );
//     });
//   }
//   Future _showUpdateDialog(LoadedNotesState state, int index, BuildContext contextBloc) {
//     String editError = '';
//     return
//       showGeneralDialog(
//       context: context,
//       barrierDismissible: false,
//       pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
//         final noteController = TextEditingController();
//         noteController.text = state.notes[index].text;
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               scrollable: true,
//               title: const Text('Редактировать'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: noteController,
//
//                     // decoration: Theme.of(context).inputDecorationTheme.enabledBorder.copyWith()
//                     decoration: const InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 3,
//                           color: Color(0xff00d30d),
//                           style: BorderStyle.solid,
//                         ),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(20),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     setState(() {
//                       _textController.clear();
//                     });
//                   },
//                   child: const Text('Отменить'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     var color = Colors.red;
//                     if (noteController.text.isEmpty) {
//                       editError = 'Необходимо заполнить поля';
//                     } else {
//                       contextBloc.read<NotesBloc>().add(
//                         (EditNoteEvent(text: noteController.text, path: state.notes[index].path)),
//                       );
//                       editError = 'Заметка успешно изменена';
//                       color = Colors.green;
//                       Navigator.pop(context);
//                     }
//                     setState(() {});
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(editError),
//                         backgroundColor: color,
//                       ),
//                     );
//                   },
//                   child: const Text('Сохранить'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
//
// //
// // Widget _buildNote(LoadedNotesState state, int index) {
// //   return Builder(builder: (context) {
// //     return Column(
// //       children: [
// //         Container(
// //           width: MediaQuery.of(context).size.width,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(10),
// //             color: const Color(0xff03ecd4),
// //           ),
// //           child: Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.only(left: 8.0),
// //                     child: Text(
// //                       state.notes[index].text,
// //                       style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[850]),
// //                     ),
// //                   ),
// //                   Row(
// //                     children: [
// //                       IconButton(
// //                         icon: const Icon(Icons.edit),
// //                         constraints: const BoxConstraints(maxWidth: 25),
// //                         onPressed: () {
// //                           _showUpdateDialog(state, index, context);
// //                           //widget.notesRepository.edit(_textController.text, note.path);
// //                         },
// //                       ),
// //                       IconButton(
// //                         icon: const Icon(Icons.delete),
// //                         onPressed: () async {
// //                           context.read<NotesBloc>().add(
// //                             (DeleteNoteEvent(path: state.notes[index].path)),
// //                           );
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               )),
// //         ),
// //       ],
// //     );
// //   });
// // }