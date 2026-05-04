import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ════════════════════════════════════════════════════════════════════════════
//  PostNewDealScreen
//  Navigate to it:
//    Navigator.push(context,
//      MaterialPageRoute(builder: (_) => const PostNewDealScreen()));
// ════════════════════════════════════════════════════════════════════════════

class PostNewDealScreen extends StatefulWidget {
  const PostNewDealScreen({super.key});

  @override
  State<PostNewDealScreen> createState() => _PostNewDealScreenState();
}

class _PostNewDealScreenState extends State<PostNewDealScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController      = TextEditingController();
  final _companyController    = TextEditingController();
  final _investmentController = TextEditingController();
  final _roiController        = TextEditingController();
  final _deadlineController   = TextEditingController();

  String? _selectedIndustry;
  String  _riskLevel = 'Medium';

  static const List<String> _industries = [
    'Technology',
    'Energy',
    'Healthcare',
    'Finance',
    'Real Estate',
    'Manufacturing',
    'Retail',
    'Agriculture',
  ];

  static const List<String> _riskOptions = ['Low', 'Medium', 'High'];

  Color _riskColor(String level) {
    switch (level) {
      case 'Low':  return const Color(0xFF22C55E);
      case 'High': return const Color(0xFFEF4444);
      default:     return const Color(0xFFF59E0B);
    }
  }

  Future<void> _pickDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF3B82F6),
            surface: Color(0xFF111827),
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: const Color(0xFF0A0E1A),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _deadlineController.text =
          '${picked.day.toString().padLeft(2, '0')} / '
          '${picked.month.toString().padLeft(2, '0')} / '
          '${picked.year}';
    }
  }

  void _submitDeal() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF22C55E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Text(
            'Deal posted successfully!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _investmentController.dispose();
    _roiController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: _buildAppBar(w),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // ── Divider below AppBar ──
            Container(height: 1, color: const Color(0xFF1E2A3F)),

            // ── Scrollable form body ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05,
                  vertical: h * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(text: 'Deal Title', w: w),
                    SizedBox(height: h * 0.01),
                    _InputField(
                      controller: _titleController,
                      hint: 'e.g. Series A Funding Round',
                      w: w,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Please enter a deal title' : null,
                    ),
                    SizedBox(height: h * 0.025),

                    _FieldLabel(text: 'Company Name', w: w),
                    SizedBox(height: h * 0.01),
                    _InputField(
                      controller: _companyController,
                      hint: 'Enter your company name',
                      w: w,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Please enter company name' : null,
                    ),
                    SizedBox(height: h * 0.025),

                    _FieldLabel(text: 'Industry', w: w),
                    SizedBox(height: h * 0.01),
                    _IndustryDropdown(
                      w: w,
                      value: _selectedIndustry,
                      items: _industries,
                      onChanged: (val) => setState(() => _selectedIndustry = val),
                    ),
                    SizedBox(height: h * 0.025),

                    _FieldLabel(text: 'Investment Required (INR)', w: w),
                    SizedBox(height: h * 0.01),
                    _InputField(
                      controller: _investmentController,
                      hint: 'e.g. 50,00,000',
                      w: w,
                      prefixText: '₹  ',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Please enter investment amount' : null,
                    ),
                    SizedBox(height: h * 0.025),

                    _FieldLabel(text: 'Expected ROI (%)', w: w),
                    SizedBox(height: h * 0.01),
                    _InputField(
                      controller: _roiController,
                      hint: 'e.g. 18',
                      w: w,
                      suffixText: '%',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Please enter expected ROI' : null,
                    ),
                    SizedBox(height: h * 0.025),

                    _FieldLabel(text: 'Risk Level', w: w),
                    SizedBox(height: h * 0.015),
                    _RiskSelector(
                      w: w,
                      selected: _riskLevel,
                      options: _riskOptions,
                      activeColor: _riskColor(_riskLevel),
                      onSelect: (val) => setState(() => _riskLevel = val),
                    ),
                    SizedBox(height: h * 0.025),

                    _FieldLabel(text: 'Deal Deadline', w: w),
                    SizedBox(height: h * 0.01),
                    _InputField(
                      controller: _deadlineController,
                      hint: 'DD / MM / YYYY',
                      w: w,
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.calendar_today_rounded,
                        color: const Color(0xFF6B7280),
                        size: w * 0.045,
                      ),
                      onTap: _pickDeadline,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Please select a deadline' : null,
                    ),

                    SizedBox(height: h * 0.04),
                  ],
                ),
              ),
            ),

            // ── Sticky Post Deal button ──
            _PostDealButton(w: w, h: h, onTap: _submitDeal),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(double w) {
    return AppBar(
      backgroundColor: const Color(0xFF0A0E1A),
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: Icon(
          Icons.arrow_back_rounded,
          color: const Color(0xFF3B82F6),
          size: w * 0.06,
        ),
      ),
      title: Text(
        'Post New Deal',
        style: TextStyle(
          color: Colors.white,
          fontSize: w * 0.052,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Reusable field label ─────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  final double w;
  const _FieldLabel({required this.text, required this.w});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFFD1D5DB),
        fontSize: w * 0.038,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// ─── Reusable text input field ────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final double w;
  final String? prefixText;
  final String? suffixText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final VoidCallback? onTap;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.w,
    this.prefixText,
    this.suffixText,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      style: TextStyle(
        color: Colors.white,
        fontSize: w * 0.04,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFF4B5563),
          fontSize: w * 0.04,
        ),
        prefixText: prefixText,
        prefixStyle: TextStyle(
          color: const Color(0xFF9CA3AF),
          fontSize: w * 0.042,
          fontWeight: FontWeight.w500,
        ),
        suffixText: suffixText,
        suffixStyle: TextStyle(
          color: const Color(0xFF6B7280),
          fontSize: w * 0.04,
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF111827),
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.045,
          vertical: w * 0.045,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.04),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.04),
          borderSide: const BorderSide(color: Color(0xFF1E2A3F), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.04),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.04),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.04),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        errorStyle: TextStyle(
          color: const Color(0xFFEF4444),
          fontSize: w * 0.03,
        ),
      ),
    );
  }
}

// ─── Industry dropdown ────────────────────────────────────────────────────────

class _IndustryDropdown extends StatelessWidget {
  final double w;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _IndustryDropdown({
    required this.w,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: const Color(0xFF1E2A3F), width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: w * 0.045),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF111827),
          // ── FIXED: single chevron icon ──
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: const Color(0xFF3B82F6),
            size: w * 0.06,
          ),
          hint: Text(
            'Select Industry',
            style: TextStyle(
              color: const Color(0xFF4B5563),
              fontSize: w * 0.04,
            ),
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.04,
          ),
          items: items.map((industry) {
            return DropdownMenuItem(
              value: industry,
              child: Text(industry),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ─── Risk level selector ──────────────────────────────────────────────────────

class _RiskSelector extends StatelessWidget {
  final double w;
  final String selected;
  final List<String> options;
  final Color activeColor;
  final ValueChanged<String> onSelect;

  const _RiskSelector({
    required this.w,
    required this.selected,
    required this.options,
    required this.activeColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((opt) {
        final bool isActive = opt == selected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: opt != options.last ? w * 0.03 : 0,
            ),
            child: GestureDetector(
              onTap: () => onSelect(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: w * 0.035),
                decoration: BoxDecoration(
                  color: isActive
                      ? activeColor.withOpacity(0.12)
                      : const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(w * 0.08),
                  border: Border.all(
                    color: isActive ? activeColor : const Color(0xFF374151),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    opt,
                    style: TextStyle(
                      color: isActive ? activeColor : const Color(0xFF9CA3AF),
                      fontSize: w * 0.038,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Sticky Post Deal button ──────────────────────────────────────────────────

class _PostDealButton extends StatelessWidget {
  final double w;
  final double h;
  final VoidCallback onTap;

  const _PostDealButton({
    required this.w,
    required this.h,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(w * 0.05, h * 0.015, w * 0.05, h * 0.03),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0E1A),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: w * 0.045),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(w * 0.04),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Post Deal',
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.045,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}