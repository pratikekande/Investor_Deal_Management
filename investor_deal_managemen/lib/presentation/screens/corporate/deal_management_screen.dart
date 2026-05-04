import 'package:flutter/material.dart';

enum _DealFilter { all, open, closed }

class MyDealsScreen extends StatefulWidget {
  const MyDealsScreen({super.key});

  @override
  State<MyDealsScreen> createState() => _MyDealsScreenState();
}

class _MyDealsScreenState extends State<MyDealsScreen> {
  _DealFilter _activeFilter = _DealFilter.all;

  static const List<_DealData> _allDeals = [
    _DealData(
      title: 'Project Phoenix - SaaS Expansion',
      status: 'OPEN',
      tag: 'TECHNOLOGY',
      investment: '₹2.5M',
      roi: '18.5%',
      risk: 'Low',
      riskColor: Color(0xFF22C55E),
      investors: 12,
      isClosed: false,
    ),
    _DealData(
      title: 'GreenHorizon Solar Farm',
      status: 'CLOSED',
      tag: 'ENERGY',
      investment: '₹8.2M',
      roi: '12.1%',
      risk: 'Med',
      riskColor: Color(0xFFF59E0B),
      investors: 8,
      isClosed: true,
    ),
  ];

  List<_DealData> get _filteredDeals {
    switch (_activeFilter) {
      case _DealFilter.open:
        return _allDeals.where((d) => !d.isClosed).toList();
      case _DealFilter.closed:
        return _allDeals.where((d) => d.isClosed).toList();
      case _DealFilter.all:
        return _allDeals;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MyDealsAppBar(w: w),
            Container(height: 1, color: const Color(0xFF1E2A3F)),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05,
                  vertical: h * 0.025,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PortfolioBanner(w: w),
                    SizedBox(height: h * 0.025),
                    _FilterRow(
                      w: w,
                      active: _activeFilter,
                      onSelect: (f) => setState(() => _activeFilter = f),
                    ),
                    SizedBox(height: h * 0.025),
                    ..._filteredDeals.map(
                      (deal) => Padding(
                        padding: EdgeInsets.only(bottom: h * 0.02),
                        child: _DealCard(w: w, deal: deal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data Model ───────────────────────────────────────────────────────────────

class _DealData {
  final String title;
  final String status;
  final String tag;
  final String investment;
  final String roi;
  final String risk;
  final Color riskColor;
  final int investors;
  final bool isClosed;

  const _DealData({
    required this.title,
    required this.status,
    required this.tag,
    required this.investment,
    required this.roi,
    required this.risk,
    required this.riskColor,
    required this.investors,
    required this.isClosed,
  });
}

// ─── AppBar ───────────────────────────────────────────────────────────────────

class _MyDealsAppBar extends StatelessWidget {
  final double w;
  const _MyDealsAppBar({required this.w});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.05,
        vertical: w * 0.04,
      ),
      child: Text(
        'My Deals',
        style: TextStyle(
          color: Colors.white,
          fontSize: w * 0.058,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Portfolio Banner ─────────────────────────────────────────────────────────

class _PortfolioBanner extends StatelessWidget {
  final double w;
  const _PortfolioBanner({required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.05,
        vertical: w * 0.05,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: const Color(0xFF1E2A3F), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '6 Total Deals',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.048,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: w * 0.01),
                Text(
                  'CURRENT PORTFOLIO',
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: w * 0.12,
            color: const Color(0xFF1E2A3F),
            margin: EdgeInsets.symmetric(horizontal: w * 0.04),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '24 Interests',
                  style: TextStyle(
                    color: const Color(0xFF3B82F6),
                    fontSize: w * 0.042,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: w * 0.01),
                Text(
                  'ENGAGEMENT VELOCITY',
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
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

// ─── Filter Row ───────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final double w;
  final _DealFilter active;
  final ValueChanged<_DealFilter> onSelect;

  const _FilterRow({
    required this.w,
    required this.active,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterPill(
          label: 'All',
          isActive: active == _DealFilter.all,
          w: w,
          onTap: () => onSelect(_DealFilter.all),
        ),
        SizedBox(width: w * 0.03),
        _FilterPill(
          label: 'Open',
          isActive: active == _DealFilter.open,
          w: w,
          onTap: () => onSelect(_DealFilter.open),
        ),
        SizedBox(width: w * 0.03),
        _FilterPill(
          label: 'Closed',
          isActive: active == _DealFilter.closed,
          w: w,
          onTap: () => onSelect(_DealFilter.closed),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final double w;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isActive,
    required this.w,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.06,
          vertical: w * 0.03,
        ),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(w * 0.08),
          border: Border.all(
            color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF374151),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF9CA3AF),
            fontSize: w * 0.038,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─── Deal Card ────────────────────────────────────────────────────────────────

class _DealCard extends StatelessWidget {
  final double w;
  final _DealData deal;

  const _DealCard({required this.w, required this.deal});

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        deal.isClosed ? const Color(0xFF6B7280) : const Color(0xFF22C55E);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.05),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(w * 0.05),
        border: Border.all(color: const Color(0xFF1E2A3F), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            deal.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.047,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: w * 0.03),
          Row(
            children: [
              _StatusChip(label: deal.status, color: statusColor, w: w),
              SizedBox(width: w * 0.02),
              _StatusChip(label: deal.tag, color: const Color(0xFF3B82F6), w: w),
            ],
          ),
          SizedBox(height: w * 0.05),
          Row(
            children: [
              _MetricCol(
                w: w,
                icon: Icons.receipt_long_rounded,
                iconColor: const Color(0xFF6B7280),
                label: 'Investment',
                value: deal.investment,
                valueColor: Colors.white,
              ),
              SizedBox(width: w * 0.06),
              _MetricCol(
                w: w,
                icon: Icons.trending_up_rounded,
                iconColor: const Color(0xFF22C55E),
                label: 'ROI',
                value: deal.roi,
                valueColor: const Color(0xFF22C55E),
              ),
              SizedBox(width: w * 0.06),
              _MetricCol(
                w: w,
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFFF59E0B),
                label: 'Risk',
                value: deal.risk,
                valueColor: deal.riskColor,
              ),
            ],
          ),
          SizedBox(height: w * 0.05),
          Row(
            children: [
              Icon(Icons.people_rounded,
                  color: const Color(0xFF3B82F6), size: w * 0.055),
              SizedBox(width: w * 0.02),
              Text(
                '${deal.investors} Investors Interested',
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.045),
          Row(
            children: [
              Expanded(
                child: _ActionBtn(
                  label: 'VIEW\nINTERESTS',
                  borderColor: const Color(0xFF3B82F6),
                  textColor: const Color(0xFF3B82F6),
                  w: w,
                  onTap: () {},
                ),
              ),
              SizedBox(width: w * 0.025),
              Expanded(
                child: _ActionBtn(
                  label: 'EDIT',
                  borderColor: const Color(0xFF374151),
                  textColor: Colors.white,
                  w: w,
                  onTap: () {},
                ),
              ),
              SizedBox(width: w * 0.025),
              Expanded(
                child: _ActionBtn(
                  label: 'CLOSE\nDEAL',
                  borderColor: const Color(0xFFEF4444),
                  textColor: const Color(0xFFEF4444),
                  w: w,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final double w;

  const _StatusChip({required this.label, required this.color, required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.012),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(w * 0.015),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: w * 0.028,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _MetricCol extends StatelessWidget {
  final double w;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  const _MetricCol({
    required this.w,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: w * 0.04),
            SizedBox(width: w * 0.015),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFF9CA3AF),
                fontSize: w * 0.032,
              ),
            ),
          ],
        ),
        SizedBox(height: w * 0.015),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: w * 0.048,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color borderColor;
  final Color textColor;
  final double w;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.borderColor,
    required this.textColor,
    required this.w,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: w * 0.032),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w * 0.025),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: w * 0.03,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}