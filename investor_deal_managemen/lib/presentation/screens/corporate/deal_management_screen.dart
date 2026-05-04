import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_state.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_state.dart';

class MyDealsScreen extends StatefulWidget {
  const MyDealsScreen({super.key});

  @override
  State<MyDealsScreen> createState() => _MyDealsScreenState();
}

class _MyDealsScreenState extends State<MyDealsScreen> {
  String _activeFilter = 'All';

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context
          .read<DealBloc>()
          .add(LoadMyDealsEvent(authState.user.email));
    }
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

  List<DealEntity> _applyFilter(List<DealEntity> all) {
    if (_activeFilter == 'All') return all;
    return all
        .where((d) =>
            d.status.toLowerCase() == _activeFilter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(w, h),
            Expanded(
              child: BlocConsumer<DealBloc, DealState>(
                listener: (ctx, state) {
                  if (state is DealOperationSuccess) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: const Color(0xFF1E2A45),
                      behavior: SnackBarBehavior.floating,
                    ));
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
                  if (state is DealLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF6366F1)));
                  }
                  if (state is DealsLoaded) {
                    final all = state.allDeals;
                    final filtered = _applyFilter(all);

                    return RefreshIndicator(
                      color: const Color(0xFF6366F1),
                      backgroundColor: const Color(0xFF1E2A3F),
                      onRefresh: () async {
                        final authState = context.read<AuthBloc>().state;
                        if (authState is AuthAuthenticated) {
                          context.read<DealBloc>().add(LoadMyDealsEvent(authState.user.email));
                        }
                        await Future.delayed(const Duration(milliseconds: 800));
                      },
                      child: all.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: h * 0.25),
                                _buildEmptyState(w, h),
                              ],
                            )
                          : Column(
                              children: [
                                _buildPortfolioBanner(all, w, h),
                                _buildFilterPills(w, h),
                                Expanded(
                                  child: filtered.isEmpty
                                      ? ListView(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          children: [
                                            SizedBox(height: h * 0.2),
                                            Center(
                                              child: Text(
                                                'No $_activeFilter deals',
                                                style: const TextStyle(
                                                  color: Color(0xFF94A3B8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : ListView.builder(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: w * 0.05,
                                              vertical: h * 0.01),
                                          itemCount: filtered.length,
                                          itemBuilder: (_, i) => Padding(
                                            padding: EdgeInsets.only(
                                                bottom: h * 0.018),
                                            child: _CorporateDealCard(
                                              deal: filtered[i],
                                              getRiskColor: _getRiskColor,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                    );
                  }
                  if (state is DealError) {
                    return Center(
                        child: Text(state.message,
                            style: const TextStyle(
                                color: Color(0xFFEF4444))));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(double w, double h) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: w * 0.05, vertical: h * 0.018),
          child: Row(
            children: [
              Text('My Deals',
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

  Widget _buildPortfolioBanner(List<DealEntity> all, double w, double h) {
    final int open =
        all.where((d) => d.status.toLowerCase() == 'open').length;
    final int closed =
        all.where((d) => d.status.toLowerCase() == 'closed').length;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: w * 0.05, vertical: h * 0.015),
      padding: EdgeInsets.all(w * 0.045),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF1A2235)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: const Color(0xFF1E2A3F), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('TOTAL', '${all.length}', Colors.white, w),
          Container(
              width: 1, height: h * 0.05, color: const Color(0xFF1E2A3F)),
          _statItem('OPEN', '$open', const Color(0xFF22C55E), w),
          Container(
              width: 1, height: h * 0.05, color: const Color(0xFF1E2A3F)),
          _statItem('CLOSED', '$closed', const Color(0xFFEF4444), w),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color, double w) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: w * 0.065,
                fontWeight: FontWeight.w800)),
        Text(label,
            style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: w * 0.028,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildFilterPills(double w, double h) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: w * 0.05, vertical: h * 0.008),
      child: Row(
        children: ['All', 'Open', 'Closed'].map((f) {
          final bool selected = _activeFilter == f;
          return Padding(
            padding: EdgeInsets.only(right: w * 0.02),
            child: GestureDetector(
              onTap: () => setState(() => _activeFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04, vertical: h * 0.008),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(w * 0.02),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF6366F1)
                        : const Color(0xFF1E2A3F),
                  ),
                ),
                child: Text(f,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.035,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(double w, double h) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business_center_outlined,
              color: const Color(0xFF1E2A3F), size: w * 0.18),
          SizedBox(height: h * 0.02),
          Text('No deals yet',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: h * 0.008),
          Text('Post your first deal!',
              style: TextStyle(
                  color: const Color(0xFF94A3B8), fontSize: w * 0.036)),
        ],
      ),
    );
  }
}

// ── Corporate Deal Card ───────────────────────────────────────────────────────

class _CorporateDealCard extends StatelessWidget {
  final DealEntity deal;
  final Color Function(String) getRiskColor;

  const _CorporateDealCard({
    required this.deal,
    required this.getRiskColor,
  });

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final bool isOpen = deal.status.toLowerCase() == 'open';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.045),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(w * 0.045),
        border: Border.all(color: const Color(0xFF1E2A3F), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('${deal.title} – ${deal.companyName}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.042,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          SizedBox(height: w * 0.025),
          Row(
            children: [
              _chip(deal.industry, const Color(0xFF374151),
                  const Color(0xFFD1D5DB), w),
              SizedBox(width: w * 0.02),
              _chip(
                  isOpen ? 'OPEN' : 'CLOSED',
                  isOpen
                      ? const Color(0xFF4F46E5).withOpacity(0.2)
                      : const Color(0xFF374151),
                  isOpen
                      ? const Color(0xFF818CF8)
                      : const Color(0xFF9CA3AF),
                  w),
            ],
          ),
          SizedBox(height: w * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Funding Progress',
                  style: TextStyle(
                      color: const Color(0xFF9CA3AF), fontSize: w * 0.033)),
              Text(isOpen ? '75%' : '100%',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.033,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: w * 0.02),
          ClipRRect(
            borderRadius: BorderRadius.circular(w * 0.02),
            child: LinearProgressIndicator(
              value: isOpen ? 0.75 : 1.0,
              minHeight: w * 0.018,
              backgroundColor: const Color(0xFF1E2A3F),
              valueColor: AlwaysStoppedAnimation<Color>(
                isOpen
                    ? const Color(0xFF6366F1)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
          SizedBox(height: w * 0.04),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('INVESTMENT    ROI',
                        style: TextStyle(
                            color: const Color(0xFF6B7280),
                            fontSize: w * 0.028,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5)),
                    SizedBox(height: w * 0.01),
                    Row(
                      children: [
                        Text(deal.investmentRequired,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.038,
                                fontWeight: FontWeight.w700)),
                        SizedBox(width: w * 0.025),
                        Text(
                            '${deal.expectedRoi.toStringAsFixed(1)}%',
                            style: TextStyle(
                                color: const Color(0xFF22C55E),
                                fontSize: w * 0.035,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RISK',
                      style: TextStyle(
                          color: const Color(0xFF6B7280),
                          fontSize: w * 0.028,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5)),
                  SizedBox(height: w * 0.01),
                  Text(deal.riskLevel,
                      style: TextStyle(
                          color: getRiskColor(deal.riskLevel),
                          fontSize: w * 0.042,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          SizedBox(height: w * 0.04),
          Row(
            children: [
              if (isOpen)
                Expanded(
                  child: _outlineBtn(
                    'CLOSE DEAL',
                    const Color(0xFFEF4444),
                    w,
                    () => _confirmAction(
                      context,
                      'Close Deal',
                      'Are you sure you want to close "${deal.title}"?',
                      () => context.read<DealBloc>().add(
                            UpdateDealStatusEvent(
                                dealId: deal.id!, status: 'Closed'),
                          ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: _outlineBtn(
                    'REOPEN',
                    const Color(0xFF22C55E),
                    w,
                    () => context.read<DealBloc>().add(
                          UpdateDealStatusEvent(
                              dealId: deal.id!, status: 'Open'),
                        ),
                  ),
                ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: _outlineBtn(
                  'DELETE',
                  const Color(0xFFEF4444),
                  w,
                  () => _confirmAction(
                    context,
                    'Delete Deal',
                    'Are you sure you want to permanently delete "${deal.title}"?',
                    () => context
                        .read<DealBloc>()
                        .add(DeleteDealEvent(deal.id!)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(
      String label, Color bgColor, Color textColor, double w) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.012),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(w * 0.02),
      ),
      child: Text(label,
          style: TextStyle(
              color: textColor,
              fontSize: w * 0.028,
              fontWeight: FontWeight.w600)),
    );
  }

  Widget _outlineBtn(
      String label, Color color, double w, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: w * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w * 0.03),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: w * 0.03,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5)),
        ),
      ),
    );
  }

  void _confirmAction(
      BuildContext context, String title, String message, VoidCallback onConfirm) {
    final double w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(w * 0.04)),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text(message,
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
              onConfirm();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(w * 0.02),
              ),
              child: const Text('Confirm',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}