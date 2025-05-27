import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedMood;
  File? _selectedImage;

  final List<String> moods = ['Happy', 'Chill', 'Productive', 'Romantic'];

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _onSubmit() {
    if (_captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Caption tidak boleh kosong.')),
      );
      return;
    }

    Navigator.pop(context, {
      'caption': _captionController.text.trim(),
      'mood': _selectedMood,
      'location': _locationController.text.trim(),
      'imageFile': _selectedImage,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Postingan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(labelText: 'Caption'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedMood,
              hint: const Text('Pilih Mood'),
              items: moods.map((mood) {
                return DropdownMenuItem(value: mood, child: Text(mood));
              }).toList(),
              onChanged: (value) => setState(() => _selectedMood = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Lokasi'),
            ),
            const SizedBox(height: 12),
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 150)
                : const SizedBox(),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Upload Gambar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text('Posting'),
            ),
          ],
        ),
      ),
    );
  }
}
