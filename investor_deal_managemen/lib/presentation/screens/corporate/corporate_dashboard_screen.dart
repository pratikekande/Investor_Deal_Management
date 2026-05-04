import 'package:flutter/material.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/post_deal_screen.dart';

class DealDashboardScreen extends StatelessWidget {
  const DealDashboardScreen({super.key});

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
            // ── Fixed header (never scrolls) ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.025),
                  _DashboardHeader(w: w),
                  SizedBox(height: h * 0.025),
                ],
              ),
            ),
            // ── Scrollable body ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatsRow(w: w),
                    SizedBox(height: h * 0.02),
                    _InvestorCard(w: w, h: h),
                    SizedBox(height: h * 0.025),
                    _PostDealButton(w: w),
                    SizedBox(height: h * 0.03),
                    _RecentDealsHeader(w: w),
                    SizedBox(height: h * 0.015),
                    _DealCard(
                      w: w,
                      title: 'Project Phoenix',
                      subtitle: 'SaaS Expansion',
                      tag: 'Technology',
                      status: 'OPEN',
                      progress: 0.75,
                      progressLabel: '75%',
                      investment: '₹2.5M',
                      roi: '18.5%',
                      roiColor: const Color(0xFF22C55E),
                      risk: 'Low',
                      riskColor: const Color(0xFF22C55E),
                      primaryBtnLabel: 'Edit Deal',
                      secondaryBtnLabel: 'Close Deal',
                      secondaryBtnColor: const Color(0xFFEF4444),
                      isClosed: false,
                    ),
                    SizedBox(height: h * 0.018),
                    _DealCard(
                      w: w,
                      title: 'GreenHorizon',
                      subtitle: 'Solar Farm',
                      tag: 'Energy',
                      status: 'CLOSED',
                      progress: 1.0,
                      progressLabel: '100%',
                      investment: '₹8.2M',
                      roi: '12.1%',
                      roiColor: const Color(0xFF22C55E),
                      risk: 'Med',
                      riskColor: const Color(0xFFF59E0B),
                      primaryBtnLabel: 'Archive',
                      secondaryBtnLabel: 'View Summary',
                      secondaryBtnColor: const Color(0xFF3B82F6),
                      isClosed: true,
                    ),
                    SizedBox(height: h * 0.018),
                    _MarketInsightsCard(w: w, h: h),
                    SizedBox(height: h * 0.03),
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

// ─── Header ──────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  final double w;
  const _DashboardHeader({required this.w});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Hello, TechCorp ',
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.065,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Text('👋', style: TextStyle(fontSize: w * 0.06)),
          ],
        ),
        SizedBox(height: w * 0.008),
        Text(
          'Manage your deals',
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: w * 0.035,
          ),
        ),
      ],
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final double w;
  const _StatsRow({required this.w});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatTile(w: w, label: 'TOTAL\nDEALS', value: '6', valueColor: Colors.white),
        SizedBox(width: w * 0.03),
        _StatTile(w: w, label: 'OPEN', value: '4', valueColor: Colors.white),
        SizedBox(width: w * 0.03),
        _StatTile(w: w, label: 'CLOSED', value: '2', valueColor: const Color(0xFFEF4444)),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final double w;
  final String label;
  final String value;
  final Color valueColor;

  const _StatTile({
    required this.w,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: w * 0.04, horizontal: w * 0.03),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(w * 0.04),
          border: Border.all(color: const Color(0xFF1E2A3F), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: w * 0.028,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
            SizedBox(height: w * 0.015),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: w * 0.07,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Investor Card ────────────────────────────────────────────────────────────

class _InvestorCard extends StatelessWidget {
  final double w;
  final double h;
  const _InvestorCard({required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Interests Received',
                style: TextStyle(
                  color: const Color(0xFF9CA3AF),
                  fontSize: w * 0.033,
                ),
              ),
              Container(
                padding: EdgeInsets.all(w * 0.02),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2A3F),
                  borderRadius: BorderRadius.circular(w * 0.025),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: const Color(0xFF3B82F6),
                  size: w * 0.05,
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.02),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '24',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.13,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              SizedBox(width: w * 0.025),
              Padding(
                padding: EdgeInsets.only(bottom: w * 0.02),
                child: Row(
                  children: [
                    Icon(Icons.trending_up_rounded,
                        color: const Color(0xFF22C55E), size: w * 0.04),
                    SizedBox(width: w * 0.01),
                    Text(
                      '+12%',
                      style: TextStyle(
                        color: const Color(0xFF22C55E),
                        fontSize: w * 0.033,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            'Investors',
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.065,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
          SizedBox(height: w * 0.05),
          _MiniBarChart(w: w),
        ],
      ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  final double w;
  const _MiniBarChart({required this.w});

  @override
  Widget build(BuildContext context) {
    final List<double> values = [0.3, 0.45, 0.4, 0.55, 0.5, 0.65, 0.75, 1.0];
    final double barH = w * 0.18;

    return SizedBox(
      height: barH,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.asMap().entries.map((e) {
          final bool isLast = e.key == values.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.008),
              child: Container(
                height: barH * e.value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isLast
                        ? [const Color(0xFF3B82F6), const Color(0xFF60A5FA)]
                        : [
                            const Color(0xFF1E3A5F),
                            const Color(0xFF2563EB).withOpacity(0.6),
                          ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(w * 0.015),
                    topRight: Radius.circular(w * 0.015),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Post Deal Button ─────────────────────────────────────────────────────────

class _PostDealButton extends StatelessWidget {
  final double w;
  const _PostDealButton({required this.w});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PostNewDealScreen()),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: w * 0.043),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(w * 0.04),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: w * 0.055),
            SizedBox(width: w * 0.02),
            Text(
              'POST NEW DEAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.04,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Recent Deals Header ──────────────────────────────────────────────────────

class _RecentDealsHeader extends StatelessWidget {
  final double w;
  const _RecentDealsHeader({required this.w});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Your Recent Deals',
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.05,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ─── Deal Card ────────────────────────────────────────────────────────────────

class _DealCard extends StatelessWidget {
  final double w;
  final String title;
  final String subtitle;
  final String tag;
  final String status;
  final double progress;
  final String progressLabel;
  final String investment;
  final String roi;
  final Color roiColor;
  final String risk;
  final Color riskColor;
  final String primaryBtnLabel;
  final String secondaryBtnLabel;
  final Color secondaryBtnColor;
  final bool isClosed;

  const _DealCard({
    required this.w,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.status,
    required this.progress,
    required this.progressLabel,
    required this.investment,
    required this.roi,
    required this.roiColor,
    required this.risk,
    required this.riskColor,
    required this.primaryBtnLabel,
    required this.secondaryBtnLabel,
    required this.secondaryBtnColor,
    required this.isClosed,
  });

  @override
  Widget build(BuildContext context) {
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
            '$title – $subtitle',
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.042,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: w * 0.025),
          Row(
            children: [
              _Chip(
                label: tag,
                bgColor: const Color(0xFF374151),
                textColor: const Color(0xFFD1D5DB),
                w: w,
              ),
              SizedBox(width: w * 0.02),
              _Chip(
                label: status,
                bgColor: isClosed ? const Color(0xFF374151) : const Color(0xFF1D4ED8),
                textColor: isClosed ? const Color(0xFF9CA3AF) : Colors.white,
                w: w,
              ),
            ],
          ),
          SizedBox(height: w * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Funding Progress',
                style: TextStyle(
                  color: const Color(0xFF9CA3AF),
                  fontSize: w * 0.033,
                ),
              ),
              Text(
                progressLabel,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.033,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.02),
          ClipRRect(
            borderRadius: BorderRadius.circular(w * 0.02),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: w * 0.018,
              backgroundColor: const Color(0xFF1E2A3F),
              valueColor: AlwaysStoppedAnimation<Color>(
                isClosed ? const Color(0xFF6B7280) : const Color(0xFF3B82F6),
              ),
            ),
          ),
          SizedBox(height: w * 0.04),
          Row(
            children: [
              Expanded(
                child: _MetricBlock(
                  w: w,
                  topLabel: 'INVESTMENT',
                  topLabelSuffix: 'ROI',
                  bottomLeft: investment,
                  bottomLeftColor: Colors.white,
                  bottomRight: roi,
                  bottomRightColor: roiColor,
                ),
              ),
              Expanded(
                child: _MetricBlock(
                  w: w,
                  topLabel: 'RISK',
                  bottomLeft: risk,
                  bottomLeftColor: riskColor,
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.04),
          Row(
            children: [
              Expanded(
                child: _OutlineBtn(
                  label: primaryBtnLabel,
                  borderColor: const Color(0xFF374151),
                  textColor: Colors.white,
                  w: w,
                  onTap: () {},
                ),
              ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: _OutlineBtn(
                  label: secondaryBtnLabel,
                  borderColor: secondaryBtnColor,
                  textColor: secondaryBtnColor,
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

class _Chip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final double w;

  const _Chip({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.012),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(w * 0.02),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: w * 0.03,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  final double w;
  final String topLabel;
  final String? topLabelSuffix;
  final String bottomLeft;
  final Color bottomLeftColor;
  final String? bottomRight;
  final Color? bottomRightColor;

  const _MetricBlock({
    required this.w,
    required this.topLabel,
    required this.bottomLeft,
    required this.bottomLeftColor,
    this.topLabelSuffix,
    this.bottomRight,
    this.bottomRightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topLabelSuffix != null ? '$topLabel    $topLabelSuffix' : topLabel,
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: w * 0.028,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: w * 0.01),
        Row(
          children: [
            Text(
              bottomLeft,
              style: TextStyle(
                color: bottomLeftColor,
                fontSize: w * 0.045,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (bottomRight != null) ...[
              SizedBox(width: w * 0.025),
              Text(
                bottomRight!,
                style: TextStyle(
                  color: bottomRightColor ?? Colors.white,
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final Color borderColor;
  final Color textColor;
  final double w;
  final VoidCallback onTap;

  const _OutlineBtn({
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
        padding: EdgeInsets.symmetric(vertical: w * 0.035),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w * 0.03),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: w * 0.035,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Market Insights Card ─────────────────────────────────────────────────────

class _MarketInsightsCard extends StatelessWidget {
  final double w;
  final double h;
  const _MarketInsightsCard({required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: h * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(w * 0.05),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1D35), Color(0xFF0D1F3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFF1E2A3F), width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: w * 0.5,
            child: CustomPaint(painter: _WavePainter()),
          ),
          Padding(
            padding: EdgeInsets.all(w * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'MARKET INSIGHTS',
                  style: TextStyle(
                    color: const Color(0xFF3B82F6),
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: w * 0.015),
                Text(
                  'Private Equity\nTrends 2024',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.048,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
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

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final colors = [
      const Color(0xFF3B82F6).withOpacity(0.5),
      const Color(0xFF06B6D4).withOpacity(0.35),
      const Color(0xFF3B82F6).withOpacity(0.2),
    ];
    final offsets = [0.3, 0.55, 0.75];

    for (int i = 0; i < 3; i++) {
      paint.color = colors[i];
      final path = Path();
      path.moveTo(0, size.height * offsets[i]);
      for (double x = 0; x <= size.width; x++) {
        final y = size.height * offsets[i] +
            (size.height * 0.12) *
                (0.5 * (x / size.width) + 0.5) *
                (1 - x / size.width) *
                4 *
                (i % 2 == 0 ? 1 : -1);
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}