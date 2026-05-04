import 'package:flutter/material.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/deal_detail_screen.dart';

class DealListingScreen extends StatefulWidget {
  const DealListingScreen({super.key});

  @override
  State<DealListingScreen> createState() => _DealListingScreenState();
}

class _DealListingScreenState extends State<DealListingScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Active filter state
  String? _selectedIndustry;
  String? _selectedRisk;
  RangeValues _roiRange = const RangeValues(0, 30);

  // Temp filter state (used inside bottom sheet before applying)
  String? _tempIndustry;
  String? _tempRisk;
  RangeValues _tempRoiRange = const RangeValues(0, 30);

  final List<String> _industries = [
    'Tech',
    'Finance',
    'Healthcare',
    'Energy',
    'Real Estate',
  ];

  final List<String> _riskLevels = ['Low', 'Medium', 'High'];

  final List<Map<String, dynamic>> _deals = [
    {
      'company': 'CloudScale AI',
      'industry': 'TECH',
      'investment': '₹50,00,000',
      'roi': 18.0,
      'risk': 'Medium',
      'status': 'OPEN',
    },
    {
      'company': 'HealthGen',
      'industry': 'HEALTHCARE',
      'investment': '₹75,00,000',
      'roi': 22.0,
      'risk': 'Medium',
      'status': 'OPEN',
    },
    {
      'company': 'FinTech Pro',
      'industry': 'FINANCE',
      'investment': '₹30,00,000',
      'roi': 14.0,
      'risk': 'Low',
      'status': 'OPEN',
    },
    {
      'company': 'SolarEdge Power',
      'industry': 'ENERGY',
      'investment': '₹1,20,00,000',
      'roi': 25.0,
      'risk': 'High',
      'status': 'OPEN',
    },
    {
      'company': 'MetroRealty',
      'industry': 'REAL ESTATE',
      'investment': '₹2,00,00,000',
      'roi': 12.0,
      'risk': 'Low',
      'status': 'CLOSED',
    },
  ];

  bool get _hasActiveFilters =>
      _selectedIndustry != null ||
      _selectedRisk != null ||
      _roiRange.start != 0 ||
      _roiRange.end != 30;

  int get _activeFilterCount {
    int count = 0;
    if (_selectedIndustry != null) count++;
    if (_selectedRisk != null) count++;
    if (_roiRange.start != 0 || _roiRange.end != 30) count++;
    return count;
  }

  List<Map<String, dynamic>> get _filteredDeals {
    return _deals.where((deal) {
      final matchesIndustry =
          _selectedIndustry == null ||
          deal['industry'].toString().toUpperCase() ==
              _selectedIndustry!.toUpperCase();

      final matchesRisk =
          _selectedRisk == null ||
          deal['risk'].toString().toLowerCase() == _selectedRisk!.toLowerCase();

      final double roi = deal['roi'] as double;
      final matchesRoi = roi >= _roiRange.start && roi <= _roiRange.end;

      final matchesSearch =
          _searchController.text.isEmpty ||
          deal['company'].toString().toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      return matchesIndustry && matchesRisk && matchesRoi && matchesSearch;
    }).toList();
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
        return const Color(0xFF3B82F6);
      case 'healthcare':
        return const Color(0xFF06B6D4);
      case 'finance':
        return const Color(0xFF8B5CF6);
      case 'energy':
        return const Color(0xFFF59E0B);
      case 'real estate':
        return const Color(0xFF22C55E);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  void _openFilterSheet() {
    // Copy current filters to temp
    _tempIndustry = _selectedIndustry;
    _tempRisk = _selectedRisk;
    _tempRoiRange = _roiRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildFilterSheet(),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedIndustry = null;
      _selectedRisk = null;
      _roiRange = const RangeValues(0, 30);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            colors: [Color(0xFF0D1B3E), Color(0xFF0A0F2C), Color(0xFF060B1E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top App Bar
              _buildAppBar(deviceWidth, deviceHeight),

              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth * 0.05,
                  vertical: deviceHeight * 0.012,
                ),
                child: _buildSearchBar(deviceWidth, deviceHeight),
              ),

              // Filter row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Filter button
                    GestureDetector(
                      onTap: _openFilterSheet,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth * 0.04,
                          vertical: deviceHeight * 0.009,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _hasActiveFilters
                                  ? const Color(0xFF3B82F6).withOpacity(0.15)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            deviceWidth * 0.025,
                          ),
                          border: Border.all(
                            color:
                                _hasActiveFilters
                                    ? const Color(0xFF3B82F6)
                                    : const Color(0xFF2A3A55),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              color:
                                  _hasActiveFilters
                                      ? const Color(0xFF3B82F6)
                                      : const Color(0xFF94A3B8),
                              size: deviceWidth * 0.045,
                            ),
                            SizedBox(width: deviceWidth * 0.02),
                            Text(
                              'Filters',
                              style: TextStyle(
                                color:
                                    _hasActiveFilters
                                        ? const Color(0xFF3B82F6)
                                        : const Color(0xFF94A3B8),
                                fontSize: deviceWidth * 0.038,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_hasActiveFilters) ...[
                              SizedBox(width: deviceWidth * 0.02),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3B82F6),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$_activeFilterCount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceWidth * 0.028,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        if (_hasActiveFilters)
                          GestureDetector(
                            onTap: _clearAllFilters,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: deviceWidth * 0.03,
                              ),
                              child: Text(
                                'Clear all',
                                style: TextStyle(
                                  color: const Color(0xFFEF4444),
                                  fontSize: deviceWidth * 0.032,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: deviceHeight * 0.015),

              // Deal cards list
              Expanded(
                child:
                    _filteredDeals.isEmpty
                        ? _buildEmptyState(deviceWidth, deviceHeight)
                        : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth * 0.05,
                          ),
                          itemCount: _filteredDeals.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: deviceHeight * 0.018,
                              ),
                              child: _buildDealCard(
                                _filteredDeals[index],
                                deviceWidth,
                                deviceHeight,
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Filter Bottom Sheet ────────────────────────────────────────────────────

  Widget _buildFilterSheet() {
    return StatefulBuilder(
      builder: (context, setSheetState) {
        final double deviceWidth = MediaQuery.of(context).size.width;
        final double deviceHeight = MediaQuery.of(context).size.height;

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0D1B3E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: Color(0xFF2A3A55), width: 1),
              left: BorderSide(color: Color(0xFF2A3A55), width: 1),
              right: BorderSide(color: Color(0xFF2A3A55), width: 1),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            deviceWidth * 0.06,
            deviceHeight * 0.025,
            deviceWidth * 0.06,
            deviceHeight * 0.04,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: deviceWidth * 0.12,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A3A55),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: deviceHeight * 0.025),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Deals',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceWidth * 0.052,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setSheetState(() {
                        _tempIndustry = null;
                        _tempRisk = null;
                        _tempRoiRange = const RangeValues(0, 30);
                      });
                    },
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        color: const Color(0xFFEF4444),
                        fontSize: deviceWidth * 0.038,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: deviceHeight * 0.03),

              // ── Industry ──────────────────────────────────────────────
              Text(
                'INDUSTRY',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: deviceWidth * 0.03,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: deviceHeight * 0.012),
              Wrap(
                spacing: deviceWidth * 0.025,
                runSpacing: deviceHeight * 0.01,
                children:
                    _industries.map((industry) {
                      final bool isSelected = _tempIndustry == industry;
                      final Color color = _getIndustryColor(industry);
                      return GestureDetector(
                        onTap:
                            () => setSheetState(() {
                              _tempIndustry = isSelected ? null : industry;
                            }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth * 0.04,
                            vertical: deviceHeight * 0.009,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? color.withOpacity(0.18)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              deviceWidth * 0.05,
                            ),
                            border: Border.all(
                              color:
                                  isSelected ? color : const Color(0xFF2A3A55),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            industry,
                            style: TextStyle(
                              color:
                                  isSelected ? color : const Color(0xFF94A3B8),
                              fontSize: deviceWidth * 0.036,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),

              SizedBox(height: deviceHeight * 0.028),

              // ── Risk Level ────────────────────────────────────────────
              Text(
                'RISK LEVEL',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: deviceWidth * 0.03,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: deviceHeight * 0.012),
              Row(
                children:
                    _riskLevels.map((risk) {
                      final bool isSelected = _tempRisk == risk;
                      final Color color = _getRiskColor(risk);
                      return Padding(
                        padding: EdgeInsets.only(right: deviceWidth * 0.03),
                        child: GestureDetector(
                          onTap:
                              () => setSheetState(() {
                                _tempRisk = isSelected ? null : risk;
                              }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: EdgeInsets.symmetric(
                              horizontal: deviceWidth * 0.05,
                              vertical: deviceHeight * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? color.withOpacity(0.18)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                deviceWidth * 0.05,
                              ),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? color
                                        : const Color(0xFF2A3A55),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: deviceWidth * 0.022,
                                  height: deviceWidth * 0.022,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: deviceWidth * 0.02),
                                Text(
                                  risk,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? color
                                            : const Color(0xFF94A3B8),
                                    fontSize: deviceWidth * 0.036,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),

              SizedBox(height: deviceHeight * 0.028),

              // ── ROI Range ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ROI RANGE',
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: deviceWidth * 0.03,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * 0.03,
                      vertical: deviceHeight * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                    ),
                    child: Text(
                      '${_tempRoiRange.start.round()}% – ${_tempRoiRange.end.round()}%',
                      style: TextStyle(
                        color: const Color(0xFF3B82F6),
                        fontSize: deviceWidth * 0.034,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF3B82F6),
                  inactiveTrackColor: const Color(0xFF2A3A55),
                  thumbColor: const Color(0xFF3B82F6),
                  overlayColor: const Color(0xFF3B82F6).withOpacity(0.15),
                  rangeThumbShape: const RoundRangeSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                  trackHeight: 4,
                ),
                child: RangeSlider(
                  values: _tempRoiRange,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  onChanged:
                      (values) => setSheetState(() => _tempRoiRange = values),
                ),
              ),

              SizedBox(height: deviceHeight * 0.03),

              // ── Apply Button ──────────────────────────────────────────
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndustry = _tempIndustry;
                    _selectedRisk = _tempRisk;
                    _roiRange = _tempRoiRange;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: deviceHeight * 0.062,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                    ),
                    borderRadius: BorderRadius.circular(deviceWidth * 0.035),
                  ),
                  child: Center(
                    child: Text(
                      'APPLY FILTERS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceWidth * 0.04,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Shared Widgets ─────────────────────────────────────────────────────────

  Widget _buildAppBar(double deviceWidth, double deviceHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.05,
        vertical: deviceHeight * 0.018,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hello, Investor ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceWidth * 0.052,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text('👋', style: TextStyle(fontSize: deviceWidth * 0.052)),
                ],
              ),
              Text(
                'Find your next deal',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: deviceWidth * 0.032,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double deviceWidth, double deviceHeight) {
    return Container(
      height: deviceHeight * 0.065,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
        border: Border.all(color: const Color(0xFF2A3A55), width: 1),
      ),
      child: Row(
        children: [
          SizedBox(width: deviceWidth * 0.04),
          Icon(
            Icons.search_rounded,
            color: const Color(0xFF94A3B8),
            size: deviceWidth * 0.055,
          ),
          SizedBox(width: deviceWidth * 0.03),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: TextStyle(
                color: Colors.white,
                fontSize: deviceWidth * 0.038,
              ),
              decoration: InputDecoration(
                hintText: 'Search by company name...',
                hintStyle: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: deviceWidth * 0.038,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.only(right: deviceWidth * 0.03),
                child: Icon(
                  Icons.close_rounded,
                  color: const Color(0xFF94A3B8),
                  size: deviceWidth * 0.045,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDealCard(
    Map<String, dynamic> deal,
    double deviceWidth,
    double deviceHeight,
  ) {
    final bool isOpen = deal['status'] == 'OPEN';
    final Color industryColor = _getIndustryColor(deal['industry']);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(deviceWidth * 0.045),
        border: Border.all(color: const Color(0xFF2A3A55), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(deviceWidth * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company name + status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  deal['company'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: deviceWidth * 0.048,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth * 0.03,
                    vertical: deviceHeight * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isOpen
                            ? const Color(0xFF22C55E).withOpacity(0.15)
                            : const Color(0xFFEF4444).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                    border: Border.all(
                      color:
                          isOpen
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFEF4444),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    deal['status'],
                    style: TextStyle(
                      color:
                          isOpen
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFEF4444),
                      fontSize: deviceWidth * 0.028,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: deviceHeight * 0.008),

            // Industry chip
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.03,
                vertical: deviceHeight * 0.004,
              ),
              decoration: BoxDecoration(
                color: industryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(deviceWidth * 0.015),
              ),
              child: Text(
                deal['industry'],
                style: TextStyle(
                  color: industryColor,
                  fontSize: deviceWidth * 0.028,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            SizedBox(height: deviceHeight * 0.015),

            Divider(color: const Color(0xFF2A3A55), thickness: 1),

            SizedBox(height: deviceHeight * 0.012),

            _buildInfoRow(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Investment Required',
              value: deal['investment'],
              valueColor: Colors.white,
              deviceWidth: deviceWidth,
              deviceHeight: deviceHeight,
            ),

            SizedBox(height: deviceHeight * 0.01),

            _buildInfoRow(
              icon: Icons.trending_up_rounded,
              label: 'Expected ROI',
              value: '${deal['roi'].round()}%',
              valueColor: const Color(0xFF22C55E),
              deviceWidth: deviceWidth,
              deviceHeight: deviceHeight,
            ),

            SizedBox(height: deviceHeight * 0.01),

            _buildInfoRow(
              icon: Icons.warning_amber_rounded,
              label: 'Risk Level',
              value: deal['risk'],
              valueColor: _getRiskColor(deal['risk']),
              deviceWidth: deviceWidth,
              deviceHeight: deviceHeight,
            ),

            SizedBox(height: deviceHeight * 0.018),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DealDetailScreen(deal: deal,);
                    },
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: deviceHeight * 0.055,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                  border: Border.all(
                    color: const Color(0xFF3B82F6),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    'VIEW DETAILS',
                    style: TextStyle(
                      color: const Color(0xFF3B82F6),
                      fontSize: deviceWidth * 0.035,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    required double deviceWidth,
    required double deviceHeight,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF94A3B8),
              size: deviceWidth * 0.045,
            ),
            SizedBox(width: deviceWidth * 0.025),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: deviceWidth * 0.036,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: deviceWidth * 0.038,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(double deviceWidth, double deviceHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            color: const Color(0xFF2A3A55),
            size: deviceWidth * 0.18,
          ),
          SizedBox(height: deviceHeight * 0.02),
          Text(
            'No Deals Found',
            style: TextStyle(
              color: Colors.white,
              fontSize: deviceWidth * 0.05,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: deviceHeight * 0.008),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: deviceWidth * 0.036,
            ),
          ),
        ],
      ),
    );
  }
}
