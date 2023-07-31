import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_notes/domain/bloc/subscription/subscription_event.dart';
import 'package:firebase_user_notes/presentation/notes/subscription_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../di/config.dart';
import '../../domain/bloc/notes/notes_bloc.dart';
import '../../domain/bloc/notes/notes_event.dart';
import '../../domain/bloc/notes/notes_state.dart';
import '../../domain/bloc/subscription/subscription_bloc.dart';
import '../../domain/bloc/subscription/subscription_state.dart';
import '../../domain/interactor/notes_interactor.dart';
import '../../keys.dart';
import 'notes_widgets.dart';

//TODO: решить проблему с mounted
//TODO: проверять есть ли юзер в базе данных страйп (добавить в functions)

class NotesPage extends StatefulWidget {
  //final NotesRepository notesRepository;
  // final AuthRepository authRepository;

  const NotesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _textController = TextEditingController();

  final _blocNotes = getIt<NotesBloc>();
  final _blocSubscription = getIt<SubscriptionBloc>();

  //final NotesInteractor _interactor = getIt<NotesInteractor>();

  bool paymentLoading = false;
  bool paymentComplete = true; //false;
  bool paymentLoadingCheck = false;
  int premiumDeadline = 0;
  int premiumDuration = 30;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {});
    });
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
            child: BlocProvider(
              create: (_) => _blocSubscription,
              child: BlocBuilder<SubscriptionBloc, SubscriptionState>(builder: (context, state) {
                return switch (state) {
                  LoadingSubscriptionState() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ActiveSubscriptionState() => _buildPremiumActive(state),
                  InactiveSubscriptionState() => _buildPremiumInactive(context),
                  SubscriptionErrorState() => const Center(
                      child: Text('Ошибка'),
                    ),
                };
              }),
            ),
          ),
        ));
  }

  Widget _buildNotesBloc() {
    return BlocProvider(
      create: (_) => _blocNotes,
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          return switch (state) {
            LoadingNotesState() => const Center(
                child: CircularProgressIndicator(),
              ),
            LoadedNotesState() => _buildNotes(state),
            NotesErrorState() => const Center(
                child: Text('Ошибка'),
              ),
          };
        },
      ),
    );
  }

  Widget _buildNotes(LoadedNotesState state) {
    return Builder(builder: (context) {
      return Expanded(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 5, top: 15),
                    child: Text(
                      "Заметка:".toUpperCase(),
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
                controller: _textController,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                context.read<NotesBloc>().add(
                      (AddNoteEvent(text: _textController.text)),
                    );
                _textController.clear();
              },
              child: const Text('Добавить заметку'),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (state.notes.isEmpty) {
                    return const Center(
                      child: Text('Заметок нет'),
                    );
                  } else {
                    return ListTile(
                      title: _buildNote(state, index),
                      // title: NoteWidget(
                      //   onDelete: () {
                      //     context.read<NotesBloc>().add(
                      //           (DeleteNoteEvent(path: state.notes[index].path)),
                      //         );
                      //   },
                      //   onEdit: () {
                      //     _showUpdateDialog(state, index, context);
                      //   },
                      //   state: state,
                      //   index: index,
                      // ),
                    );
                  }
                },
                itemCount: state.notes.length,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPremiumInactive(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff03ecd4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Чтобы использовать заметки, купите Premium подписку. Стоимость \$10 - после оплаты Premium активен ${premiumDuration} секунд.",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () async {
                      context.read<SubscriptionBloc>().add(
                            (SubscribeEvent()),
                          );
                    },
                    child: const Text(
                      'Купить Premium',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumActive(ActiveSubscriptionState state) {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            PremiumTimerWidget(
              start: state.subscription.deadline,
              onTimerEnd: () {
                context.read<SubscriptionBloc>().add(
                  (CheckSubscriptionEvent()),
                );
              },
            ),
            _buildNotesBloc(),
          ],
        );
      }
    );
  }

  Widget _buildNote(LoadedNotesState state, int index) {
    return Builder(builder: (context) {
      return Column(
        children: [
          Container(
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
                        state.notes[index].text,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[850]),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          constraints: const BoxConstraints(maxWidth: 25),
                          onPressed: () {
                            _showUpdateDialog(state, index, context);
                            //widget.notesRepository.edit(_textController.text, note.path);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            context.read<NotesBloc>().add(
                                  (DeleteNoteEvent(path: state.notes[index].path)),
                                );
                          },
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ],
      );
    });
  }

  Future _showUpdateDialog(LoadedNotesState state, int index, BuildContext contextBloc) {
    String editError = '';
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        final noteController = TextEditingController();
        noteController.text = state.notes[index].text;
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

                    // decoration: Theme.of(context).inputDecorationTheme.enabledBorder.copyWith()
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Color(0xff00d30d),
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
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
                    var color = Colors.red;
                    if (noteController.text.isEmpty) {
                      editError = 'Необходимо заполнить поля';
                    } else {
                      contextBloc.read<NotesBloc>().add(
                            (EditNoteEvent(text: noteController.text, path: state.notes[index].path)),
                          );
                      editError = 'Заметка успешно изменена';
                      color = Colors.green;
                      Navigator.pop(context);
                    }
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(editError),
                        backgroundColor: color,
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
}
