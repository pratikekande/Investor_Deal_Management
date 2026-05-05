import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_deal_managemen/core/route_observer.dart';
import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_state.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_event.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_state.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/deal_detail_screen.dart';

class DealListingScreen extends StatefulWidget {
  const DealListingScreen({super.key});

  @override
  State<DealListingScreen> createState() => _DealListingScreenState();
}

class _DealListingScreenState extends State<DealListingScreen> with RouteAware {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _hasActiveFilters = false;
  int _activeFilterCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.unfocus();
    });
    context.read<DealBloc>().add(LoadAllDealsEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Fires when the user pops back from DealDetailScreen.
  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.unfocus();
    });
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

  void _updateFilterState({required bool hasFilters, required int count}) {
    if (mounted) {
      setState(() {
        _hasActiveFilters = hasFilters;
        _activeFilterCount = count;
      });
    }
  }

  void _openFilterSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: ctx.read<DealBloc>(),
        child: _FilterBottomSheet(onFiltersChanged: _updateFilterState),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _searchController.clear();
    _searchFocusNode.unfocus();
    context.read<DealBloc>().add(LoadAllDealsEvent());
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      return context.read<DealBloc>().state is DealLoading;
    }).timeout(const Duration(seconds: 10), onTimeout: () {});
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    String userName = 'Investor';
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      userName = authState.user.name;
    }

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
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(w, h, userName),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.05, vertical: h * 0.012),
                  child: _buildSearchBar(w, h),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _openFilterSheet(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: w * 0.04, vertical: h * 0.009),
                          decoration: BoxDecoration(
                            color: _hasActiveFilters
                                ? const Color(0x266366F1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(w * 0.025),
                            border: Border.all(
                              color: _hasActiveFilters
                                  ? const Color(0xFF6366F1)
                                  : const Color(0xFF2A3A55),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.tune_rounded,
                                  color: _hasActiveFilters
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFF94A3B8),
                                  size: w * 0.045),
                              SizedBox(width: w * 0.02),
                              Text('Filters',
                                  style: TextStyle(
                                    color: _hasActiveFilters
                                        ? const Color(0xFF6366F1)
                                        : const Color(0xFF94A3B8),
                                    fontSize: w * 0.038,
                                    fontWeight: FontWeight.w600,
                                  )),
                              if (_hasActiveFilters) ...[
                                SizedBox(width: w * 0.02),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF6366F1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text('$_activeFilterCount',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.028,
                                        fontWeight: FontWeight.w700,
                                      )),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (_hasActiveFilters)
                        GestureDetector(
                          onTap: () {
                            context.read<DealBloc>().add(ClearFiltersEvent());
                            _updateFilterState(hasFilters: false, count: 0);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: w * 0.03),
                            child: Text('Clear all',
                                style: TextStyle(
                                  color: const Color(0xFFEF4444),
                                  fontSize: w * 0.032,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.015),
                Expanded(
                  child: BlocBuilder<DealBloc, DealState>(
                    builder: (ctx, state) {
                      if (state is DealLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF6366F1)),
                        );
                      }
                      if (state is DealError) {
                        return Center(
                          child: Text(state.message,
                              style: const TextStyle(
                                  color: Color(0xFFEF4444))),
                        );
                      }
                      if (state is DealsLoaded) {
                        if (state.filteredDeals.isEmpty) {
                          return RefreshIndicator(
                            onRefresh: _onRefresh,
                            color: const Color(0xFF6366F1),
                            backgroundColor: const Color(0xFF1E2A45),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height: h * 0.5,
                                child: _buildEmptyState(w, h),
                              ),
                            ),
                          );
                        }
                        final String investorEmail =
                            (context.read<AuthBloc>().state
                                    as AuthAuthenticated)
                                .user
                                .email;
                        return RefreshIndicator(
                          onRefresh: _onRefresh,
                          color: const Color(0xFF6366F1),
                          backgroundColor: const Color(0xFF1E2A45),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding:
                                EdgeInsets.symmetric(horizontal: w * 0.05),
                            itemCount: state.filteredDeals.length,
                            itemBuilder: (_, i) => Padding(
                              padding: EdgeInsets.only(bottom: h * 0.018),
                              child: _DealCard(
                                deal: state.filteredDeals[i],
                                currentInvestorEmail: investorEmail,
                                getRiskColor: _getRiskColor,
                                getIndustryColor: _getIndustryColor,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(double w, double h, String userName) {
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
                  Text('Find your next deal',
                      style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: w * 0.032,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFF1E2A45), thickness: 1, height: 1),
      ],
    );
  }

  Widget _buildSearchBar(double w, double h) {
    return Container(
      height: h * 0.065,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: const Color(0xFF2A3A55), width: 1),
      ),
      child: Row(
        children: [
          SizedBox(width: w * 0.04),
          Icon(Icons.search_rounded,
              color: const Color(0xFF94A3B8), size: w * 0.055),
          SizedBox(width: w * 0.03),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (q) =>
                  context.read<DealBloc>().add(SearchDealsEvent(q)),
              style: TextStyle(color: Colors.white, fontSize: w * 0.038),
              decoration: InputDecoration(
                hintText: 'Search by company or deal title...',
                hintStyle: TextStyle(
                    color: const Color(0xFF94A3B8), fontSize: w * 0.038),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                context.read<DealBloc>().add(SearchDealsEvent(''));
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.only(right: w * 0.03),
                child: Icon(Icons.close_rounded,
                    color: const Color(0xFF94A3B8), size: w * 0.045),
              ),
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
          Icon(Icons.search_off_rounded,
              color: const Color(0xFF2A3A55), size: w * 0.18),
          SizedBox(height: h * 0.02),
          Text('No Deals Found',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: h * 0.008),
          Text('Try adjusting your search or filters',
              style: TextStyle(
                  color: const Color(0xFF94A3B8), fontSize: w * 0.036)),
        ],
      ),
    );
  }
}

// ── Deal Card ─────────────────────────────────────────────────────────────────

class _DealCard extends StatelessWidget {
  final DealEntity deal;
  final String currentInvestorEmail;
  final Color Function(String) getRiskColor;
  final Color Function(String) getIndustryColor;

  const _DealCard({
    required this.deal,
    required this.currentInvestorEmail,
    required this.getRiskColor,
    required this.getIndustryColor,
  });

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    final bool isOpen = deal.status.toLowerCase() == 'open';
    final Color industryColor = getIndustryColor(deal.industry);

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
                  child: Text(deal.companyName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.048,
                          fontWeight: FontWeight.w700)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.03, vertical: h * 0.005),
                  decoration: BoxDecoration(
                    color: isOpen
                        ? const Color(0x2622C55E)
                        : const Color(0x26EF4444),
                    borderRadius: BorderRadius.circular(w * 0.02),
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
                      fontSize: w * 0.028,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.006),
            Text(deal.title,
                style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: w * 0.033)),
            SizedBox(height: h * 0.008),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03, vertical: h * 0.004),
              decoration: BoxDecoration(
                color: Color.fromRGBO(industryColor.red, industryColor.green,
                    industryColor.blue, 0.15),
                borderRadius: BorderRadius.circular(w * 0.015),
              ),
              child: Text(deal.industry.toUpperCase(),
                  style: TextStyle(
                      color: industryColor,
                      fontSize: w * 0.028,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5)),
            ),
            SizedBox(height: h * 0.015),
            const Divider(color: Color(0xFF2A3A55), thickness: 1),
            SizedBox(height: h * 0.012),
            _infoRow(Icons.account_balance_wallet_outlined,
                'Investment Required', deal.investmentRequired, Colors.white, w),
            SizedBox(height: h * 0.01),
            _infoRow(Icons.trending_up_rounded, 'Expected ROI',
                '${deal.expectedRoi.toStringAsFixed(1)}%',
                const Color(0xFF22C55E), w),
            SizedBox(height: h * 0.01),
            _infoRow(Icons.warning_amber_rounded, 'Risk Level',
                deal.riskLevel, getRiskColor(deal.riskLevel), w),
            SizedBox(height: h * 0.018),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DealDetailScreen(
                      deal: deal,
                      investorEmail: currentInvestorEmail),
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

  Widget _infoRow(IconData icon, String label, String value, Color valueColor,
      double w) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF94A3B8), size: w * 0.045),
            SizedBox(width: w * 0.025),
            Text(label,
                style: TextStyle(
                    color: const Color(0xFF94A3B8), fontSize: w * 0.036)),
          ],
        ),
        Text(value,
            style: TextStyle(
                color: valueColor,
                fontSize: w * 0.038,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// ── Filter Bottom Sheet ───────────────────────────────────────────────────────

class _FilterBottomSheet extends StatefulWidget {
  final void Function({required bool hasFilters, required int count})
      onFiltersChanged;
  const _FilterBottomSheet({required this.onFiltersChanged});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String _industry = 'All';
  String _risk = 'All';
  String _status = 'All';
  RangeValues _roiRange = const RangeValues(0, 100);

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Container(
      height: h * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(w * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter Deals',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.048,
                        fontWeight: FontWeight.w700)),
                TextButton(
                  onPressed: () {
                    context.read<DealBloc>().add(ClearFiltersEvent());
                    widget.onFiltersChanged(hasFilters: false, count: 0);
                    Navigator.pop(context);
                  },
                  child: Text('Reset',
                      style: TextStyle(
                          color: const Color(0xFF6366F1),
                          fontSize: w * 0.038)),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF1E2A3F), thickness: 1, height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(w * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Industry', w),
                  SizedBox(height: h * 0.01),
                  DropdownButtonFormField<String>(
                    value: _industry,
                    dropdownColor: const Color(0xFF1E2A45),
                    style: TextStyle(
                        color: Colors.white, fontSize: w * 0.038),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1E2A45),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w * 0.03),
                        borderSide:
                            const BorderSide(color: Color(0xFF2A3A55)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w * 0.03),
                        borderSide:
                            const BorderSide(color: Color(0xFF2A3A55)),
                      ),
                    ),
                    items: [
                      'All',
                      'Technology',
                      'Healthcare',
                      'Finance',
                      'Energy',
                      'Real Estate',
                      'Manufacturing',
                      'Retail',
                      'Agriculture'
                    ]
                        .map((s) =>
                            DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _industry = v ?? 'All'),
                  ),
                  SizedBox(height: h * 0.02),
                  _label('Risk Level', w),
                  SizedBox(height: h * 0.01),
                  Row(
                    children: ['All', 'Low', 'Medium', 'High']
                        .map((r) => Padding(
                              padding: EdgeInsets.only(right: w * 0.02),
                              child: GestureDetector(
                                onTap: () => setState(() => _risk = r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.04,
                                      vertical: h * 0.009),
                                  decoration: BoxDecoration(
                                    color: _risk == r
                                        ? const Color(0xFF6366F1)
                                        : const Color(0xFF1E2A45),
                                    borderRadius:
                                        BorderRadius.circular(w * 0.02),
                                    border: Border.all(
                                        color: _risk == r
                                            ? const Color(0xFF6366F1)
                                            : const Color(0xFF2A3A55)),
                                  ),
                                  child: Text(r,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: h * 0.02),
                  _label('Status', w),
                  SizedBox(height: h * 0.01),
                  Row(
                    children: ['All', 'Open', 'Closed']
                        .map((s) => Padding(
                              padding: EdgeInsets.only(right: w * 0.02),
                              child: GestureDetector(
                                onTap: () => setState(() => _status = s),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.04,
                                      vertical: h * 0.009),
                                  decoration: BoxDecoration(
                                    color: _status == s
                                        ? const Color(0xFF6366F1)
                                        : const Color(0xFF1E2A45),
                                    borderRadius:
                                        BorderRadius.circular(w * 0.02),
                                    border: Border.all(
                                        color: _status == s
                                            ? const Color(0xFF6366F1)
                                            : const Color(0xFF2A3A55)),
                                  ),
                                  child: Text(s,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: h * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _label('ROI Range', w),
                      Text(
                          '${_roiRange.start.round()}% – ${_roiRange.end.round()}%',
                          style: TextStyle(
                              color: const Color(0xFF6366F1),
                              fontSize: w * 0.036,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  RangeSlider(
                    values: _roiRange,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    activeColor: const Color(0xFF6366F1),
                    inactiveColor: const Color(0xFF2A3A55),
                    onChanged: (v) => setState(() => _roiRange = v),
                  ),
                  SizedBox(height: h * 0.03),
                  GestureDetector(
                    onTap: () {
                      final int count = [
                        _industry == 'All' ? 0 : 1,
                        _risk == 'All' ? 0 : 1,
                        _status == 'All' ? 0 : 1,
                        (_roiRange.start > 0 || _roiRange.end < 100) ? 1 : 0
                      ].fold(0, (a, b) => a + b);
                      context.read<DealBloc>().add(FilterDealsEvent(
                            industry:
                                _industry == 'All' ? null : _industry,
                            riskLevel: _risk == 'All' ? null : _risk,
                            status: _status == 'All' ? null : _status,
                            roiMin: _roiRange.start,
                            roiMax: _roiRange.end,
                          ));
                      widget.onFiltersChanged(
                          hasFilters: count > 0, count: count);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: h * 0.065,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                        ),
                        borderRadius: BorderRadius.circular(w * 0.04),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x4C6366F1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text('Apply Filters',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.042,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, double w) {
    return Text(text,
        style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.04,
            fontWeight: FontWeight.w600));
  }
}