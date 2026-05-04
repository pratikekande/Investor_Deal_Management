import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_state.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_state.dart';
import 'package:investor_deal_managemen/presentation/screens/corporate/post_deal_screen.dart';

class DealDashboardScreen extends StatelessWidget {
  const DealDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    String userName = 'Corporate';
    String userEmail = ''; // ✅ Added to store the email
    
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      userName = authState.user.name;
      userEmail = authState.user.email; // ✅ Grab the email for fetching deals
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DashboardAppBar(w: w, h: h, userName: userName),
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF6366F1),
                backgroundColor: const Color(0xFF1E2A3F),
                onRefresh: () async {
                  // ✅ FIXED: Fetch only MY deals using the userEmail, not ALL deals
                  if (userEmail.isNotEmpty) {
                    context.read<DealBloc>().add(LoadMyDealsEvent(userEmail));
                  }
                  await Future.delayed(const Duration(milliseconds: 800));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: h * 0.02),
                      BlocBuilder<DealBloc, DealState>(
                        builder: (ctx, state) {
                          int total = 0, open = 0, closed = 0;
                          if (state is DealsLoaded) {
                            total = state.allDeals.length;
                            open = state.allDeals
                                .where((d) =>
                                    d.status.toLowerCase() == 'open')
                                .length;
                            closed = state.allDeals
                                .where((d) =>
                                    d.status.toLowerCase() == 'closed')
                                .length;
                          }
                          return _StatsRow(
                              w: w,
                              total: total,
                              open: open,
                              closed: closed);
                        },
                      ),
                      SizedBox(height: h * 0.02),
                      _InvestorCard(w: w, h: h),
                      SizedBox(height: h * 0.025),
                      _PostDealButton(w: w),
                      SizedBox(height: h * 0.03),
                      Text('Your Recent Deals',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: h * 0.015),
                      BlocBuilder<DealBloc, DealState>(
                        builder: (ctx, state) {
                          if (state is DealsLoaded &&
                              state.allDeals.isNotEmpty) {
                            final recent = state.allDeals.take(2).toList();
                            return Column(
                              children: recent
                                  .map((d) => Padding(
                                        padding: EdgeInsets.only(
                                            bottom: h * 0.018),
                                        child: _RecentDealCard(
                                            deal: d, w: w, h: h),
                                      ))
                                  .toList(),
                            );
                          }
                          if (state is DealLoading) {
                            return const Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xFF6366F1)));
                          }
                          return Container(
                            padding: EdgeInsets.all(w * 0.05),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111827),
                              borderRadius:
                                  BorderRadius.circular(w * 0.04),
                              border: Border.all(
                                  color: const Color(0xFF1E2A3F)),
                            ),
                            child: Center(
                              child: Text('No deals yet. Post your first deal!',
                                  style: TextStyle(
                                      color: const Color(0xFF94A3B8),
                                      fontSize: w * 0.036)),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: h * 0.018),
                      _MarketInsightsCard(w: w, h: h),
                      SizedBox(height: h * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────

class _DashboardAppBar extends StatelessWidget {
  final double w;
  final double h;
  final String userName;
  const _DashboardAppBar(
      {required this.w, required this.h, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: w * 0.05, vertical: h * 0.018),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Hello, $userName',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.055,
                              fontWeight: FontWeight.w700)),
                      SizedBox(width: w * 0.015),
                      Text('👋',
                          style: TextStyle(fontSize: w * 0.052)),
                    ],
                  ),
                  SizedBox(height: h * 0.004),
                  Text('Manage your deals',
                      style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: w * 0.032,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFF1E2A3F), thickness: 1, height: 1),
      ],
    );
  }
}

// ── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final double w;
  final int total;
  final int open;
  final int closed;
  const _StatsRow(
      {required this.w,
      required this.total,
      required this.open,
      required this.closed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatTile(
            w: w,
            label: 'TOTAL\nDEALS',
            value: '$total',
            valueColor: Colors.white),
        SizedBox(width: w * 0.03),
        _StatTile(
            w: w,
            label: 'OPEN',
            value: '$open',
            valueColor: const Color(0xFF22C55E)),
        SizedBox(width: w * 0.03),
        _StatTile(
            w: w,
            label: 'CLOSED',
            value: '$closed',
            valueColor: const Color(0xFFEF4444)),
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
        padding: EdgeInsets.symmetric(
            vertical: w * 0.04, horizontal: w * 0.03),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(w * 0.04),
          border: Border.all(
              color: const Color(0xFF1E2A3F), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w500,
                    height: 1.3)),
            SizedBox(height: w * 0.015),
            Text(value,
                style: TextStyle(
                    color: valueColor,
                    fontSize: w * 0.07,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

// ── Investor Card ─────────────────────────────────────────────────────────────

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
              Text('Total Interests Received',
                  style: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: w * 0.033)),
              Container(
                padding: EdgeInsets.all(w * 0.02),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2A3F),
                  borderRadius: BorderRadius.circular(w * 0.025),
                ),
                child: Icon(Icons.bar_chart_rounded,
                    color: const Color(0xFF6366F1), size: w * 0.05),
              ),
            ],
          ),
          SizedBox(height: w * 0.02),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('24',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.13,
                      fontWeight: FontWeight.w800,
                      height: 1.0)),
              SizedBox(width: w * 0.025),
              Padding(
                padding: EdgeInsets.only(bottom: w * 0.02),
                child: Row(
                  children: [
                    Icon(Icons.trending_up_rounded,
                        color: const Color(0xFF22C55E), size: w * 0.04),
                    SizedBox(width: w * 0.01),
                    Text('+12%',
                        style: TextStyle(
                            color: const Color(0xFF22C55E),
                            fontSize: w * 0.033,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          Text('Investors',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.065,
                  fontWeight: FontWeight.w700,
                  height: 1.0)),
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
    final values = [0.3, 0.45, 0.4, 0.55, 0.5, 0.65, 0.75, 1.0];
    final barH = w * 0.18;

    return SizedBox(
      height: barH,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.asMap().entries.map((e) {
          final bool isLast = e.key == values.length - 1;
          return Expanded(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: w * 0.008),
              child: Container(
                height: barH * e.value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isLast
                        ? [
                            const Color(0xFF4F46E5),
                            const Color(0xFF818CF8),
                          ]
                        : [
                            const Color(0xFF1E1B4B),
                            const Color(0xFF4338CA)
                                .withOpacity(0.6),
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

// ── Post Deal Button ──────────────────────────────────────────────────────────

class _PostDealButton extends StatelessWidget {
  final double w;
  const _PostDealButton({required this.w});

  @override
  Widget build(BuildContext context) {
    final dealBloc = context.read<DealBloc>();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => BlocProvider.value(
            value: dealBloc,
            child: const PostNewDealScreen(),
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeOut)),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: w * 0.043),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: w * 0.055),
            SizedBox(width: w * 0.02),
            Text('POST NEW DEAL',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2)),
          ],
        ),
      ),
    );
  }
}

// ── Recent Deal Card ──────────────────────────────────────────────────────────

class _RecentDealCard extends StatelessWidget {
  final DealEntity deal;
  final double w;
  final double h;
  const _RecentDealCard(
      {required this.deal, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    final bool isOpen = deal.status.toLowerCase() == 'open';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: const Color(0xFF1E2A3F), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(w * 0.03),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A3F),
              borderRadius: BorderRadius.circular(w * 0.03),
            ),
            child: Icon(Icons.business_outlined,
                color: const Color(0xFF6366F1), size: w * 0.06),
          ),
          SizedBox(width: w * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deal.companyName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w700)),
                Text(deal.industry,
                    style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: w * 0.032)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: w * 0.025, vertical: h * 0.005),
            decoration: BoxDecoration(
              color: (isOpen
                      ? const Color(0xFF22C55E)
                      : const Color(0xFF6B7280))
                  .withOpacity(0.15),
              borderRadius: BorderRadius.circular(w * 0.015),
              border: Border.all(
                color: isOpen
                    ? const Color(0xFF22C55E)
                    : const Color(0xFF6B7280),
                width: 1,
              ),
            ),
            child: Text(
              isOpen ? 'OPEN' : 'CLOSED',
              style: TextStyle(
                color: isOpen
                    ? const Color(0xFF22C55E)
                    : const Color(0xFF6B7280),
                fontSize: w * 0.026,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Market Insights Card ──────────────────────────────────────────────────────

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
                Text('MARKET INSIGHTS',
                    style: TextStyle(
                        color: const Color(0xFF6366F1),
                        fontSize: w * 0.028,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2)),
                SizedBox(height: h * 0.006),
                Text('FinTech up 14% this quarter',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.042,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: h * 0.004),
                Text('Emerging markets show strong ROI',
                    style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: w * 0.032)),
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
      ..color = const Color(0xFF6366F1).withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.2,
        size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.8,
        size.width, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.05)
      ..style = PaintingStyle.fill;
    final path2 = Path();
    path2.moveTo(0, size.height * 0.3);
    path2.quadraticBezierTo(size.width * 0.3, size.height * 0.0,
        size.width * 0.6, size.height * 0.35);
    path2.quadraticBezierTo(size.width * 0.85, size.height * 0.65,
        size.width, size.height * 0.4);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}