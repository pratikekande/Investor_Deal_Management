import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/domain/entities/interest_entity.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_state.dart';
import 'package:investor_deal_managemen/presentation/bloc/interest/interest_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/interest/interest_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/interest/interest_state.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/deal_detail_screen.dart';

class MyInterestsScreen extends StatefulWidget {
  const MyInterestsScreen({super.key});

  @override
  State<MyInterestsScreen> createState() => _MyInterestsScreenState();
}

class _MyInterestsScreenState extends State<MyInterestsScreen> {
  @override
  void initState() {
    super.initState();
    _loadInterests();
  }

  void _loadInterests() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context
          .read<InterestBloc>()
          .add(LoadMyInterestsEvent(authState.user.email));
    }
  }

  Future<void> _onRefresh() async {
    _loadInterests();
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      return context.read<InterestBloc>().state is InterestLoading;
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

  String _parseTotalInvestment(List<InterestEntity> interests) {
    double total = 0;
    for (final i in interests) {
      final cleaned = i.investmentRequired.replaceAll(RegExp(r'[₹,\s]'), '');
      total += double.tryParse(cleaned) ?? 0;
    }
    if (total >= 10000000) {
      return '₹${(total / 10000000).toStringAsFixed(1)}Cr';
    } else if (total >= 100000) {
      return '₹${(total / 100000).toStringAsFixed(1)}L';
    } else {
      return '₹${total.toStringAsFixed(0)}';
    }
  }

  List<InterestEntity>? _listFromState(InterestState state) {
    if (state is InterestsLoaded) return state.interests;
    if (state is InterestChecked) return state.currentInterests;
    if (state is InterestOperationSuccess) return state.currentInterests;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
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
          child: BlocConsumer<InterestBloc, InterestState>(
            listener: (ctx, state) {
              if (state is InterestOperationSuccess) {
                // Detect if this was a removal by checking the message
                final bool isRemoval =
                    state.message.toLowerCase().contains('remov') ||
                    state.message.toLowerCase().contains('delet');

                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: isRemoval
                        ? const Color(0xFFEF4444) // red for removal
                        : const Color(0xFF22C55E), // green for any other success
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            builder: (ctx, state) {
              final List<InterestEntity> list = _listFromState(state) ?? [];
              final int savedCount = list.length;

              return Column(
                children: [
                  _buildAppBar(w, h, savedCount),
                  Expanded(
                    child: _buildBody(ctx, state, list, w, h),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(double w, double h, int savedCount) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: w * 0.05, vertical: h * 0.018),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Interests',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.w700)),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.03, vertical: h * 0.006),
                decoration: BoxDecoration(
                  color: const Color(0x336366F1),
                  borderRadius: BorderRadius.circular(w * 0.025),
                  border:
                      Border.all(color: const Color(0xFF6366F1), width: 1),
                ),
                child: Text('$savedCount Saved',
                    style: TextStyle(
                        color: const Color(0xFF6366F1),
                        fontSize: w * 0.033,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFF1E2A45), thickness: 1, height: 1),
      ],
    );
  }

  Widget _buildBody(BuildContext ctx, InterestState state,
      List<InterestEntity> list, double w, double h) {
    if (state is InterestLoading && list.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)));
    }

    if (list.isNotEmpty) {
      return Column(
        children: [
          _buildSummaryCard(list, w, h),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: const Color(0xFF6366F1),
              backgroundColor: const Color(0xFF1E2A45),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.05, vertical: h * 0.01),
                itemCount: list.length,
                itemBuilder: (_, i) => Padding(
                  padding: EdgeInsets.only(bottom: h * 0.018),
                  child: _InterestCard(
                    interest: list[i],
                    getRiskColor: _getRiskColor,
                    getIndustryColor: _getIndustryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (state is InterestsLoaded ||
        state is InterestChecked ||
        state is InterestOperationSuccess) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xFF6366F1),
        backgroundColor: const Color(0xFF1E2A45),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: h * 0.7,
            child: _buildEmptyState(w, h),
          ),
        ),
      );
    }

    if (state is InterestError) {
      return Center(
          child: Text(state.message,
              style: const TextStyle(color: Color(0xFFEF4444))));
    }

    return const SizedBox.shrink();
  }

  Widget _buildSummaryCard(
      List<InterestEntity> interests, double w, double h) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: w * 0.05, vertical: h * 0.015),
      padding: EdgeInsets.all(w * 0.045),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: const Color(0xFF1E2A3F), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Deals Saved',
                  style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: w * 0.033)),
              SizedBox(height: h * 0.004),
              Text('${interests.length}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.065,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          Container(
              width: 1, height: h * 0.07, color: const Color(0xFF1E2A3F)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Total Potential',
                  style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: w * 0.033)),
              SizedBox(height: h * 0.004),
              Text(_parseTotalInvestment(interests),
                  style: TextStyle(
                      color: const Color(0xFF22C55E),
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double w, double h) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded,
              color: const Color(0xFF2A3A55), size: w * 0.18),
          SizedBox(height: h * 0.02),
          Text('No Interests Yet',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: h * 0.008),
          Text('Browse deals and express your interest',
              style: TextStyle(
                  color: const Color(0xFF94A3B8), fontSize: w * 0.036)),
          SizedBox(height: h * 0.03),
        ],
      ),
    );
  }
}

// ── Interest Card ─────────────────────────────────────────────────────────────

class _InterestCard extends StatelessWidget {
  final InterestEntity interest;
  final Color Function(String) getRiskColor;
  final Color Function(String) getIndustryColor;

  const _InterestCard({
    required this.interest,
    required this.getRiskColor,
    required this.getIndustryColor,
  });

  DealEntity _toDealEntity() => DealEntity(
        id: interest.dealId,
        title: interest.dealTitle,
        companyName: interest.companyName,
        industry: interest.industry,
        investmentRequired: interest.investmentRequired,
        expectedRoi: interest.expectedRoi,
        riskLevel: interest.riskLevel,
        status: interest.status,
        postedByEmail: interest.postedByEmail,
        postedByName: interest.postedByName,
        description: interest.description,
        createdAt: interest.createdAt,
      );

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    final bool isOpen = interest.status.toLowerCase() == 'open';
    final Color industryColor = getIndustryColor(interest.industry);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(w * 0.045),
        border: Border.all(color: const Color(0xFF2A3A55), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(w * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(interest.companyName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.046,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: h * 0.004),
                      Text(interest.dealTitle,
                          style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: w * 0.032)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: w * 0.025, vertical: h * 0.004),
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
                      child: Text(
                        isOpen ? 'OPEN' : 'CLOSED',
                        style: TextStyle(
                          color: isOpen
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFEF4444),
                          fontSize: w * 0.025,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.006),
                    GestureDetector(
                      onTap: () => _confirmRemove(context),
                      child: Container(
                        padding: EdgeInsets.all(w * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(w * 0.02),
                          border: Border.all(
                              color: const Color(0xFFEF4444), width: 1),
                        ),
                        child: Icon(Icons.delete_outline_rounded,
                            color: const Color(0xFFEF4444), size: w * 0.04),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: h * 0.01),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03, vertical: h * 0.004),
              decoration: BoxDecoration(
                color: Color.fromRGBO(industryColor.red, industryColor.green,
                    industryColor.blue, 0.15),
                borderRadius: BorderRadius.circular(w * 0.015),
              ),
              child: Text(interest.industry.toUpperCase(),
                  style: TextStyle(
                      color: industryColor,
                      fontSize: w * 0.028,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5)),
            ),
            SizedBox(height: h * 0.015),
            const Divider(color: Color(0xFF2A3A55), thickness: 1),
            SizedBox(height: h * 0.01),
            _infoRow(Icons.account_balance_wallet_outlined, 'Min Ticket',
                interest.investmentRequired, Colors.white, w),
            SizedBox(height: h * 0.008),
            _infoRow(
                Icons.trending_up_rounded,
                'Expected ROI',
                '${interest.expectedRoi.toStringAsFixed(1)}%',
                const Color(0xFF22C55E),
                w),
            SizedBox(height: h * 0.008),
            _infoRow(Icons.warning_amber_rounded, 'Risk Level',
                interest.riskLevel, getRiskColor(interest.riskLevel), w),
            SizedBox(height: h * 0.018),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DealDetailScreen(
                    deal: _toDealEntity(),
                    investorEmail: interest.investorEmail,
                  ),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: h * 0.055,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(w * 0.03),
                  border: Border.all(
                      color: const Color(0xFF6366F1), width: 1.5),
                ),
                child: Center(
                  child: Text('VIEW DETAILS',
                      style: TextStyle(
                          color: const Color(0xFF6366F1),
                          fontSize: w * 0.035,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value,
      Color valueColor, double w) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF94A3B8), size: w * 0.042),
            SizedBox(width: w * 0.022),
            Text(label,
                style: TextStyle(
                    color: const Color(0xFF94A3B8), fontSize: w * 0.034)),
          ],
        ),
        Text(value,
            style: TextStyle(
                color: valueColor,
                fontSize: w * 0.036,
                fontWeight: FontWeight.w700)),
      ],
    );
  }

  void _confirmRemove(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(w * 0.04)),
        title: const Text('Remove Interest',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text(
            'Are you sure you want to remove your interest in ${interest.companyName}?',
            style: const TextStyle(color: Color(0xFF94A3B8))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              context.read<InterestBloc>().add(RemoveInterestEvent(
                    dealId: interest.dealId,
                    investorEmail: interest.investorEmail,
                  ));
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(w * 0.02),
              ),
              child: const Text('Remove',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}