import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_app_redesign/core/common/custom_text_form_field.dart';

class InstrumentForm extends StatefulWidget {
  // Now only accepts a normal Key which we will use as GlobalKey<InstrumentFormState>
  const InstrumentForm({Key? key}) : super(key: key);

  @override
  InstrumentFormState createState() => InstrumentFormState();
}

/// NOTE: public State class so parent can use GlobalKey<InstrumentFormState>
class InstrumentFormState extends State<InstrumentForm> {
  // internal form key (FormState)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _description = TextEditingController();
  final _codeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _sizeController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<File?> _images = [null, null, null];
  final List<String?> _base64Images = [null, null, null];

  String? _imageError;

  /// Pick image and convert to base64
  Future<void> _pickImage(int index) async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      setState(() {
        _images[index] = file;
        _base64Images[index] = base64String;
        _imageError = null;
      });
    }
  }

  /// Validate that at least one image is selected
  bool validateImages() {
    if (_images.where((img) => img != null).isEmpty) {
      setState(() {
        _imageError = "At least one image is required";
      });
      return false;
    }
    setState(() {
      _imageError = null;
    });
    return true;
  }

  /// Validate both fields and images (public method)
  bool validateForm() {
    final bool fieldsValid = _formKey.currentState?.validate() ?? false;
    final bool imagesValid = validateImages();
    return fieldsValid && imagesValid;
  }

  /// Collect form data (public method)
  Map<String, dynamic> getFormData() {
    return {
      "description": _description.text.trim(),
      "code": _codeController.text.trim(),
      "quantity": _quantityController.text.trim(),
      "size": _sizeController.text.trim(),
      "images": _base64Images.where((e) => e != null).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Image Picker Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) {
              final image = _images[index];
              return GestureDetector(
                onTap: () => _pickImage(index),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: image != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(image, fit: BoxFit.cover),
                  )
                      : const Icon(Icons.add_a_photo, size: 30, color: Colors.grey),
                ),
              );
            }),
          ),
          if (_imageError != null) ...[
            const SizedBox(height: 6),
            Text(_imageError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
          const SizedBox(height: 20),

          // --- Input Fields ---
          CustomTextFormField(
            controller: _codeController,
            hintText: "Instrument Code",
            validator: (value) => value == null || value.isEmpty ? "Enter code" : null,
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            controller: _quantityController,
            hintText: "Quantity",
            inputType: TextInputType.number,
            validator: (value) => value == null || value.isEmpty ? "Enter quantity" : null,
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            controller: _sizeController,
            hintText: "Size",
            inputType: TextInputType.text,
            validator: (value) => value == null || value.isEmpty ? "Enter Size" : null,
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            controller: _description,
            hintText: "Instrument Description",
            maxLines: 3,
            validator: (value) => value == null || value.isEmpty ? "Enter Description" : null,
          ),
          const SizedBox(height: 20),
          const Divider(),
        ],
      ),
    );
  }
}
