import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
//  FilterBottomSheet
//
//  Show it from anywhere:
//    showModalBottomSheet(
//      context: context,
//      isScrollControlled: true,
//      backgroundColor: Colors.transparent,
//      builder: (_) => const FilterBottomSheet(),
//    );
// ════════════════════════════════════════════════════════════════════════════

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // ── Filter state ──
  String _selectedIndustry = 'All';
  String _selectedRisk     = 'Medium';
  String _selectedStatus   = 'Open';
  double _roiMin           = 10;
  double _roiMax           = 30;

  static const List<String> _industries = [
    'All', 'Tech', 'Finance', 'Healthcare', 'Energy', 'Real Estate',
  ];

  void _resetAll() => setState(() {
    _selectedIndustry = 'All';
    _selectedRisk     = 'Medium';
    _selectedStatus   = 'Open';
    _roiMin           = 10;
    _roiMax           = 30;
  });

  Color _riskDot(String level) {
    switch (level) {
      case 'Low':  return const Color(0xFF22C55E);
      case 'High': return const Color(0xFFEF4444);
      default:     return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Container(
      // sheet takes up to 92 % of screen height
      constraints: BoxConstraints(maxHeight: h * 0.92),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1623),
        borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.06)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──
          _DragHandle(w: w),

          // ── Scrollable body ──
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: w * 0.055),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.01),

                  // Header row
                  _SheetHeader(w: w, onReset: _resetAll),
                  SizedBox(height: h * 0.03),

                  // ── INDUSTRY ──
                  _SectionLabel(text: 'INDUSTRY', w: w),
                  SizedBox(height: h * 0.015),
                  _IndustryGrid(
                    w: w,
                    industries: _industries,
                    selected: _selectedIndustry,
                    onSelect: (v) => setState(() => _selectedIndustry = v),
                  ),
                  SizedBox(height: h * 0.03),

                  // ── RISK LEVEL ──
                  _SectionLabel(text: 'RISK LEVEL', w: w),
                  SizedBox(height: h * 0.015),
                  _RiskRow(
                    w: w,
                    selected: _selectedRisk,
                    dotColor: _riskDot,
                    onSelect: (v) => setState(() => _selectedRisk = v),
                  ),
                  SizedBox(height: h * 0.03),

                  // ── EXPECTED ROI RANGE ──
                  _RoiRangeSection(
                    w: w,
                    roiMin: _roiMin,
                    roiMax: _roiMax,
                    onChanged: (min, max) =>
                        setState(() { _roiMin = min; _roiMax = max; }),
                  ),
                  SizedBox(height: h * 0.03),

                  // ── DEAL STATUS ──
                  _SectionLabel(text: 'DEAL STATUS', w: w),
                  SizedBox(height: h * 0.015),
                  _StatusRow(
                    w: w,
                    selected: _selectedStatus,
                    onSelect: (v) => setState(() => _selectedStatus = v),
                  ),
                  SizedBox(height: h * 0.025),

                  // ── Institutional access banner ──
                  _InstitutionalBanner(w: w),
                  SizedBox(height: h * 0.025),
                ],
              ),
            ),
          ),

          // ── Sticky Apply button ──
          _ApplyButton(
            w: w,
            onTap: () {
              // TODO: pass filter values back via callback / provider
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// ─── Drag handle ──────────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  final double w;
  const _DragHandle({required this.w});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: w * 0.03, bottom: w * 0.01),
      child: Center(
        child: Container(
          width: w * 0.1,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF374151),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

// ─── Sheet header ─────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  final double w;
  final VoidCallback onReset;
  const _SheetHeader({required this.w, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filter Deals',
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.055,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: onReset,
          child: Text(
            'Reset All',
            style: TextStyle(
              color: const Color(0xFF3B82F6),
              fontSize: w * 0.038,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  final double w;
  const _SectionLabel({required this.text, required this.w});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF6B7280),
        fontSize: w * 0.032,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ─── Industry grid (wrap layout) ─────────────────────────────────────────────

class _IndustryGrid extends StatelessWidget {
  final double w;
  final List<String> industries;
  final String selected;
  final ValueChanged<String> onSelect;

  const _IndustryGrid({
    required this.w,
    required this.industries,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: w * 0.025,
      runSpacing: w * 0.025,
      children: industries.map((industry) {
        final bool isActive = industry == selected;
        return GestureDetector(
          onTap: () => onSelect(industry),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.048,
              vertical: w * 0.028,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF141D2E),
              borderRadius: BorderRadius.circular(w * 0.08),
              border: Border.all(
                color: isActive
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF2A3548),
                width: 1.5,
              ),
            ),
            child: Text(
              industry,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFFD1D5DB),
                fontSize: w * 0.036,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Risk level row ───────────────────────────────────────────────────────────

class _RiskRow extends StatelessWidget {
  final double w;
  final String selected;
  final Color Function(String) dotColor;
  final ValueChanged<String> onSelect;

  const _RiskRow({
    required this.w,
    required this.selected,
    required this.dotColor,
    required this.onSelect,
  });

  static const List<String> _levels = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _levels.map((level) {
        final bool isActive = level == selected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: level != _levels.last ? w * 0.03 : 0,
            ),
            child: GestureDetector(
              onTap: () => onSelect(level),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(vertical: w * 0.035),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF1A2540)
                      : const Color(0xFF141D2E),
                  borderRadius: BorderRadius.circular(w * 0.03),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF2A3548),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: w * 0.022,
                      height: w * 0.022,
                      decoration: BoxDecoration(
                        color: dotColor(level),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    Text(
                      level,
                      style: TextStyle(
                        color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                        fontSize: w * 0.036,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── ROI Range section ────────────────────────────────────────────────────────

class _RoiRangeSection extends StatelessWidget {
  final double w;
  final double roiMin;
  final double roiMax;
  final void Function(double min, double max) onChanged;

  const _RoiRangeSection({
    required this.w,
    required this.roiMin,
    required this.roiMax,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'EXPECTED ROI RANGE',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: w * 0.032,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '${roiMin.round()}%  —  ${roiMax.round()}%',
              style: TextStyle(
                color: const Color(0xFF3B82F6),
                fontSize: w * 0.038,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: w * 0.04),
        // Range slider
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            activeTrackColor: const Color(0xFF3B82F6),
            inactiveTrackColor: const Color(0xFF2A3548),
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayColor: const Color(0xFF3B82F6).withOpacity(0.2),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: RangeSlider(
            values: RangeValues(roiMin, roiMax),
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (vals) => onChanged(vals.start, vals.end),
          ),
        ),
      ],
    );
  }
}

// ─── Deal status row ──────────────────────────────────────────────────────────

class _StatusRow extends StatelessWidget {
  final double w;
  final String selected;
  final ValueChanged<String> onSelect;

  const _StatusRow({
    required this.w,
    required this.selected,
    required this.onSelect,
  });

  static const List<String> _statuses = ['Open', 'Closed'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _statuses.map((status) {
        final bool isActive = status == selected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: status != _statuses.last ? w * 0.04 : 0,
            ),
            child: GestureDetector(
              onTap: () => onSelect(status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(vertical: w * 0.038),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF1A2540)
                      : const Color(0xFF141D2E),
                  borderRadius: BorderRadius.circular(w * 0.03),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF2A3548),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Radio circle
                    Container(
                      width: w * 0.05,
                      height: w * 0.05,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFF4B5563),
                          width: 1.8,
                        ),
                      ),
                      child: isActive
                          ? Center(
                              child: Container(
                                width: w * 0.025,
                                height: w * 0.025,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3B82F6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: w * 0.025),
                    Text(
                      status,
                      style: TextStyle(
                        color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                        fontSize: w * 0.04,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Institutional access banner ──────────────────────────────────────────────

class _InstitutionalBanner extends StatelessWidget {
  final double w;
  const _InstitutionalBanner({required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: w * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(w * 0.04),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D1F3C), Color(0xFF112240)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFF1E2A3F), width: 1),
      ),
      child: Stack(
        children: [
          // Decorative diagonal lines (texture)
          ClipRRect(
            borderRadius: BorderRadius.circular(w * 0.04),
            child: CustomPaint(
              painter: _DiagonalLinePainter(),
              child: const SizedBox.expand(),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(w * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'INSTITUTIONAL ACCESS',
                  style: TextStyle(
                    color: const Color(0xFF3B82F6),
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                SizedBox(height: w * 0.015),
                Text(
                  '42 Verified Opportunities',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.048,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(0.06)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double gap = 18;
    for (double i = -size.height; i < size.width + size.height; i += gap) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Apply Filters button ─────────────────────────────────────────────────────

class _ApplyButton extends StatelessWidget {
  final double w;
  final VoidCallback onTap;
  const _ApplyButton({required this.w, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    return Container(
      color: const Color(0xFF0F1623),
      padding: EdgeInsets.fromLTRB(
        w * 0.055, h * 0.015, w * 0.055, h * 0.035,
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
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Apply Filters',
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.045,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}