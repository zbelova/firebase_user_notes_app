import 'package:firebase_user_notes/model/note_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:firebase_user_notes/firebase/auth_repository.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../firebase/notes_repository.dart';
import '../keys.dart';

//TODO: передача репозитория, чтобы отображался профиль после возврата с экрана заметок

class NotesPage extends StatefulWidget {
  final NotesRepository notesRepository;
  final AuthRepository authRepository;

  const NotesPage({Key? key, required this.notesRepository, required this.authRepository}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _textController = TextEditingController();

  List<NoteModel> _notes = [];
  bool paymentLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  initState() {
    widget.notesRepository.readAll().listen((_handleDataEvent));

    super.initState();
    _textController.addListener(() {
      setState(() {});
    });
  }

  void _handleDataEvent(List<NoteModel> notes) {
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _addNote() async {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите текст заметки'),
        ),
      );
    } else {
      await widget.notesRepository.write(_textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: AppBar(
            title: const Text('Мои заметки'),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'lib/assets/bg2.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    setState(() {
                      paymentLoading = true;
                    });
                    initPaymentSheet(context, email: "example@gmail.com", amount: 2000);
                  } ,
                  child: const Text(
                    'Купить Premium',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                paymentLoading? const CircularProgressIndicator() : const SizedBox(),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    //labelText: 'Введите заметку',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 5, top: 15),
                      child: Text(
                        "Заметка:".toUpperCase(),
                        style: TextStyle(color: Colors.grey[700]),
                        //style: TextStyle(color: Colors.blue[700]),
                      ),
                    ),
                  ),
                  controller: _textController,
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: _addNote,
                  child: const Text('Добавить заметку'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      if (_notes.isEmpty) {
                        return const Center(
                          child: Text('Заметок нет'),
                        );
                      } else {
                        return ListTile(
                          title: _buildNote(_notes[index], index),
                        );
                      }
                    },
                    itemCount: _notes.length,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildNote(NoteModel note, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff03ecd4),
      ),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  note.note,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[850]),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    constraints: const BoxConstraints(maxWidth: 25),
                    onPressed: () {
                      _showUpdateDialog(index);
                      //widget.notesRepository.edit(_textController.text, note.path);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.notesRepository.remove(note.path);
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Future _showUpdateDialog(int index) {
    String editError = '';
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (_, __, ___) {
        final noteController = TextEditingController();
        noteController.text = _notes[index].note;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Редактировать'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(hintText: 'Текст заметки'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _textController.clear();
                    });
                  },
                  child: const Text('Отменить'),
                ),
                TextButton(
                  onPressed: () {
                    if (noteController.text.isEmpty) {
                      editError = 'Необходимо заполнить поля';
                    } else {
                      widget.notesRepository.edit(noteController.text, _notes[index].path);
                      editError = 'Заметка успешно изменена';
                      Navigator.pop(context);
                    }
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(editError),
                      ),
                    );
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> initPaymentSheet(context, {required String email, required int amount}) async {
    try {
      // 1. create payment intent on the server
      final response = await http.post(
          Uri.parse(
            urlFunctions,
          ),
          body: {
            'email': email,
            'amount': amount.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());

      //2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'Space Notes',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          style: ThemeMode.light,
        ),
      );


      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Оплата прошла успешно!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        paymentLoading = false;
      });
    } catch (e) {
      log(e.toString());
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
