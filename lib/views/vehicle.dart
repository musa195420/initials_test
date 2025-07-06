import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/providers/vehicle_provider.dart';

class AddVehiclePage extends ConsumerStatefulWidget {
  const AddVehiclePage({super.key});

  @override
  ConsumerState<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends ConsumerState<AddVehiclePage> {
  final _formKey = GlobalKey<FormState>();

  final _typeCtl = TextEditingController();
  final _makeCtl = TextEditingController();
  final _modelCtl = TextEditingController();
  final _variantCtl = TextEditingController();
  final _plateCtl = TextEditingController();

  @override
  void dispose() {
    _typeCtl.dispose();
    _makeCtl.dispose();
    _modelCtl.dispose();
    _variantCtl.dispose();
    _plateCtl.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins1',
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
        prefixIcon: Icon(icon, color: Colors.orange),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleProvider);
    final actions = ref.read(vehicleProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: LayoutBuilder(builder: (context, c) {
        final maxW = c.maxWidth, maxH = c.maxHeight;
        final header = min(maxH * .18, 150);
        final logoW = min(maxW * .30, 120);
        final hPad = maxW < 500
            ? 16
            : maxW < 800
                ? 32
                : 64;

        return Stack(
          children: [
            _Header(height: header.toDouble(), logoW: logoW.toDouble()),
            _WhiteSheet(offset: header - 20),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: hPad.toDouble())
                  .add(EdgeInsets.only(top: header - 60, bottom: 40)),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      SizedBox(height: header / 4),
                      _FormCard(
                        formKey: _formKey,
                        dec: _dec,
                        typeCtl: _typeCtl,
                        makeCtl: _makeCtl,
                        modelCtl: _modelCtl,
                        variantCtl: _variantCtl,
                        plateCtl: _plateCtl,
                        actions: actions,
                        state: state,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state.isSubmitting)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.height, required this.logoW});
  final double height, logoW;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6F3C), Color(0xFFe74b1a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      alignment: Alignment.center,
      child: Image.asset('assets/images/logo.png', width: logoW),
    );
  }
}

class _WhiteSheet extends StatelessWidget {
  const _WhiteSheet({required this.offset});
  final double offset;

  @override
  Widget build(BuildContext context) => Positioned.fill(
        top: offset,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
        ),
      );
}

class _FormCard extends ConsumerWidget {
  const _FormCard({
    required this.formKey,
    required this.dec,
    required this.typeCtl,
    required this.makeCtl,
    required this.modelCtl,
    required this.variantCtl,
    required this.plateCtl,
    required this.actions,
    required this.state,
  });

  final GlobalKey<FormState> formKey;
  final InputDecoration Function(String, IconData) dec;
  final TextEditingController typeCtl, makeCtl, modelCtl, variantCtl, plateCtl;
  final dynamic actions;
  final dynamic state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Vehicle',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  fontFamily: 'Poppins1',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: typeCtl,
                onChanged: actions.setVehicleType,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter vehicle type' : null,
                decoration: dec('Vehicle Type', Icons.directions_car),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: makeCtl,
                onChanged: actions.setMake,
                decoration: dec('Make (optional)', Icons.factory),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: modelCtl,
                onChanged: actions.setModel,
                decoration: dec('Model (optional)', Icons.build),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: variantCtl,
                onChanged: actions.setVariant,
                decoration: dec('Variant (optional)', Icons.settings),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: plateCtl,
                onChanged: actions.setPlate,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter plate number' : null,
                decoration: dec('Plate Number', Icons.confirmation_number),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Text(
                  'Add Vehicle',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[800],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await actions.addVehicle(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
