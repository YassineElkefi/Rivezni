import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/auth_provider.dart';
import 'package:rivezni/core/providers/subject_provider.dart';
import 'package:rivezni/data/models/subject.dart';
import 'package:rivezni/shared/widgets/toast.dart';

class AddSubjectForm extends StatefulWidget {
  @override
  _AddSubjectFormState createState() => _AddSubjectFormState();
}

class _AddSubjectFormState extends State<AddSubjectForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectNameController = TextEditingController();
  Color _selectedColor = Colors.blue;

  void _pickColor() async {
    Color? pickedColor = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Pick a Color",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              Navigator.of(context).pop(color);
            },
          ),
        ),
      ),
    );

    if (pickedColor != null) {
      setState(() {
        _selectedColor = pickedColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectProvider>(builder: (context, subjectProvider, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Add a Subject",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _subjectNameController,
                  decoration: InputDecoration(
                    labelText: "Subject Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the subject name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Selected Color:",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: _pickColor,
                      child: CircleAvatar(
                        backgroundColor: _selectedColor,
                        radius: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                String subjectName = _subjectNameController.text;
                String subjectColor = '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final userId = authProvider.user?.uid;

                if (userId == null) {
                  showToast(message: "User is not logged in. Please log in and try again.");
                  return;
                }

                Subject subject = Subject(
                  name: subjectName,
                  color: subjectColor,
                  userId: userId,
                );

                subjectProvider.addSubject(subject);
                Navigator.of(context).pop();
                _subjectNameController.clear();
                setState(() {
                  _selectedColor = Colors.blue;
                });

                showToast(message: "Subject Added!");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Add Subject",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      );
    });
  }
}
