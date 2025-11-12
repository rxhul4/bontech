import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_bar_widget.dart';
import 'package:sales_app_redesign/core/common_statefull_widget/app_scaffold.dart';
import 'package:sales_app_redesign/core/constants/app_size_constants.dart';
import 'package:sales_app_redesign/core/storage/preference_helper.dart';
import 'package:sales_app_redesign/features/genral/instruments/pages/widgets/instrument_form.dart';

class AddInstrumentsScreen extends StatefulWidget {
  const AddInstrumentsScreen({super.key});

  @override
  State<AddInstrumentsScreen> createState() => _AddInstrumentsScreenState();
}

class _AddInstrumentsScreenState extends State<AddInstrumentsScreen> {
  // Now we store keys targeted at the InstrumentFormState
  List<int> formList = [0];
  List<GlobalKey<InstrumentFormState>> formKeys = [GlobalKey<InstrumentFormState>()];

  /// Add a new instrument form dynamically
  void _addInstrumentForm() {
    setState(() {
      formList.add(formList.length);
      formKeys.add(GlobalKey<InstrumentFormState>());
    });
  }

   _saveInstrumentsLocally(List<Map<String, dynamic>> instruments) async {
    PreferenceHelper.setString('instruments', jsonEncode(instruments));
    debugPrint("💾 Instruments saved locally: $instruments");
  }

  /// Validate all forms and collect data
  void _submitForms() async {
    bool allValid = true;
    List<Map<String, dynamic>> instruments = [];

    for (int i = 0; i < formKeys.length; i++) {
      final formState = formKeys[i].currentState;

      if (formState == null) {
        allValid = false;
        continue;
      }

      // Use dynamic call to access custom methods from InstrumentFormState
      final isValid = (formState as dynamic).validateForm();

      if (isValid) {
        final data = (formState as dynamic).getFormData();
        instruments.add(data);
      } else {
        allValid = false;
      }
    }

    if (allValid) {
      await _saveInstrumentsLocally(instruments);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ All forms valid! Data saved locally.")),
      );

      debugPrint("📦 Final Instruments Data: $instruments");
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Please fix the errors before submitting.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, appBarSize),
        child: const AppBarWidget(
          isBackVisible: true,
          title: "INSTRUMENTS",
          isCartVisible: false,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: formList.length + 1,
              itemBuilder: (context, index) {
                if (index == formList.length) {
                  // Add button
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: _addInstrumentForm,
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Add Instrument",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Each form — pass the GlobalKey<InstrumentFormState> as the widget key
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InstrumentForm(
                      key: formKeys[index],
                    ),
                  );
                }
              },
            ),
          ),

          /// Sticky Submit Button
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: _submitForms,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
