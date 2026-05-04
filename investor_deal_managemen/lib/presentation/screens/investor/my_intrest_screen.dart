import 'package:flutter/material.dart';
import 'package:investor_deal_managemen/presentation/screens/investor/deal_detail_screen.dart';

class MyInterestsScreen extends StatefulWidget {
  const MyInterestsScreen({super.key});

  @override
  State<MyInterestsScreen> createState() => _MyInterestsScreenState();
}

class _MyInterestsScreenState extends State<MyInterestsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _interestedDeals = [
    {
      'company': 'CloudScale AI',
      'category': 'Enterprise AI',
      'status': 'OPEN',
      'minTicket': '₹50L',
      'roi': '18%',
      'risk': 'Medium',
      'icon': Icons.hub_outlined,
      'iconColor': Color(0xFF3B82F6),
    },
    {
      'company': 'FinStream Pro',
      'category': 'Fintech',
      'status': 'OPEN',
      'minTicket': '₹75L',
      'roi': '22%',
      'risk': 'High',
      'icon': Icons.bar_chart_rounded,
      'iconColor': Color(0xFF22C55E),
    },
    {
      'company': 'SecureVault Tech',
      'category': 'Cybersecurity',
      'status': 'CLOSING',
      'minTicket': '₹25L',
      'roi': '14%',
      'risk': 'Low',
      'icon': Icons.security_rounded,
      'iconColor': Color(0xFF06B6D4),
    },
  ];

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

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return const Color(0xFF3B82F6);
      case 'CLOSING':
        return const Color(0xFFF59E0B);
      case 'CLOSED':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  void _removeInterest(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final double deviceWidth = MediaQuery.of(context).size.width;
        final double deviceHeight = MediaQuery.of(context).size.height;

        return AlertDialog(
          backgroundColor: const Color(0xFF1E2A45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(deviceWidth * 0.04),
          ),
          title: Text(
            'Remove Interest',
            style: TextStyle(
              color: Colors.white,
              fontSize: deviceWidth * 0.045,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to remove your interest in ${_interestedDeals[index]['company']}?',
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: deviceWidth * 0.036,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: deviceWidth * 0.038,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _interestedDeals.removeAt(index));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Interest removed successfully'),
                    backgroundColor: Color(0xFF1E2A45),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'Remove',
                style: TextStyle(
                  color: const Color(0xFFEF4444),
                  fontSize: deviceWidth * 0.038,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
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

                Divider(
                  color: const Color(0xFF1E2A45),
                  thickness: 1,
                  height: 1,
                ),

                Expanded(
                  child: _interestedDeals.isEmpty
                      ? _buildEmptyState(deviceWidth, deviceHeight)
                      : SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth * 0.05,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: deviceHeight * 0.025),

                              _buildSummaryCard(deviceWidth, deviceHeight),

                              SizedBox(height: deviceHeight * 0.025),

                              ...List.generate(
                                _interestedDeals.length,
                                (index) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: deviceHeight * 0.02,
                                  ),
                                  child: _buildInterestCard(
                                    _interestedDeals[index],
                                    index,
                                    deviceWidth,
                                    deviceHeight,
                                  ),
                                ),
                              ),

                              SizedBox(height: deviceHeight * 0.02),
                            ],
                          ),
                        ),
                ),
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
        vertical: deviceHeight * 0.018,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: deviceWidth * 0.06,
                ),
              ),
              SizedBox(width: deviceWidth * 0.03),
              Text(
                'My Interests',
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
    );
  }

  Widget _buildSummaryCard(double deviceWidth, double deviceHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.05,
        vertical: deviceHeight * 0.022,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A45),
        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
        border: Border.all(color: const Color(0xFF2A3A55), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SAVED INTERESTS',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: deviceWidth * 0.028,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: deviceHeight * 0.006),
              Text(
                '${_interestedDeals.length} Deals Saved',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: deviceWidth * 0.048,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'TOTAL POTENTIAL',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: deviceWidth * 0.028,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: deviceHeight * 0.006),
              Text(
                '₹1.5Cr',
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontSize: deviceWidth * 0.048,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestCard(
    Map<String, dynamic> deal,
    int index,
    double deviceWidth,
    double deviceHeight,
  ) {
    final Color statusColor = _getStatusColor(deal['status']);

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
            // Company header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: deviceWidth * 0.14,
                  height: deviceWidth * 0.14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                    color: const Color(0xFF162035),
                    border: Border.all(
                      color: const Color(0xFF2A3A55),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    deal['icon'] as IconData,
                    color: deal['iconColor'] as Color,
                    size: deviceWidth * 0.07,
                  ),
                ),

                SizedBox(width: deviceWidth * 0.04),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal['company'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceWidth * 0.048,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.006),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: deviceWidth * 0.025,
                              vertical: deviceHeight * 0.003,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.015),
                              border: Border.all(
                                color: statusColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              deal['status'],
                              style: TextStyle(
                                color: statusColor,
                                fontSize: deviceWidth * 0.028,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: deviceWidth * 0.02),
                          Text(
                            '• ${deal['category']}',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: deviceWidth * 0.032,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: deviceHeight * 0.02),

            // Stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatColumn(
                    label: 'MIN. TICKET',
                    value: deal['minTicket'],
                    valueColor: Colors.white,
                    deviceWidth: deviceWidth,
                    deviceHeight: deviceHeight,
                  ),
                ),
                Expanded(
                  child: _buildStatColumn(
                    label: 'EXP. ROI',
                    value: deal['roi'],
                    valueColor: const Color(0xFF3B82F6),
                    deviceWidth: deviceWidth,
                    deviceHeight: deviceHeight,
                  ),
                ),
                Expanded(
                  child: _buildStatColumn(
                    label: 'RISK',
                    value: deal['risk'],
                    valueColor: _getRiskColor(deal['risk']),
                    deviceWidth: deviceWidth,
                    deviceHeight: deviceHeight,
                  ),
                ),
              ],
            ),

            SizedBox(height: deviceHeight * 0.02),

            // Buttons row
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
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
                            fontSize: deviceWidth * 0.033,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: deviceWidth * 0.03),

                GestureDetector(
                  onTap: () => _removeInterest(index),
                  child: Container(
                    width: deviceWidth * 0.13,
                    height: deviceHeight * 0.055,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(deviceWidth * 0.03),
                      border: Border.all(
                        color: const Color(0xFFEF4444),
                        width: 1.5,
                      ),
                      color: const Color(0xFFEF4444).withOpacity(0.08),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: const Color(0xFFEF4444),
                        size: deviceWidth * 0.055,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required String label,
    required String value,
    required Color valueColor,
    required double deviceWidth,
    required double deviceHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: deviceWidth * 0.027,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: deviceHeight * 0.005),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: deviceWidth * 0.044,
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
            Icons.bookmark_border_rounded,
            color: const Color(0xFF2A3A55),
            size: deviceWidth * 0.2,
          ),
          SizedBox(height: deviceHeight * 0.025),
          Text(
            'No Interests Yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: deviceWidth * 0.055,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: deviceHeight * 0.01),
          Text(
            'Start exploring deals and\nmark your interests',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: deviceWidth * 0.038,
              height: 1.5,
            ),
          ),
          SizedBox(height: deviceHeight * 0.04),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.08,
                vertical: deviceHeight * 0.018,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                ),
              ),
              child: Text(
                'Browse Deals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: deviceWidth * 0.042,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}