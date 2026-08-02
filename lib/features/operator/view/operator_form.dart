import 'package:beepbeep_prototype/core/repository/auth_repository.dart';
import 'package:beepbeep_prototype/core/repository/user_repository.dart';
import 'package:beepbeep_prototype/core/service/auth_service.dart';
import 'package:beepbeep_prototype/core/service/user_service.dart';
import 'package:beepbeep_prototype/features/operator/repository/operator_repository.dart';
import 'package:beepbeep_prototype/features/operator/service/operator_service.dart';
import 'package:beepbeep_prototype/features/operator/view/oprator_home_page.dart';
import 'package:beepbeep_prototype/features/operator/viewmodel/operator_form_viewmodel.dart';
import 'package:beepbeep_prototype/shared/widgets/field_label_widget.dart';
import 'package:beepbeep_prototype/shared/widgets/form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OperatorForm extends StatelessWidget {
  const OperatorForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OperatorFormViewModel(
        AuthRepository(AuthService()),
        OperatorRepository(OperatorService()),
        UserRepository(UserService()),
      ),
      child: const _OperatorFormView(),
    );
  }
}

class _OperatorFormView extends StatefulWidget {
  const _OperatorFormView();

  @override
  State<_OperatorFormView> createState() => __OperatorFormViewState();
}

class __OperatorFormViewState extends State<_OperatorFormView> {
  @override
  Widget build(BuildContext context) {
    final operatorVM = context.watch<OperatorFormViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: operatorVM.formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            children: [
              Text(
                'OPERATOR ONBOARDING',
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
                'We need a few more details before you can start managing.',
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
                      child: operatorVM.currentUser!.photoURL != null
                          ? ClipOval(
                              child: Image.network(
                                operatorVM.currentUser!.photoURL!,
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
                  operatorVM.currentUser!.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Center(
                child: Text(
                  operatorVM.currentUser!.email ?? '',
                  style: TextStyle(fontSize: 13.5),
                ),
              ),

              const SizedBox(height: 32),

              FieldLabelWidget(text: 'Phone number'),
              FormFieldWidget(
                controller: operatorVM.phoneController,
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
              FieldLabelWidget(text: 'Address'),
              FormFieldWidget(
                controller: operatorVM.addressController,
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

              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(18.r),
                  backgroundColor: Color(0xff000000),
                  foregroundColor: Color(0xffFFFFFF),
                  disabledBackgroundColor: Color(0xff000000).withOpacity(0.5),
                ),
                onPressed: () async {
                  final success = await operatorVM.createOperatorProfile();

                  if (!mounted) return;

                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OperatorHomePage(),
                      ),
                    );
                  } else if (operatorVM.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(operatorVM.errorMessage!)),
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
