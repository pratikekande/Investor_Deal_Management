import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DealDetailScreen extends StatefulWidget {
  const DealDetailScreen({super.key});

  @override
  State<DealDetailScreen> createState() => _DealDetailScreenState();
}

class _DealDetailScreenState extends State<DealDetailScreen>
    with TickerProviderStateMixin {
  bool _isInterested = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final Map<String, dynamic> _deal = {
    'company': 'CloudScale AI',
    'industry': 'TECH',
    'status': 'OPEN',
    'description':
        'CloudScale AI is revolutionizing the high-performance computing landscape by offering decentralized GPU orchestration. Their proprietary stack allows enterprise clients to train massive models at 40% lower costs than traditional cloud providers. With a strong pipeline of Tier-1 logistics and fintech clients, they are scaling for global expansion.',
    'investment': '₹50,00,000',
    'roi': '18% p.a.',
    'risk': 'Medium',
    'deadline': '30 Jun 2025',
    'riskAnalysis':
        'The primary risk factor involves market volatility in the semiconductor supply chain. While CloudScale AI has secured long-term contracts for H100 units, global trade restrictions may affect future hardware acquisition timelines. Medium risk rating is sustained due to robust insurance coverage and reserve hardware pools.',
  };

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
                // App Bar
                _buildAppBar(deviceWidth, deviceHeight),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: deviceHeight * 0.015),

                        // Company header card
                        _buildCompanyHeaderCard(deviceWidth, deviceHeight),

                        SizedBox(height: deviceHeight * 0.025),

                        // Financial Highlights
                        _buildSectionTitle('Financial Highlights', deviceWidth),
                        SizedBox(height: deviceHeight * 0.012),
                        _buildFinancialGrid(deviceWidth, deviceHeight),

                        SizedBox(height: deviceHeight * 0.025),

                        // About the Company
                        _buildSectionTitle('About the Company', deviceWidth),
                        SizedBox(height: deviceHeight * 0.012),
                        Text(
                          _deal['description'],
                          style: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: deviceWidth * 0.038,
                            height: 1.6,
                          ),
                        ),

                        SizedBox(height: deviceHeight * 0.025),

                        // ROI Projection graph
                        _buildROIProjectionCard(deviceWidth, deviceHeight),

                        SizedBox(height: deviceHeight * 0.02),

                        // Risk Analysis
                        _buildRiskAnalysisCard(deviceWidth, deviceHeight),

                        SizedBox(height: deviceHeight * 0.025),

                        // Visual Assets
                        _buildSectionTitle('Visual Assets', deviceWidth),
                        SizedBox(height: deviceHeight * 0.012),
                        _buildVisualAssets(deviceWidth, deviceHeight),

                        SizedBox(height: deviceHeight * 0.05),
                      ],
                    ),
                  ),
                ),

                // Bottom I'm Interested button
                _buildBottomButton(deviceWidth, deviceHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(double deviceWidth, double deviceHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.04,
        vertical: deviceHeight * 0.015,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: deviceWidth * 0.06,
                ),
                SizedBox(width: deviceWidth * 0.02),
                Text(
                  'Deal Detail',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: deviceWidth * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.bookmark_border_rounded,
            color: const Color(0xFF3B82F6),
            size: deviceWidth * 0.06,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyHeaderCard(double deviceWidth, double deviceHeight) {
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
              // Company logo
              Container(
                width: deviceWidth * 0.14,
                height: deviceWidth * 0.14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  ),
                ),
                child: Icon(
                  Icons.hub_outlined,
                  color: Colors.white,
                  size: deviceWidth * 0.07,
                ),
              ),

              // Industry + Status chips
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * 0.03,
                      vertical: deviceHeight * 0.004,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(deviceWidth * 0.015),
                    ),
                    child: Text(
                      _deal['industry'],
                      style: TextStyle(
                        color: const Color(0xFF3B82F6),
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
                      color: const Color(0xFF22C55E).withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(deviceWidth * 0.015),
                      border: Border.all(
                        color: const Color(0xFF22C55E),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: deviceWidth * 0.018,
                          height: deviceWidth * 0.018,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: deviceWidth * 0.015),
                        Text(
                          _deal['status'],
                          style: TextStyle(
                            color: const Color(0xFF22C55E),
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

          // Company name
          Text(
            _deal['company'],
            style: TextStyle(
              color: Colors.white,
              fontSize: deviceWidth * 0.065,
              fontWeight: FontWeight.w800,
            ),
          ),

          SizedBox(height: deviceHeight * 0.006),

          Text(
            'Next-generation distributed GPU computing infrastructure for sovereign LLMs.',
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
        'value': _deal['investment'],
        'valueColor': Colors.white,
      },
      {
        'label': 'EXPECTED ROI',
        'value': _deal['roi'],
        'valueColor': const Color(0xFF22C55E),
      },
      {
        'label': 'RISK LEVEL',
        'value': _deal['risk'],
        'valueColor': _getRiskColor(_deal['risk']),
      },
      {
        'label': 'DEAL DEADLINE',
        'value': _deal['deadline'],
        'valueColor': Colors.white,
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
            border: Border.all(
              color: const Color(0xFF2A3A55),
              width: 1,
            ),
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
                '+18.4% Est.',
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
                        const months = [
                          'JAN',
                          'APR',
                          'JUL',
                          'OCT',
                          'DEC',
                        ];
                        final idx = (value / 2.75).round();
                        if (idx < 0 || idx >= months.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: deviceHeight * 0.008),
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
                    color: const Color(0xFF3B82F6),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF3B82F6).withOpacity(0.3),
                          const Color(0xFF3B82F6).withOpacity(0.0),
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

  // ✅ FIXED - no more double.infinity height inside Row
  Widget _buildRiskAnalysisCard(double deviceWidth, double deviceHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(deviceWidth * 0.045),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
        border: Border(
          left: BorderSide(
            color: const Color(0xFFF59E0B),
            width: deviceWidth * 0.012,
          ),
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
                color: const Color(0xFFF59E0B),
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
            _deal['riskAnalysis'],
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: deviceWidth * 0.036,
              height: 1.6,
            ),
          ),
        ],
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
                color: const Color(0xFF3B82F6),
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
          // TODO: Connect to InterestBloc
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
                  : [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
            ),
            boxShadow: [
              BoxShadow(
                color: (_isInterested
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF3B82F6))
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