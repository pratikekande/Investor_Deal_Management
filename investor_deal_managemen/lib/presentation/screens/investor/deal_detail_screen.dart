import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DealDetailScreen extends StatefulWidget {
  final Map<String, dynamic> deal;

  const DealDetailScreen({super.key, required this.deal});

  @override
  State<DealDetailScreen> createState() => _DealDetailScreenState();
}

class _DealDetailScreenState extends State<DealDetailScreen>
    with TickerProviderStateMixin {
  bool _isInterested = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'low':
        return const Color(0xFF22C55E);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'high':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  Color _getIndustryColor(String industry) {
    switch (industry.toLowerCase()) {
      case 'tech':
        return const Color(0xFF6366F1);
      case 'healthcare':
        return const Color(0xFF06B6D4);
      case 'finance':
        return const Color(0xFF8B5CF6);
      case 'energy':
        return const Color(0xFFF59E0B);
      case 'real estate':
        return const Color(0xFF22C55E);
      default:
        return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1B3E),
              Color(0xFF0A0F2C),
              Color(0xFF060B1E),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildAppBar(deviceWidth, deviceHeight),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: deviceHeight * 0.015),
                        _buildCompanyHeaderCard(deviceWidth, deviceHeight),
                        SizedBox(height: deviceHeight * 0.025),
                        _buildSectionTitle('Financial Highlights', deviceWidth),
                        SizedBox(height: deviceHeight * 0.012),
                        _buildFinancialGrid(deviceWidth, deviceHeight),
                        SizedBox(height: deviceHeight * 0.025),
                        _buildSectionTitle('About the Company', deviceWidth),
                        SizedBox(height: deviceHeight * 0.012),
                        Text(
                          'This company is building innovative solutions in the ${widget.deal['industry']} sector. '
                          'With a strong leadership team and a clear go-to-market strategy, they are '
                          'positioned for significant growth over the coming years. The business model '
                          'is asset-light with recurring revenue streams and strong unit economics.',
                          style: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: deviceWidth * 0.038,
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.025),
                        _buildROIProjectionCard(deviceWidth, deviceHeight),
                        SizedBox(height: deviceHeight * 0.02),
                        _buildRiskAnalysisCard(deviceWidth, deviceHeight),
                        SizedBox(height: deviceHeight * 0.025),
                        _buildSectionTitle('Visual Assets', deviceWidth),
                        SizedBox(height: deviceHeight * 0.012),
                        _buildVisualAssets(deviceWidth, deviceHeight),
                        SizedBox(height: deviceHeight * 0.05),
                      ],
                    ),
                  ),
                ),
                _buildBottomButton(deviceWidth, deviceHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── AppBar (matches My Interests style) ─────────────────────────────────────
  Widget _buildAppBar(double deviceWidth, double deviceHeight) {
    final bool isOpen = widget.deal['status'] == 'OPEN';

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.04,
            vertical: deviceHeight * 0.018,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button + title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: deviceWidth * 0.09,
                      height: deviceWidth * 0.09,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2A45),
                        borderRadius:
                            BorderRadius.circular(deviceWidth * 0.025),
                        border: Border.all(
                          color: const Color(0xFF2A3A55),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: deviceWidth * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: deviceWidth * 0.03),
                  Text(
                    'Deal Detail',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceWidth * 0.055,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFF1E2A45), thickness: 1, height: 1),
      ],
    );
  }

  Widget _buildCompanyHeaderCard(double deviceWidth, double deviceHeight) {
    final bool isOpen = widget.deal['status'] == 'OPEN';
    final Color industryColor =
        _getIndustryColor(widget.deal['industry'] as String);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(deviceWidth * 0.045),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
        border: Border.all(color: const Color(0xFF2A3A55), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: deviceWidth * 0.14,
                height: deviceWidth * 0.14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                  gradient: LinearGradient(
                    colors: [
                      industryColor.withOpacity(0.3),
                      industryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.business_outlined,
                  color: Colors.white,
                  size: deviceWidth * 0.07,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * 0.03,
                      vertical: deviceHeight * 0.004,
                    ),
                    decoration: BoxDecoration(
                      color: industryColor.withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(deviceWidth * 0.015),
                    ),
                    child: Text(
                      widget.deal['industry'],
                      style: TextStyle(
                        color: industryColor,
                        fontSize: deviceWidth * 0.028,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.006),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * 0.03,
                      vertical: deviceHeight * 0.004,
                    ),
                    decoration: BoxDecoration(
                      color: (isOpen
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFEF4444))
                          .withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(deviceWidth * 0.015),
                      border: Border.all(
                        color: isOpen
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFEF4444),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: deviceWidth * 0.018,
                          height: deviceWidth * 0.018,
                          decoration: BoxDecoration(
                            color: isOpen
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: deviceWidth * 0.015),
                        Text(
                          widget.deal['status'],
                          style: TextStyle(
                            color: isOpen
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFEF4444),
                            fontSize: deviceWidth * 0.028,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: deviceHeight * 0.015),
          Text(
            widget.deal['company'],
            style: TextStyle(
              color: Colors.white,
              fontSize: deviceWidth * 0.065,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: deviceHeight * 0.006),
          Text(
            'A leading ${widget.deal['industry'].toString().toLowerCase()} company driving innovation and growth.',
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: deviceWidth * 0.036,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, double deviceWidth) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: deviceWidth * 0.052,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildFinancialGrid(double deviceWidth, double deviceHeight) {
    final List<Map<String, dynamic>> stats = [
      {
        'label': 'INVESTMENT\nREQUIRED',
        'value': widget.deal['investment'],
        'valueColor': Colors.white,
      },
      {
        'label': 'EXPECTED ROI',
        'value': '${widget.deal['roi']}%',
        'valueColor': const Color(0xFF22C55E),
      },
      {
        'label': 'RISK LEVEL',
        'value': widget.deal['risk'],
        'valueColor': _getRiskColor(widget.deal['risk']),
      },
      {
        'label': 'DEAL STATUS',
        'value': widget.deal['status'],
        'valueColor': widget.deal['status'] == 'OPEN'
            ? const Color(0xFF22C55E)
            : const Color(0xFFEF4444),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: deviceWidth * 0.03,
        mainAxisSpacing: deviceHeight * 0.012,
        childAspectRatio: 1.6,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(deviceWidth * 0.04),
          decoration: BoxDecoration(
            color: const Color(0xFF162035),
            borderRadius: BorderRadius.circular(deviceWidth * 0.03),
            border: Border.all(color: const Color(0xFF2A3A55), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stats[index]['label'],
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: deviceWidth * 0.027,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  height: 1.4,
                ),
              ),
              Text(
                stats[index]['value'],
                style: TextStyle(
                  color: stats[index]['valueColor'],
                  fontSize: deviceWidth * 0.042,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildROIProjectionCard(double deviceWidth, double deviceHeight) {
    final List<FlSpot> spots = [
      const FlSpot(0, 2),
      const FlSpot(1, 3),
      const FlSpot(2, 3.5),
      const FlSpot(3, 5),
      const FlSpot(4, 6),
      const FlSpot(5, 7),
      const FlSpot(6, 8),
      const FlSpot(7, 9.5),
      const FlSpot(8, 11),
      const FlSpot(9, 13),
      const FlSpot(10, 15.5),
      const FlSpot(11, 18.4),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(deviceWidth * 0.045),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
        border: Border.all(color: const Color(0xFF2A3A55), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ROI Projection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: deviceWidth * 0.046,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '+${widget.deal['roi']}% Est.',
                style: TextStyle(
                  color: const Color(0xFF22C55E),
                  fontSize: deviceWidth * 0.036,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: deviceHeight * 0.025),
          SizedBox(
            height: deviceHeight * 0.2,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2.75,
                      getTitlesWidget: (value, meta) {
                        const months = ['JAN', 'APR', 'JUL', 'OCT', 'DEC'];
                        final idx = (value / 2.75).round();
                        if (idx < 0 || idx >= months.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding:
                              EdgeInsets.only(top: deviceHeight * 0.008),
                          child: Text(
                            months[idx],
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: deviceWidth * 0.028,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFF6366F1),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF6366F1).withOpacity(0.3),
                          const Color(0xFF6366F1).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskAnalysisCard(double deviceWidth, double deviceHeight) {
    final Color riskColor = _getRiskColor(widget.deal['risk'] as String);

    return ClipRRect(
      borderRadius: BorderRadius.circular(deviceWidth * 0.04),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(deviceWidth * 0.045),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A45),
          border: Border(
            left: BorderSide(color: riskColor, width: deviceWidth * 0.012),
            top: const BorderSide(color: Color(0xFF2A3A55), width: 1),
            right: const BorderSide(color: Color(0xFF2A3A55), width: 1),
            bottom: const BorderSide(color: Color(0xFF2A3A55), width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: riskColor,
                  size: deviceWidth * 0.05,
                ),
                SizedBox(width: deviceWidth * 0.02),
                Text(
                  'Risk Analysis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: deviceWidth * 0.046,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: deviceHeight * 0.012),
            Text(
              'The ${widget.deal['risk'].toString().toLowerCase()} risk rating for this deal reflects current '
              'market conditions and the company\'s fundamentals. Investors should review all '
              'documentation carefully and consider their personal risk appetite before proceeding.',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: deviceWidth * 0.036,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualAssets(double deviceWidth, double deviceHeight) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: deviceHeight * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(deviceWidth * 0.03),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D2137), Color(0xFF0A3055)],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.dns_outlined,
                color: const Color(0xFF6366F1),
                size: deviceWidth * 0.1,
              ),
            ),
          ),
        ),
        SizedBox(width: deviceWidth * 0.03),
        Expanded(
          child: Container(
            height: deviceHeight * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(deviceWidth * 0.03),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D2137), Color(0xFF0A3055)],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.public_rounded,
                color: const Color(0xFF06B6D4),
                size: deviceWidth * 0.1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(double deviceWidth, double deviceHeight) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.05,
        vertical: deviceHeight * 0.015,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0F2C),
        border: Border(
          top: BorderSide(color: Color(0xFF1E2A45), width: 1),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() => _isInterested = !_isInterested);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isInterested
                    ? '✅ Interest expressed successfully!'
                    : 'Interest removed',
              ),
              backgroundColor: const Color(0xFF1E2A45),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: deviceHeight * 0.068,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(deviceWidth * 0.04),
            gradient: LinearGradient(
              colors: _isInterested
                  ? [const Color(0xFF22C55E), const Color(0xFF16A34A)]
                  : [const Color(0xFF4F46E5), const Color(0xFF6366F1)],
            ),
            boxShadow: [
              BoxShadow(
                color: (_isInterested
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF6366F1))
                    .withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isInterested ? 'Interest Expressed ✓' : "I'm Interested",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: deviceWidth * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (!_isInterested) ...[
                SizedBox(width: deviceWidth * 0.02),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: deviceWidth * 0.05,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}