import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_notes/domain/model/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:firebase_user_notes/data/repositories/auth_repository.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../data/repositories/notes_repository.dart';
import '../../di/config.dart';
import '../../domain/bloc/notes/notes_bloc.dart';
import '../../domain/bloc/notes/notes_event.dart';
import '../../domain/bloc/notes/notes_state.dart';
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

  final _bloc = getIt<NotesBloc>();
  final NotesInteractor _interactor = getIt<NotesInteractor>();

  bool paymentLoading = false;
  bool paymentComplete = true; //false;
  bool paymentLoadingCheck = false;
  int premiumDeadline = 0;
  int premiumDuration = 30;
  User fbUser = FirebaseAuth.instance.currentUser!;
  int _start = 0;
  int _current = 0;
  Timer? _timer;

  @override
  void dispose() {
    _textController.dispose();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  initState() {
    getCheckPremium(context, email: fbUser.email!);
    super.initState();
    _textController.addListener(() {
      setState(() {});
    });
  }

  void startTimer() {
    //var duration = Duration(seconds: seconds);
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(
      duration,
      (Timer timer) => setState(() {
        if (_current <= 0) {
          timer.cancel();
          paymentComplete = false;
          // Здесь можно добавить код, который выполнится, когда таймер достигнет нуля
        } else {
          _current--;
        }
      }),
    );
  }

  void resetTimer() {
    _timer!.cancel();
    setState(() {
      _current = _start;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //getStripeUser
                paymentLoadingCheck
                    ? const Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      )
                    : paymentComplete
                        ? _buildPremiumActive()
                        : _buildPremiumInactive(context),
                // _buildPremiumActive(),
                // paymentComplete ? _buildPremiumActive() : _buildPremiumInactive(context),
              ],
            ),
          ),
        ));
  }

  Widget _buildNotes() {
    return BlocProvider(
      create: (_) => _bloc,
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          return switch (state) {
            LoadingNotesState() => const Center(
                child: CircularProgressIndicator(),
              ),
            LoadedNotesState() => _buildNotesBloc(state),
            NotesErrorState() => const Center(
                child: Text('Ошибка'),
              ),
          };
        },
      ),
    );
  }

  Widget _buildNotesBloc(LoadedNotesState state) {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff03ecd4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            //width: MediaQuery.of(context).size.width * 0.80,
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Чтобы использовать заметки, купите Premium подписку. Стоимость \$20 - после оплаты Premium активен ${premiumDuration} секунд.",
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
                    //backgroundColor: MaterialStateProperty.all<Color>(Color(0xff00c003)),
                  ),
                  onPressed: () {
                    setState(() {
                      //paymentLoading = true;
                      paymentLoadingCheck = true;
                    });
                    initPaymentSheet(context, email: fbUser.email!, amount: 2000);
                  },
                  child: const Text(
                    'Купить Premium',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                paymentLoading
                    ? const SizedBox(
                        height: 20,
                      )
                    : const SizedBox(),
                paymentLoading ? const CircularProgressIndicator() : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumActive() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xfffdc40c),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Text(
                      'Premium подписка истекает через: ',
                    ),
                    Text(
                      '$_current секунд',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildNotes(),
        ],
      ),
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

  Future<void> getCheckPremium(context, {required String email}) async {
    setState(() {
      paymentLoadingCheck = true;
    });
    try {
      // 1. create payment intent on the server
      final response = await http.post(
          Uri.parse(
            urlFunctionCheckPremium,
          ),
          body: {
            'email': email,
            'premiumDuration': '$premiumDuration',
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());

      setState(() {
        paymentLoading = false;
        paymentLoadingCheck = false;
        premiumDeadline = (jsonResponse['premiumDeadline'] - jsonResponse['now'] + 6000) > 0 ? jsonResponse['premiumDeadline'] - jsonResponse['now'] + 6000 : 0;
//print(premiumDeadline);
        if (premiumDeadline > 0) {
          paymentComplete = true;
          _current = (premiumDeadline / 1000).round();
          startTimer();
          //_start = (premiumDeadline/1000).round();
        } else {
          // _start = 0;
          _current = 0;
          if (_timer != null) resetTimer();
        }
      });
    } catch (e) {
      setState(() {
        paymentLoading = false;
      });
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

  Future<void> initPaymentSheet(context, {required String email, required int amount}) async {
    try {
      // 1. create payment intent on the server
      final response = await http.post(
          Uri.parse(
            urlFunctionPaymentIntentRequest,
          ),
          body: {
            'email': email,
            'amount': amount.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      Stripe.instance.resetPaymentSheetCustomer();
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
        paymentComplete = true;
        getCheckPremium(context, email: email);
        // _current = premiumDuration;
        // startTimer();
        // _start = 0;
      });
    } catch (e) {
      setState(() {
        paymentLoading = false;
      });

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
