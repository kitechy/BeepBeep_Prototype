import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/core/service/user_service.dart';
import 'package:beepbeep_prototype/features/driver/repository/driver_repository.dart';
import 'package:beepbeep_prototype/features/driver/service/driver_service.dart';
import 'package:beepbeep_prototype/features/driver/view/driver_home_page.dart';
import 'package:beepbeep_prototype/features/operator/repository/operator_repository.dart';
import 'package:beepbeep_prototype/features/operator/service/operator_service.dart';
import 'package:beepbeep_prototype/shared/widgets/field_label_widget.dart';
import 'package:beepbeep_prototype/shared/widgets/form_field_widget.dart';
import 'package:beepbeep_prototype/features/driver/viewmodel/driver_form_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DriverForm extends StatelessWidget {
  const DriverForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DriverFormViewModel(
        AuthRepository(AuthService()),
        DriverRepository(DriverService()),
        UserRepository(UserService()),
        OperatorRepository(OperatorService()),
      ),
      child: const _DriverFormView(),
    );
  }
}

class _DriverFormView extends StatefulWidget {
  const _DriverFormView();

  @override
  State<_DriverFormView> createState() => __DriverFormViewState();
}

class __DriverFormViewState extends State<_DriverFormView> {
  @override
  Widget build(BuildContext context) {
    final driverVM = context.watch<DriverFormViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: driverVM.formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            children: [
              Text(
                'DRIVER ONBOARDING',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: Color(0xff0000FF),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Complete profile',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text(
                'We need a few more details before you can start driving.',
                style: TextStyle(fontSize: 13.5),
              ),
              const SizedBox(height: 28),

              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120.w,
                      height: 120.h,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: driverVM.photoUrl != null
                          ? ClipOval(
                              child: Image.network(
                                driverVM.photoUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipOval(
                              child: Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.account_circle,
                                  size: 120.r,
                                  color: Color(0xff0000FF),
                                ),
                              ),
                            ),
                    ),
                    // Positioned(
                    //   right: 0,
                    //   bottom: 0,
                    //   child: Container(
                    //     width: 30,
                    //     height: 30,
                    //     decoration: BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       color: Color(0xff000000),
                    //     ),
                    //     child: const Icon(
                    //       Icons.camera_alt_rounded,
                    //       size: 15,
                    //       color: Color(0xffFFFFFF),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  driverVM.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Center(
                child: Text(driverVM.email, style: TextStyle(fontSize: 13.5)),
              ),

              const SizedBox(height: 32),

              FieldLabelWidget(text: 'Phone number'),
              FormFieldWidget(
                controller: driverVM.phoneController,
                hint: '09XX XXX XXXX',
                icon: Icons.call_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().length < 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              FieldLabelWidget(text: 'License number'),
              FormFieldWidget(
                controller: driverVM.licenseController,
                hint: 'e.g. N01-23-3456789',
                icon: Icons.badge_outlined,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'License number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              FieldLabelWidget(text: 'Address'),
              FormFieldWidget(
                controller: driverVM.addressController,
                hint: 'Street, barangay, city',
                icon: Icons.location_on_outlined,
                maxLines: 1,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              FieldLabelWidget(text: 'Operator Code (optional)'),
              FormFieldWidget(
                controller: driverVM.operatorCodeController,
                hint: 'BBP-XXXXXX',
                icon: Icons.qr_code,
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(18.r),
                  backgroundColor: Color(0xff000000),
                  foregroundColor: Color(0xffFFFFFF),
                  disabledBackgroundColor: Color(0xff000000).withOpacity(0.5),
                ),
                onPressed: () async {
                  final success = await driverVM.createDriverProfile();

                  if (!mounted) return;

                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const DriverHomePage()),
                    );
                  } else if (driverVM.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(driverVM.errorMessage!)),
                    );
                  }
                },
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
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
