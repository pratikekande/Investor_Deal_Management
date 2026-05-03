import 'package:flutter/material.dart';

class DealListingScreen extends StatefulWidget {
  const DealListingScreen({super.key});

  @override
  State<DealListingScreen> createState() => _DealListingScreenState();
}

class _DealListingScreenState extends State<DealListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  int _selectedNavIndex = 0;

  final List<String> _categories = [
    'All',
    'Tech',
    'Finance',
    'Healthcare',
    'Energy',
    'Real Estate',
  ];

  final List<Map<String, dynamic>> _deals = [
    {
      'company': 'CloudScale AI',
      'industry': 'TECH',
      'investment': '₹50,00,000',
      'roi': '18%',
      'risk': 'Medium',
      'status': 'OPEN',
    },
    {
      'company': 'HealthGen',
      'industry': 'HEALTHCARE',
      'investment': '₹75,00,000',
      'roi': '22%',
      'risk': 'Medium',
      'status': 'OPEN',
    },
    {
      'company': 'FinTech Pro',
      'industry': 'FINANCE',
      'investment': '₹30,00,000',
      'roi': '14%',
      'risk': 'Low',
      'status': 'OPEN',
    },
    {
      'company': 'SolarEdge Power',
      'industry': 'ENERGY',
      'investment': '₹1,20,00,000',
      'roi': '25%',
      'risk': 'High',
      'status': 'OPEN',
    },
    {
      'company': 'MetroRealty',
      'industry': 'REAL ESTATE',
      'investment': '₹2,00,00,000',
      'roi': '12%',
      'risk': 'Low',
      'status': 'CLOSED',
    },
  ];

  List<Map<String, dynamic>> get _filteredDeals {
    return _deals.where((deal) {
      final matchesCategory = _selectedCategory == 'All' ||
          deal['industry'].toString().toUpperCase() ==
              _selectedCategory.toUpperCase();
      final matchesSearch = _searchController.text.isEmpty ||
          deal['company']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
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
            colors: [
              Color(0xFF0D1B3E),
              Color(0xFF0A0F2C),
              Color(0xFF060B1E),
            ],
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
                  vertical: deviceHeight * 0.015,
                ),
                child: _buildSearchBar(deviceWidth, deviceHeight),
              ),

              // Category chips
              SizedBox(
                height: deviceHeight * 0.05,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryChip(
                      _categories[index],
                      deviceWidth,
                      deviceHeight,
                    );
                  },
                ),
              ),

              SizedBox(height: deviceHeight * 0.015),

              // Filter row
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: Show filter bottom sheet
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            color: const Color(0xFF3B82F6),
                            size: deviceWidth * 0.05,
                          ),
                          SizedBox(width: deviceWidth * 0.02),
                          Text(
                            'Filters',
                            style: TextStyle(
                              color: const Color(0xFF3B82F6),
                              fontSize: deviceWidth * 0.038,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${_filteredDeals.length} DEALS FOUND',
                      style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: deviceWidth * 0.032,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: deviceHeight * 0.015),

              // Deal cards list
              Expanded(
                child: _filteredDeals.isEmpty
                    ? _buildEmptyState(deviceWidth, deviceHeight)
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth * 0.05,
                        ),
                        itemCount: _filteredDeals.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: deviceHeight * 0.018),
                            child: _buildDealCard(
                              _filteredDeals[index],
                              deviceWidth,
                              deviceHeight,
                            ),
                          );
                        },
                      ),
              ),

              // Bottom Navigation Bar
              _buildBottomNavBar(deviceWidth, deviceHeight),
            ],
          ),
        ),
      ),
    );
  }

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
                  Text(
                    '👋',
                    style: TextStyle(fontSize: deviceWidth * 0.052),
                  ),
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
          // Avatar
          Container(
            width: deviceWidth * 0.11,
            height: deviceWidth * 0.11,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF3B82F6),
                width: 2,
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: deviceWidth * 0.06,
            ),
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
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      String category, double deviceWidth, double deviceHeight) {
    final bool isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: deviceWidth * 0.03),
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.045,
          vertical: deviceHeight * 0.008,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(deviceWidth * 0.06),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFF2A3A55),
            width: 1.5,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontSize: deviceWidth * 0.036,
            fontWeight:
                isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDealCard(
      Map<String, dynamic> deal, double deviceWidth, double deviceHeight) {
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
                    color: isOpen
                        ? const Color(0xFF22C55E).withOpacity(0.15)
                        : const Color(0xFFEF4444).withOpacity(0.15),
                    borderRadius:
                        BorderRadius.circular(deviceWidth * 0.02),
                    border: Border.all(
                      color: isOpen
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    deal['status'],
                    style: TextStyle(
                      color: isOpen
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

            // Investment Required
            _buildInfoRow(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Investment Required',
              value: deal['investment'],
              valueColor: Colors.white,
              deviceWidth: deviceWidth,
              deviceHeight: deviceHeight,
            ),

            SizedBox(height: deviceHeight * 0.01),

            // Expected ROI
            _buildInfoRow(
              icon: Icons.trending_up_rounded,
              label: 'Expected ROI',
              value: deal['roi'],
              valueColor: const Color(0xFF22C55E),
              deviceWidth: deviceWidth,
              deviceHeight: deviceHeight,
            ),

            SizedBox(height: deviceHeight * 0.01),

            // Risk Level
            _buildInfoRow(
              icon: Icons.warning_amber_rounded,
              label: 'Risk Level',
              value: deal['risk'],
              valueColor: _getRiskColor(deal['risk']),
              deviceWidth: deviceWidth,
              deviceHeight: deviceHeight,
            ),

            SizedBox(height: deviceHeight * 0.018),

            // View Details button
            GestureDetector(
              onTap: () {
                // TODO: Navigate to Deal Detail screen
              },
              child: Container(
                width: double.infinity,
                height: deviceHeight * 0.055,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(deviceWidth * 0.03),
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

  Widget _buildBottomNavBar(double deviceWidth, double deviceHeight) {
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.handshake_outlined, 'label': 'DEALS'},
      {'icon': Icons.pie_chart_outline_rounded, 'label': 'PORTFOLIO'},
      {'icon': Icons.insights_rounded, 'label': 'INSIGHTS'},
      {'icon': Icons.settings_outlined, 'label': 'SETTINGS'},
    ];

    return Container(
      height: deviceHeight * 0.09,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        border: Border(
          top: BorderSide(color: const Color(0xFF2A3A55), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final bool isActive = _selectedNavIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedNavIndex = index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  navItems[index]['icon'],
                  color: isActive
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF94A3B8),
                  size: deviceWidth * 0.06,
                ),
                SizedBox(height: deviceHeight * 0.005),
                Text(
                  navItems[index]['label'],
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF94A3B8),
                    fontSize: deviceWidth * 0.025,
                    fontWeight: isActive
                        ? FontWeight.w700
                        : FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}