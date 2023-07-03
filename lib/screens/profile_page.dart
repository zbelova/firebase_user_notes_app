import 'package:firebase_user_notes/firebase/auth_repository.dart';
import 'package:firebase_user_notes/firebase/notes_repository.dart';
import 'package:firebase_user_notes/model/user_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_user_notes/model/user_entity.dart';
import 'package:intl/intl.dart';
import '../firebase/profiles_repository.dart';
import '../model/user_preferences.dart';
import '../main.dart';
import 'edit_profile_page.dart';

import 'login_page.dart';
import 'notes_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key}) {
    //user = user ?? UserPreferences().getUserObject(); //если не передан пользователь в качестве аргумента, то открывается страница текущего пользователя приложения
  }

  @override
  Widget build(BuildContext context) {
    return PersonWidget();
  }
}

class PersonWidget extends StatefulWidget {
  //bool myPage;
  final ProfilesRepository profilesRepository = ProfilesRepository();

  PersonWidget({super.key});

  @override
  State<PersonWidget> createState() => _PersonWidgetState();
}

class _PersonWidgetState extends State<PersonWidget> {
  UserModel _user = UserModel();

  int id = 0;

  @override
  void initState() {
    //id = UserPreferences().getLoggedInUserId();
    widget.profilesRepository.read().listen((_handleDataEvent));
    super.initState();
  }

  void _handleDataEvent(UserModel user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
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
              return _buildPortraitProfile(context, _user);
            } else {
              return _buildLandscapeProfile(context, _user);
            }
          },
        ),
        // return const Center(
        //   child: CircularProgressIndicator(),
        // );
      ),
    );
  }

  Future<UserEntity?> buildById() async {
    if (id > 0) {
      return objectbox.getById(id);
    } else {
      return null;
    }
  }

  Widget _buildLandscapeProfile(BuildContext context, UserModel user) => CupertinoScrollbar(child: LayoutBuilder(builder: (context, constraints) {
        return ListView(
          children: [
            Padding(
              padding: constraints.maxWidth > 1000 ? const EdgeInsets.only(top: 15) : const EdgeInsets.only(top: 15, left: 35),
              child: Row(
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
                        _buildTopImage(user),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileTextFieldView("Имя", user.name!),
                          if (user.city.isNotEmpty) _buildProfileTextFieldView("Город", user.city),
                          if (user.birthDate.isNotEmpty) _buildProfileTextFieldView("Дата рождения", user.birthDate),
                          if (user.aboutSelf.isNotEmpty) _buildProfileTextFieldView("О себе", user.aboutSelf),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 22,
                        ),
                        editButton(context, user),
                        const SizedBox(
                          height: 10,
                        ),
                        logoutButton(context),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }));

  Widget _buildPortraitProfile(BuildContext context, UserModel user) => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                editButton(context, user),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTopImage(user),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileTextFieldView("Имя", user.name),
                if (user.city.isNotEmpty) _buildProfileTextFieldView("Город", user.city),
                //if (user.birthDate.isNotEmpty) _buildProfileTextFieldView("Дата рождения", user.birthDate ),
                if (user.aboutSelf.isNotEmpty) _buildProfileTextFieldView("О себе", user.aboutSelf),
              ],
            ),
          )
        ],
      );

  ElevatedButton logoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        UserPreferences().setLoggedIn(false);
        UserPreferences().setLoggedInUserId(0);
        AuthRepository.logout();
        //UserPreferences().setRememberLoggedIn(false);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      authRepository: AuthRepository(),
                    )),
            (Route<dynamic> route) => false);
      },
      //child: Text("Выйти"),
      child: const Icon(Icons.logout),
    );
  }

  ElevatedButton editButton(BuildContext context, UserModel user) {
    return ElevatedButton(
      onPressed: () async {
        if (mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(
                authRepository: AuthRepository(),
              ),
            ),
          );
        }
        // setState(() {
        //   // user = data;
        // });
      },
      //child: Text("Редактировать"),

      child: const Icon(Icons.edit),
    );
  }

  Row _buildProfileTextFieldView(String fieldTitle, String fieldValue) {
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

  Widget _buildTopImage(UserModel user) => SizedBox(
        width: 200,
        child: user.buildPhotoImage(),
      );
}
