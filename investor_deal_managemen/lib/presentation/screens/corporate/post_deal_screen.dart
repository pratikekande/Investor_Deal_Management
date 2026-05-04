import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_state.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_state.dart';

class PostNewDealScreen extends StatefulWidget {
  const PostNewDealScreen({super.key});

  @override
  State<PostNewDealScreen> createState() => _PostNewDealScreenState();
}

class _PostNewDealScreenState extends State<PostNewDealScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _investmentController = TextEditingController();
  final _roiController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedIndustry;
  String _riskLevel = 'Medium';

  final List<String> _industries = [
    'Technology',
    'Energy',
    'Healthcare',
    'Finance',
    'Real Estate',
    'Manufacturing',
    'Retail',
    'Agriculture',
  ];

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _companyController.text = authState.user.name;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _investmentController.dispose();
    _roiController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitDeal() {
    if (!_formKey.currentState!.validate()) return;
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;
    final user = authState.user;

    final deal = DealEntity(
      id: null,
      title: _titleController.text.trim(),
      companyName: _companyController.text.trim(),
      industry: _selectedIndustry ?? 'Technology',
      investmentRequired: '₹${_investmentController.text.trim()}',
      expectedRoi:
          double.tryParse(_roiController.text.trim()) ?? 0.0,
      riskLevel: _riskLevel,
      status: 'Open',
      postedByEmail: user.email,
      postedByName: user.name,
      description: _descriptionController.text.trim(),
      createdAt: DateTime.now().toIso8601String(),
    );

    context.read<DealBloc>().add(PostDealEvent(deal));
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return BlocConsumer<DealBloc, DealState>(
      listener: (ctx, state) {
        if (state is DealPosted) {
          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
            content: Text('✅ Deal posted successfully!'),
            backgroundColor: Color(0xFF22C55E),
            behavior: SnackBarBehavior.floating,
          ));
          if (mounted) Navigator.pop(ctx);
        }
        if (state is DealError) {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      builder: (ctx, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0E1A),
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(w, h),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.05, vertical: h * 0.02),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel('Deal Title', w),
                          SizedBox(height: h * 0.008),
                          _buildTextField(
                            controller: _titleController,
                            hint: 'e.g. Series A Expansion Round',
                            w: w,
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Title is required'
                                : null,
                          ),
                          SizedBox(height: h * 0.02),
                          _sectionLabel('Company Name', w),
                          SizedBox(height: h * 0.008),
                          _buildTextField(
                            controller: _companyController,
                            hint: 'Your company name',
                            w: w,
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Company name is required'
                                : null,
                          ),
                          SizedBox(height: h * 0.02),
                          _sectionLabel('Industry', w),
                          SizedBox(height: h * 0.008),
                          _buildIndustryDropdown(w),
                          SizedBox(height: h * 0.02),
                          _sectionLabel('Investment Required (₹)', w),
                          SizedBox(height: h * 0.008),
                          _buildTextField(
                            controller: _investmentController,
                            hint: 'e.g. 5000000',
                            prefixText: '₹ ',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            w: w,
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Investment amount is required'
                                : null,
                          ),
                          SizedBox(height: h * 0.02),
                          _sectionLabel('Expected ROI (%)', w),
                          SizedBox(height: h * 0.008),
                          _buildTextField(
                            controller: _roiController,
                            hint: 'e.g. 18.5',
                            suffixText: '%',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            w: w,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'ROI is required';
                              }
                              if (double.tryParse(v.trim()) == null) {
                                return 'Enter a valid number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: h * 0.02),
                          _sectionLabel('Risk Level', w),
                          SizedBox(height: h * 0.01),
                          _buildRiskSelector(w, h),
                          SizedBox(height: h * 0.02),
                          _sectionLabel('Description', w),
                          SizedBox(height: h * 0.008),
                          _buildTextField(
                            controller: _descriptionController,
                            hint:
                                'Describe the deal, company vision, and why investors should be interested...',
                            maxLines: 4,
                            w: w,
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Description is required'
                                : null,
                          ),
                          SizedBox(height: h * 0.04),
                          _buildPostButton(state, w, h),
                          SizedBox(height: h * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(double w, double h) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: w * 0.04, vertical: h * 0.018),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: w * 0.09,
                  height: w * 0.09,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2A3F),
                    borderRadius: BorderRadius.circular(w * 0.025),
                    border: Border.all(
                        color: const Color(0xFF6366F1), width: 1),
                  ),
                  child: Icon(Icons.arrow_back_rounded,
                      color: const Color(0xFF6366F1), size: w * 0.05),
                ),
              ),
              SizedBox(width: w * 0.03),
              Text('Post New Deal',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        const Divider(color: Color(0xFF1E2A3F), thickness: 1, height: 1),
      ],
    );
  }

  Widget _sectionLabel(String text, double w) {
    return Text(text,
        style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.038,
            fontWeight: FontWeight.w600));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required double w,
    String? prefixText,
    String? suffixText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: TextStyle(color: Colors.white, fontSize: w * 0.038),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: const Color(0xFF6B7280), fontSize: w * 0.036),
        prefixText: prefixText,
        prefixStyle: TextStyle(
            color: const Color(0xFF94A3B8), fontSize: w * 0.038),
        suffixText: suffixText,
        suffixStyle: TextStyle(
            color: const Color(0xFF94A3B8), fontSize: w * 0.038),
        filled: true,
        fillColor: const Color(0xFF111827),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: const BorderSide(color: Color(0xFF1E2A3F)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: const BorderSide(color: Color(0xFF1E2A3F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        errorStyle: const TextStyle(color: Color(0xFFEF4444)),
        contentPadding:
            EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.04),
      ),
    );
  }

  Widget _buildIndustryDropdown(double w) {
    return DropdownButtonFormField<String>(
      value: _selectedIndustry,
      dropdownColor: const Color(0xFF1E2A3F),
      style: TextStyle(color: Colors.white, fontSize: w * 0.038),
      hint: Text('Select industry',
          style: TextStyle(
              color: const Color(0xFF6B7280), fontSize: w * 0.036)),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF111827),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: const BorderSide(color: Color(0xFF1E2A3F)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: const BorderSide(color: Color(0xFF1E2A3F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.03),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: w * 0.04, vertical: w * 0.04),
      ),
      validator: (v) =>
          v == null ? 'Please select an industry' : null,
      items: _industries
          .map((ind) =>
              DropdownMenuItem(value: ind, child: Text(ind)))
          .toList(),
      onChanged: (v) => setState(() => _selectedIndustry = v),
    );
  }

  Widget _buildRiskSelector(double w, double h) {
    final risks = ['Low', 'Medium', 'High'];
    final colors = {
      'Low': const Color(0xFF22C55E),
      'Medium': const Color(0xFFF59E0B),
      'High': const Color(0xFFEF4444),
    };

    return Row(
      children: risks.map((risk) {
        final bool selected = _riskLevel == risk;
        final Color c = colors[risk]!;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: risk != 'High' ? w * 0.02 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _riskLevel = risk),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: h * 0.015),
                decoration: BoxDecoration(
                  color: selected ? c.withOpacity(0.2) : const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(w * 0.03),
                  border: Border.all(
                    color: selected ? c : const Color(0xFF1E2A3F),
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Center(
                  child: Text(risk,
                      style: TextStyle(
                          color: selected ? c : const Color(0xFF94A3B8),
                          fontSize: w * 0.038,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPostButton(DealState state, double w, double h) {
    final bool isLoading = state is DealLoading;
    return GestureDetector(
      onTap: isLoading ? null : _submitDeal,
      child: Container(
        width: double.infinity,
        height: h * 0.07,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(w * 0.04),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5)
              : Text('Post Deal',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5)),
        ),
      ),
    );
  }
}