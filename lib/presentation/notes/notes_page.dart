import 'package:firebase_user_notes/domain/bloc/subscription/subscription_event.dart';
import 'package:firebase_user_notes/presentation/notes/notes_widgets.dart';
import 'package:firebase_user_notes/presentation/notes/subscription_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_user_notes/di/config.dart';
import 'package:firebase_user_notes/domain/bloc/notes/notes_bloc.dart';
import 'package:firebase_user_notes/domain/bloc/notes/notes_event.dart';
import 'package:firebase_user_notes/domain/bloc/notes/notes_state.dart';
import 'package:firebase_user_notes/domain/bloc/subscription/subscription_bloc.dart';
import 'package:firebase_user_notes/domain/bloc/subscription/subscription_state.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _blocNotes = getIt<NotesBloc>();
  final _blocSubscription = getIt<SubscriptionBloc>();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  _setCurrentScreen() async {
    await FirebaseAnalytics.instance.setCurrentScreen(
      screenName: 'NotesPage',
      screenClassOverride: 'NotesPage',
    );
  }

  @override
  void initState() {
    _setCurrentScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'assets/bg2.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: _buildContent(),
          ),
        ));
  }

  Widget _buildContent() {
    return BlocProvider(
      create: (_) => _blocSubscription,
      child: BlocListener<SubscriptionBloc, SubscriptionState>(
        listenWhen: (previous, current) {
          if (previous is SubscriptionErrorState && current is LoadingSubscriptionState) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Оплата не прошла'),
              backgroundColor: Colors.red,
            ),
          );
        },
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            return switch (state) {
              LoadingSubscriptionState() => const Center(
                  child: CircularProgressIndicator(),
                ),
              InactiveSubscriptionState() => _buildPremiumInactive(context, state),
              ActiveSubscriptionState() => _buildPremiumActive(context, state),
              SubscriptionErrorState() => _buildPaymentError(context, state),
            };
          },
        ),
      ),
    );
  }

  Widget _buildPremiumInactive(BuildContext context, InactiveSubscriptionState state) {
    return ActivateSubscriptionWidget(
      onActivate: () {
        context.read<SubscriptionBloc>().add(
              (SubscribeEvent()),
            );
      },
    );
  }

  Widget _buildPremiumActive(BuildContext context, ActiveSubscriptionState state) {
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

  Widget _buildPaymentError(BuildContext context, SubscriptionErrorState state) {
    context.read<SubscriptionBloc>().add(
          (CheckSubscriptionEvent()),
        );
    return const Center(
      child: CircularProgressIndicator(),
    );
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
            AddNoteWidget(onPressed: (String text) async {
              context.read<NotesBloc>().add(
                    (AddNoteEvent(text: text)),
                  );
              await FirebaseAnalytics.instance.logEvent(name: 'add_note', parameters: {'text': text});

            }),
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
                      // title: _buildNote(state, index),
                      title: NoteWidget(
                        onDelete: () {
                          context.read<NotesBloc>().add(
                                (DeleteNoteEvent(path: state.notes[index].path)),
                              );
                        },
                        onEdit: (String text) {
                          context.read<NotesBloc>().add(
                                (EditNoteEvent(text: text, path: state.notes[index].path)),
                              );
                        },
                        text: state.notes[index].text,
                        index: index,
                      ),
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
}
