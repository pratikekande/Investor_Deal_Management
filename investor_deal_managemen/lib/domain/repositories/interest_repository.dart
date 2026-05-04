import 'package:investor_deal_managemen/domain/entities/interest_entity.dart';

abstract class InterestRepository {
  Future<List<InterestEntity>> getMyInterests(String investorEmail);
  Future<void> expressInterest(InterestEntity interest);
  Future<void> removeInterest(int dealId, String investorEmail);
  Future<bool> isInterested(int dealId, String investorEmail);
}
