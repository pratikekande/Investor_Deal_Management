import 'package:investor_deal_managemen/domain/entities/deal_entity.dart';

class DummyDeals {
  static final List<DealEntity> list = [
    DealEntity(
      id: -1,
      title: 'Series A Funding Round',
      companyName: 'NexaHealth AI',
      industry: 'Healthcare',
      investmentRequired: '₹2,50,00,000',
      expectedRoi: 28.5,
      riskLevel: 'Medium',
      status: 'Open',
      postedByEmail: 'corporate@nexahealth.com',
      postedByName: 'Rohan Mehta',
      description:
          'NexaHealth AI is revolutionizing early disease detection using proprietary '
          'machine learning models trained on millions of anonymized patient records. '
          'Our flagship product reduces diagnostic time by 60% and has already been '
          'adopted by 12 tier-1 hospitals across India. This Series A round will fund '
          'expansion into Southeast Asia and accelerate R&D for our next-gen imaging module.',
      createdAt: '2025-04-10T09:00:00.000Z',
    ),
    DealEntity(
      id: -2,
      title: 'Green Energy Expansion Drive',
      companyName: 'SolarNova Pvt. Ltd.',
      industry: 'Energy',
      investmentRequired: '₹5,00,00,000',
      expectedRoi: 22.0,
      riskLevel: 'Low',
      status: 'Open',
      postedByEmail: 'corporate@solarnova.in',
      postedByName: 'Priya Sharma',
      description:
          'SolarNova is one of India\'s fastest-growing distributed solar energy companies, '
          'with over 400 MW of installed capacity across Rajasthan, Gujarat, and Maharashtra. '
          'This round funds the deployment of 150 MW of rooftop solar for industrial clients '
          'under long-term PPAs, ensuring predictable cash flows and low execution risk. '
          'Government subsidies under PM-KUSUM further de-risk the investment.',
      createdAt: '2025-04-18T11:30:00.000Z',
    ),
    DealEntity(
      id: -3,
      title: 'Seed Round — B2B SaaS Platform',
      companyName: 'FinStack Technologies',
      industry: 'Finance',
      investmentRequired: '₹75,00,000',
      expectedRoi: 42.0,
      riskLevel: 'High',
      status: 'Open',
      postedByEmail: 'corporate@finstack.io',
      postedByName: 'Arjun Kapoor',
      description:
          'FinStack is building an all-in-one financial operations platform for Indian SMEs — '
          'combining invoicing, GST compliance, payroll, and working capital lending in a '
          'single dashboard. With 800+ paying customers acquired in just 8 months and an '
          'MoM revenue growth of 18%, we are raising a seed round to scale our sales team '
          'and launch an embedded lending product in partnership with 3 NBFCs.',
      createdAt: '2025-05-01T08:15:00.000Z',
    ),
  ];
}