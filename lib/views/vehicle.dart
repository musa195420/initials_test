// lib/ui/driver/add_vehicle.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:initial_test/providers/vehicle_provider.dart';
import 'package:initial_test/widget_support/text_styles.dart';

class AddVehiclePage extends ConsumerStatefulWidget {
  const AddVehiclePage({super.key});

  @override
  ConsumerState<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends ConsumerState<AddVehiclePage> {
  final _formKey = GlobalKey<FormState>();

  late final _typeCtl = TextEditingController();
  late final _makeCtl = TextEditingController();
  late final _modelCtl = TextEditingController();
  late final _variantCtl = TextEditingController();
  late final _plateCtl = TextEditingController();

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
        hintStyle: SemiboldTextFieldStyle(),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(vehicleProvider);
    final a = ref.read(vehicleProvider.notifier);

    return Scaffold(
      body: LayoutBuilder(builder: (context, c) {
        final maxW = c.maxWidth, maxH = c.maxHeight;
        final header = min(maxH * .22, 180);
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
                  .add(EdgeInsets.only(top: header - 60)),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      SizedBox(height: header / 3),
                      _FormCard(
                        formKey: _formKey,
                        dec: _dec,
                        typeCtl: _typeCtl,
                        makeCtl: _makeCtl,
                        modelCtl: _modelCtl,
                        variantCtl: _variantCtl,
                        plateCtl: _plateCtl,
                        actions: a,
                        state: s,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (s.isSubmitting)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
    );
  }
}

/* ───────── small header stuff ───────── */

class _Header extends StatelessWidget {
  const _Header({required this.height, required this.logoW});
  final double height, logoW;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFff5c30), Color(0xFFe74b1a)],
        ),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/logo.png', width: logoW),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text('Add Vehicle', style: SemiboldTextFieldStyle()),
          ),
        ],
      ),
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
          ),
        ),
      );
}

/* ───────── the form card ───────── */

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
  final dynamic actions; // VehicleNotifier
  final dynamic state; // VehicleState

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      elevation: 6,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: typeCtl,
                onChanged: actions.setVehicleType,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter vehicle type' : null,
                decoration: dec('Vehicle Type', Icons.directions_car_filled),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: makeCtl,
                onChanged: actions.setMake,
                decoration: dec('Make (optional)', Icons.factory),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: modelCtl,
                onChanged: actions.setModel,
                decoration: dec('Model (optional)', Icons.build),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: variantCtl,
                onChanged: actions.setVariant,
                decoration: dec('Variant (optional)', Icons.settings),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: plateCtl,
                onChanged: actions.setPlate,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter plate number' : null,
                decoration: dec('Plate Number', Icons.numbers),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffff5722),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await actions.addVehicle(context);
                  }
                },
                child: const Text(
                  'ADD VEHICLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Poppins1',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
