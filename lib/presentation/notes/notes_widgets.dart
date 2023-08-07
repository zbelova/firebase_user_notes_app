import 'package:flutter/material.dart';

class AddNoteWidget extends StatefulWidget {
  final Function onPressed;

  const AddNoteWidget({super.key, required this.onPressed});

  @override
  State<AddNoteWidget> createState() => _AddNoteWidgetState();
}

class _AddNoteWidgetState extends State<AddNoteWidget> {
  final TextEditingController _textController = TextEditingController();

  @override
  initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              widget.onPressed(_textController.text);
              _textController.clear();
            }
          },
          child: const Text('Добавить заметку'),
        ),
      ],
    );
  }
}

class NoteWidget extends StatefulWidget {
  final VoidCallback onDelete;
  final Function onEdit;
  final int index;
  final String text;

  const NoteWidget({super.key, required this.onDelete, required this.onEdit, required this.text, required this.index});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.text;
  }

  @override
  void dispose() {
    //_noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      widget.text,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[850]),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        constraints: const BoxConstraints(maxWidth: 25),
                        onPressed: () {
                          _showUpdateDialog(widget.text, widget.index, context);
                          //widget.notesRepository.edit(_textController.text, note.path);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          widget.onDelete();
                        },
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Future _showUpdateDialog(String text, int index, BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        _noteController.text = text;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Редактировать'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _noteController,
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
                  },
                  child: const Text('Отменить'),
                ),
                TextButton(
                  onPressed: () {
                    if (_noteController.text.isEmpty) {
                      var color = Colors.red;
                      var editError = 'Необходимо заполнить поля';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(editError),
                          backgroundColor: color,
                        ),
                      );
                    } else {
                      widget.onEdit(_noteController.text);
                      // contextBloc.read<NotesBloc>().add(
                      //       (EditNoteEvent(text: _noteController.text, path: state.notes[index].path)),
                      //     );
                      Navigator.pop(context);
                    }
                    setState(() {});
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
