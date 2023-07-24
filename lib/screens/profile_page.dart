import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_notes/data/repositories/auth_repository.dart';
import 'package:firebase_user_notes/data/repositories/notes_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/config.dart';
import '../domain/bloc/profile_bloc.dart';
import '../domain/model/user_model.dart';
import '../globals/widgets/display_widgets.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';
import 'notes_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //final UserModel _user = UserModel();
  final bool loggedIn = FirebaseAuth.instance.currentUser != null ? true : false;
  final _cubit = getIt<ProfileCubit>();

  @override
  void initState() {
    //_user = widget.profilesRepository.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: _content(),
    );
  }

  Widget _content() => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: AppBar(
            title: const Text('Профиль'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 50,
          margin: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotesPage(
                      notesRepository: NotesRepository(),
                      authRepository: AuthRepository(),
                    ),
                  ),
                );
              }
            },
            child: const Center(
              child: Text('Мои заметки'),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'lib/assets/bg2.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return _buildPortraitProfile(context);
                } else {
                  return _buildLandscapeProfile(context);
                }
              },
            ),
          ),
        ),
      );

  Widget _buildLandscapeProfile(BuildContext context) => CupertinoScrollbar(child: LayoutBuilder(builder: (context, constraints) {
        return ListView(
          children: [
            Padding(
              padding: constraints.maxWidth > 1000 ? const EdgeInsets.only(top: 15) : const EdgeInsets.only(top: 15, left: 35),
              child: BlocBuilder<ProfileCubit, ProfileState>(builder: (ctx, state) {
                if (state is LoadedProfileState) {
           //       print('state.user = ${state.user}');
             //     print('state = $state');
                  // Показываем список, когда юзер подргрузился
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            _buildTopImage(state.user),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: _buildProfileFields(state),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 22,
                            ),
                            editButton(context),
                            const SizedBox(
                              height: 10,
                            ),
                            logoutButton(context),
                          ],
                        ),
                      )
                    ],
                  );
                } else {
            //      print('state = $state');
                  // Вначале показываем виджет с загрузкой
                  ctx.read<ProfileCubit>().fetchData();
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            ),
          ],
        );
      }));

  Widget _buildPortraitProfile(BuildContext context) {
    // print('user = $user');
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              editButton(context),
              const SizedBox(
                width: 10,
              ),
              logoutButton(context),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (ctx, state) {
            if (state is LoadedProfileState) {
              //print('state.user = ${state.user}');
              // Показываем список, когда юзер подргрузился
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTopImage(state.user),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: _buildProfileFields(state),
                  ),
                ],
              );
            } else {
              // Вначале показываем виджет с загрузкой
              ctx.read<ProfileCubit>().fetchData();
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }

  Widget _buildProfileFields(LoadedProfileState state) {
 //   print('state.user = ${state.user}');
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileTextFieldView("Email", state.user.email),
        if (state.user.name.isNotEmpty) ProfileTextFieldView("Имя", state.user.name),
        if (state.user.phone != '+7') ProfileTextFieldView("Телефон", state.user.phone),
        if (state.user.city.isNotEmpty) ProfileTextFieldView("Город", state.user.city),
        if (state.user.birthDate.isNotEmpty) ProfileTextFieldView("Дата рождения", state.user.birthDate),
        if (state.user.aboutSelf.isNotEmpty) ProfileTextFieldView("О себе", state.user.aboutSelf),
      ],
    );
  }

  ElevatedButton logoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        AuthRepository.logout();
        //UserPreferences().setRememberLoggedIn(false);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
      },
      //child: Text("Выйти"),
      child: const Icon(Icons.logout),
    );
  }

  ElevatedButton editButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(),
            ),
          );
        }
      },
      //child: Text("Редактировать"),

      child: const Icon(Icons.edit),
    );
  }

  Widget _buildTopImage(UserModel user) {
   print('user = $user');
    return SizedBox(
      width: 200,
      child: PhotoImage(
        photoURL: user.photo,
      ),
    );
  }
}
