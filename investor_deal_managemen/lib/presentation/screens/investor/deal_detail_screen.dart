import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/domain/entities/interest_entity.dart';
import 'package:investor_deal_managemen/injection_container.dart';
import 'package:investor_deal_managemen/presentation/bloc/interest/interest_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/interest/interest_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/interest/interest_state.dart';

class DealDetailScreen extends StatefulWidget {
  final DealEntity deal;
  final String investorEmail;

  const DealDetailScreen({
    super.key,
    required this.deal,
    required this.investorEmail,
  });

  @override
  State<DealDetailScreen> createState() => _DealDetailScreenState();
}

class _DealDetailScreenState extends State<DealDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late final InterestBloc _interestBloc;

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
    _interestBloc = sl<InterestBloc>();
    _interestBloc.add(CheckInterestEvent(
      dealId: widget.deal.id!,
      investorEmail: widget.investorEmail,
    ));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _interestBloc.close();
    super.dispose();
  }

  // FIX 3: Refresh handler — re-checks interest status for this deal.
  Future<void> _onRefresh() async {
    _interestBloc.add(CheckInterestEvent(
      dealId: widget.deal.id!,
      investorEmail: widget.investorEmail,
    ));
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      return _interestBloc.state is InterestLoading;
    }).timeout(const Duration(seconds: 10), onTimeout: () {});
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
      case 'technology':
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
      case 'manufacturing':
        return const Color(0xFFF97316);
      case 'retail':
        return const Color(0xFFEC4899);
      case 'agriculture':
        return const Color(0xFF84CC16);
      default:
        return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return BlocProvider<InterestBloc>.value(
      value: _interestBloc,
      child: Scaffold(
        body: Container(
          width: w,
          height: h,
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
                  _buildAppBar(w, h),
                  Expanded(
                    // FIX 3: RefreshIndicator wraps the scrollable content.
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: const Color(0xFF6366F1),
                      backgroundColor: const Color(0xFF1E2A45),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding:
                            EdgeInsets.symmetric(horizontal: w * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: h * 0.015),
                            _buildCompanyHeaderCard(w, h),
                            SizedBox(height: h * 0.025),
                            _buildSectionTitle('Financial Highlights', w),
                            SizedBox(height: h * 0.012),
                            _buildFinancialGrid(w, h),
                            SizedBox(height: h * 0.025),
                            _buildSectionTitle('About the Deal', w),
                            SizedBox(height: h * 0.012),
                            Text(
                              widget.deal.description.isNotEmpty
                                  ? widget.deal.description
                                  : 'This company is building innovative solutions in the ${widget.deal.industry} sector. '
                                      'With a strong leadership team and a clear go-to-market strategy, they are '
                                      'positioned for significant growth over the coming years.',
                              style: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: w * 0.038,
                                height: 1.6,
                              ),
                            ),
                            SizedBox(height: h * 0.025),
                            _buildROIProjectionCard(w, h),
                            SizedBox(height: h * 0.02),
                            _buildRiskAnalysisCard(w, h),
                            SizedBox(height: h * 0.025),
                            _buildSectionTitle('Visual Assets', w),
                            SizedBox(height: h * 0.012),
                            _buildVisualAssets(w, h),
                            SizedBox(height: h * 0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildBottomButton(w, h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(double w, double h) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: w * 0.04, vertical: h * 0.018),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: w * 0.09,
                      height: w * 0.09,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2A45),
                        borderRadius:
                            BorderRadius.circular(w * 0.025),
                        border: Border.all(
                            color: const Color(0xFF2A3A55), width: 1),
                      ),
                      child: Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: w * 0.05),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Text('Deal Detail',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.055,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFF1E2A45), thickness: 1, height: 1),
      ],
    );
  }

  Widget _buildCompanyHeaderCard(double w, double h) {
    final bool isOpen = widget.deal.status.toLowerCase() == 'open';
    final Color industryColor = _getIndustryColor(widget.deal.industry);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.045),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(w * 0.04),
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
                width: w * 0.14,
                height: w * 0.14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(w * 0.03),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(industryColor.red, industryColor.green, industryColor.blue, 0.3),
                      Color.fromRGBO(industryColor.red, industryColor.green, industryColor.blue, 0.7),
                    ],
                  ),
                ),
                child: Icon(Icons.business_outlined,
                    color: Colors.white, size: w * 0.07),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.03, vertical: h * 0.004),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(industryColor.red, industryColor.green, industryColor.blue, 0.15),
                      borderRadius: BorderRadius.circular(w * 0.015),
                    ),
                    child: Text(widget.deal.industry.toUpperCase(),
                        style: TextStyle(
                            color: industryColor,
                            fontSize: w * 0.028,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5)),
                  ),
                  SizedBox(height: h * 0.006),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.03, vertical: h * 0.004),
                    decoration: BoxDecoration(
                      color: isOpen
                          ? const Color(0x2622C55E)
                          : const Color(0x26EF4444),
                      borderRadius: BorderRadius.circular(w * 0.015),
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
                          width: w * 0.018,
                          height: w * 0.018,
                          decoration: BoxDecoration(
                            color: isOpen
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: w * 0.015),
                        Text(
                          isOpen ? 'Open' : 'Closed',
                          style: TextStyle(
                            color: isOpen
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFEF4444),
                            fontSize: w * 0.028,
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
          SizedBox(height: h * 0.015),
          Text(widget.deal.companyName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.065,
                  fontWeight: FontWeight.w800)),
          SizedBox(height: h * 0.006),
          Text(widget.deal.title,
              style: TextStyle(
                  color: const Color(0xFF6366F1),
                  fontSize: w * 0.038,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: h * 0.008),
          Text(
            'Posted by ${widget.deal.postedByName}',
            style: TextStyle(
                color: const Color(0xFF94A3B8), fontSize: w * 0.034),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, double w) {
    return Text(title,
        style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.052,
            fontWeight: FontWeight.w700));
  }

  Widget _buildFinancialGrid(double w, double h) {
    final stats = [
      {
        'label': 'INVESTMENT\nREQUIRED',
        'value': widget.deal.investmentRequired,
        'valueColor': Colors.white,
      },
      {
        'label': 'EXPECTED ROI',
        'value': '${widget.deal.expectedRoi.toStringAsFixed(1)}%',
        'valueColor': const Color(0xFF22C55E),
      },
      {
        'label': 'RISK LEVEL',
        'value': widget.deal.riskLevel,
        'valueColor': _getRiskColor(widget.deal.riskLevel),
      },
      {
        'label': 'DEAL STATUS',
        'value': widget.deal.status,
        'valueColor': widget.deal.status.toLowerCase() == 'open'
            ? const Color(0xFF22C55E)
            : const Color(0xFFEF4444),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: w * 0.03,
        mainAxisSpacing: h * 0.012,
        childAspectRatio: 1.6,
      ),
      itemCount: stats.length,
      itemBuilder: (_, i) => Container(
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: const Color(0xFF162035),
          borderRadius: BorderRadius.circular(w * 0.03),
          border: Border.all(color: const Color(0xFF2A3A55), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(stats[i]['label'] as String,
                style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: w * 0.027,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    height: 1.4)),
            Text(stats[i]['value'] as String,
                style: TextStyle(
                    color: stats[i]['valueColor'] as Color,
                    fontSize: w * 0.042,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildROIProjectionCard(double w, double h) {
    final spots = [
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
      FlSpot(11, widget.deal.expectedRoi),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.045),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: const Color(0xFF2A3A55), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ROI Projection',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.046,
                      fontWeight: FontWeight.w700)),
              Text(
                  '+${widget.deal.expectedRoi.toStringAsFixed(1)}% Est.',
                  style: TextStyle(
                      color: const Color(0xFF22C55E),
                      fontSize: w * 0.036,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: h * 0.025),
          SizedBox(
            height: h * 0.2,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
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
                          'DEC'
                        ];
                        final idx = (value / 2.75).round();
                        if (idx < 0 || idx >= months.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: h * 0.008),
                          child: Text(months[idx],
                              style: TextStyle(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: w * 0.028,
                                  fontWeight: FontWeight.w500)),
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
                          const Color(0x4C6366F1),
                          const Color(0x006366F1),
                        ],
                      ),
                    ),
                  ),
                ],
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskAnalysisCard(double w, double h) {
    final Color riskColor = _getRiskColor(widget.deal.riskLevel);

    return ClipRRect(
      borderRadius: BorderRadius.circular(w * 0.04),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(w * 0.045),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A45),
          border: Border(
            left: BorderSide(color: riskColor, width: w * 0.012),
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
                Icon(Icons.warning_amber_rounded,
                    color: riskColor, size: w * 0.05),
                SizedBox(width: w * 0.02),
                Text('Risk Analysis',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.046,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            SizedBox(height: h * 0.012),
            Text(
              'The ${widget.deal.riskLevel.toLowerCase()} risk rating for this deal reflects current '
              'market conditions and the company\'s fundamentals. Investors should review all '
              'documentation carefully and consider their personal risk appetite before proceeding.',
              style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: w * 0.036,
                  height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualAssets(double w, double h) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: h * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(w * 0.03),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D2137), Color(0xFF0A3055)],
              ),
            ),
            child: Center(
              child: Icon(Icons.dns_outlined,
                  color: const Color(0xFF6366F1), size: w * 0.1),
            ),
          ),
        ),
        SizedBox(width: w * 0.03),
        Expanded(
          child: Container(
            height: h * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(w * 0.03),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D2137), Color(0xFF0A3055)],
              ),
            ),
            child: Center(
              child: Icon(Icons.public_rounded,
                  color: const Color(0xFF06B6D4), size: w * 0.1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(double w, double h) {
    final bool isClosed = widget.deal.status.toLowerCase() == 'closed';

    return BlocConsumer<InterestBloc, InterestState>(
      listener: (ctx, state) {
        if (state is InterestOperationSuccess) {
          // Determine if this was an "express" or "remove" action by checking
          // the message content so we can colour the snackbar accordingly.
          final bool wasExpressed =
              state.message.toLowerCase().contains('express') ||
              state.message.toLowerCase().contains('added') ||
              state.message.toLowerCase().contains('interest');
          _showSnackBar(
            ctx,
            message: state.message,
            icon: wasExpressed ? Icons.bookmark_added_rounded : Icons.bookmark_remove_rounded,
            iconColor: wasExpressed ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
            borderColor: wasExpressed ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
          );
          ctx.read<InterestBloc>().add(CheckInterestEvent(
                dealId: widget.deal.id!,
                investorEmail: widget.investorEmail,
              ));
        }
        if (state is InterestError) {
          _showSnackBar(
            ctx,
            message: state.message,
            icon: Icons.error_outline_rounded,
            iconColor: const Color(0xFFEF4444),
            borderColor: const Color(0xFFEF4444),
          );
        }
      },
      builder: (ctx, state) {
        final bool isInterested =
            state is InterestChecked && state.isInterested;
        final bool isLoading = state is InterestLoading;

        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: w * 0.05, vertical: h * 0.015),
          decoration: const BoxDecoration(
            color: Color(0xFF0A0F2C),
            border: Border(
                top: BorderSide(color: Color(0xFF1E2A45), width: 1)),
          ),
          child: isClosed
              // ── CLOSED DEAL — disabled button ──────────────────────────
              ? Container(
                  width: double.infinity,
                  height: h * 0.068,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2A45),
                    borderRadius: BorderRadius.circular(w * 0.04),
                    border: Border.all(
                        color: const Color(0xFF2A3A55), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          color: const Color(0xFF64748B), size: w * 0.05),
                      SizedBox(width: w * 0.025),
                      Text(
                        'Deal Closed — No Longer Accepting Interest',
                        style: TextStyle(
                            color: const Color(0xFF64748B),
                            fontSize: w * 0.033,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              // ── OPEN DEAL — active button ───────────────────────────────
              : GestureDetector(
                  onTap: () {
                    if (isLoading) return;
                    if (isInterested) {
                      ctx.read<InterestBloc>().add(RemoveInterestEvent(
                            dealId: widget.deal.id!,
                            investorEmail: widget.investorEmail,
                          ));
                    } else {
                      ctx.read<InterestBloc>().add(ExpressInterestEvent(
                            InterestEntity(
                              dealId: widget.deal.id!,
                              investorEmail: widget.investorEmail,
                              dealTitle: widget.deal.title,
                              companyName: widget.deal.companyName,
                              industry: widget.deal.industry,
                              investmentRequired:
                                  widget.deal.investmentRequired,
                              expectedRoi: widget.deal.expectedRoi,
                              riskLevel: widget.deal.riskLevel,
                              status: widget.deal.status,
                              postedByEmail: widget.deal.postedByEmail,
                              postedByName: widget.deal.postedByName,
                              description: widget.deal.description,
                              createdAt: DateTime.now().toIso8601String(),
                            ),
                          ));
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: h * 0.068,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(w * 0.04),
                      gradient: LinearGradient(
                        colors: isInterested
                            ? [
                                const Color(0xFF22C55E),
                                const Color(0xFF16A34A),
                              ]
                            : [
                                const Color(0xFF4F46E5),
                                const Color(0xFF6366F1),
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isInterested
                              ? const Color(0x4C22C55E)
                              : const Color(0x4C6366F1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isInterested
                                    ? Icons.bookmark_added_rounded
                                    : Icons.bookmark_add_rounded,
                                color: Colors.white,
                                size: w * 0.05,
                              ),
                              SizedBox(width: w * 0.025),
                              Text(
                                isInterested
                                    ? 'Interest Expressed ✓'
                                    : "I'm Interested",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.045,
                                    fontWeight: FontWeight.w700),
                              ),
                              if (!isInterested) ...[
                                SizedBox(width: w * 0.02),
                                Icon(Icons.arrow_forward_rounded,
                                    color: Colors.white, size: w * 0.05),
                              ],
                            ],
                          ),
                  ),
                ),
        );
      },
    );
  }

  /// Shows a styled snackbar with an icon, coloured border, and dark background
  /// so text is always clearly visible.
  void _showSnackBar(
    BuildContext ctx, {
    required String message,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
  }) {
    ScaffoldMessenger.of(ctx)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(ctx).size.width * 0.04,
            vertical: MediaQuery.of(ctx).size.height * 0.015,
          ),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B3E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x66000000),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                        iconColor.red, iconColor.green, iconColor.blue, 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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