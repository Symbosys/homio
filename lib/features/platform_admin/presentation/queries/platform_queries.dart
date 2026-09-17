import 'package:cached_query_flutter/cached_query_flutter.dart';
import '../../../../core/utils/query_cache_utils.dart';
import '../../../../core/utils/toast_service.dart';
import '../../data/models/platform_org_model.dart';
import '../../data/models/platform_plan_model.dart';
import '../../data/repositories/platform_organization_repository.dart';
import '../../data/repositories/platform_subscription_repository.dart';

abstract class PlatformQueryKeys {
  static const String plansList = 'platform_plans_list';
  static const String organizationsList = 'platform_organizations_list';

  static String organizationDetail(String id) => 'platform_org_detail_$id';
  static String planDetail(String id) => 'platform_plan_detail_$id';
}

class PlatformQueries {
  final PlatformSubscriptionRepository _subscriptionRepo;
  final PlatformOrganizationRepository _orgRepo;

  PlatformQueries({
    PlatformSubscriptionRepository? subscriptionRepo,
    PlatformOrganizationRepository? orgRepo,
  })  : _subscriptionRepo = subscriptionRepo ?? PlatformSubscriptionRepository(),
        _orgRepo = orgRepo ?? PlatformOrganizationRepository();

  // ==========================================
  // QUERIES
  // ==========================================

  /// Query to fetch all subscription plans
  Query<List<PlatformPlanModel>> getPlansQuery({bool includeInactive = true}) {
    final queryKey = '${PlatformQueryKeys.plansList}_$includeInactive';

    return Query<List<PlatformPlanModel>>(
      key: queryKey,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 10),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _subscriptionRepo.getAllPlans(includeInactive: includeInactive),
    );
  }

  /// Query to fetch paginated organizations list with search & status filters
  Query<PaginatedOrganizationsResponse> getOrganizationsQuery({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
  }) {
    final queryKey =
        '${PlatformQueryKeys.organizationsList}_${page}_${limit}_${search ?? ''}_${status ?? ''}';

    return Query<PaginatedOrganizationsResponse>(
      key: queryKey,
      config: QueryConfig(
        staleDuration: const Duration(seconds: 10),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _orgRepo.getOrganizations(
        page: page,
        limit: limit,
        search: search,
        status: status,
      ),
    );
  }

  /// Query single organization details
  Query<PlatformOrgModel> getOrganizationDetailQuery(String id) {
    return Query<PlatformOrgModel>(
      key: PlatformQueryKeys.organizationDetail(id),
      config: QueryConfig(
        staleDuration: const Duration(seconds: 10),
        cacheDuration: const Duration(minutes: 5),
      ),
      queryFn: () => _orgRepo.getOrganizationById(id),
    );
  }

  // ==========================================
  // CACHE INVALIDATION HELPERS
  // ==========================================

  /// Invalidate and immediately refetch all subscription plan queries
  void invalidatePlansCache() =>
      QueryCacheUtils.invalidateAndRefetch(PlatformQueryKeys.plansList);

  /// Invalidate and immediately refetch all organization queries
  void invalidateOrganizationsCache() =>
      QueryCacheUtils.invalidateAndRefetch(PlatformQueryKeys.organizationsList);

  // ==========================================
  // MUTATIONS (PLANS)
  // ==========================================

  /// Mutation: Create a new subscription plan
  Mutation<PlatformPlanModel, Map<String, dynamic>> getCreatePlanMutation({
    void Function(PlatformPlanModel plan)? onCreated,
  }) {
    return Mutation<PlatformPlanModel, Map<String, dynamic>>(
      mutationFn: (data) => _subscriptionRepo.createPlan(data),
      onSuccess: (plan, data) {
        invalidatePlansCache();
        ToastService.showSuccess('Subscription plan "${plan.name}" created successfully!');
        onCreated?.call(plan);
      },
      onError: (data, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Update existing plan
  Mutation<PlatformPlanModel, ({String id, Map<String, dynamic> data})> getUpdatePlanMutation({
    void Function(PlatformPlanModel plan)? onUpdated,
  }) {
    return Mutation<PlatformPlanModel, ({String id, Map<String, dynamic> data})>(
      mutationFn: (args) => _subscriptionRepo.updatePlan(args.id, args.data),
      onSuccess: (plan, args) {
        invalidatePlansCache();
        ToastService.showSuccess('Plan "${plan.name}" updated successfully!');
        onUpdated?.call(plan);
      },
      onError: (args, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Toggle active status of a plan
  Mutation<PlatformPlanModel, String> getTogglePlanStatusMutation({
    void Function(PlatformPlanModel plan)? onToggled,
  }) {
    return Mutation<PlatformPlanModel, String>(
      mutationFn: (planId) => _subscriptionRepo.togglePlanStatus(planId),
      onSuccess: (plan, planId) {
        invalidatePlansCache();
        final statusText = plan.isActive ? 'activated' : 'deactivated';
        ToastService.showSuccess('Plan "${plan.name}" is now $statusText.');
        onToggled?.call(plan);
      },
      onError: (planId, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  // ==========================================
  // MUTATIONS (ORGANIZATIONS)
  // ==========================================

  /// Mutation: Onboard a new organization (with optional logo)
  Mutation<Map<String, dynamic>, ({Map<String, dynamic> payload, List<int>? logoBytes, String? logoFileName})>
      getOnboardOrgMutation({
    void Function(Map<String, dynamic> res)? onOnboarded,
  }) {
    return Mutation<Map<String, dynamic>, ({Map<String, dynamic> payload, List<int>? logoBytes, String? logoFileName})>(
      mutationFn: (args) => _orgRepo.onboardOrganization(
        args.payload,
        logoBytes: args.logoBytes,
        logoFileName: args.logoFileName,
      ),
      onSuccess: (res, args) {
        invalidateOrganizationsCache();
        ToastService.showSuccess('Organization onboarded successfully!');
        onOnboarded?.call(res);
      },
      onError: (args, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Update organization details (including logo)
  Mutation<PlatformOrgModel, ({String id, Map<String, dynamic> data, List<int>? logoBytes, String? logoFileName})>
      getUpdateOrgMutation({
    void Function(PlatformOrgModel org)? onUpdated,
  }) {
    return Mutation<PlatformOrgModel, ({String id, Map<String, dynamic> data, List<int>? logoBytes, String? logoFileName})>(
      mutationFn: (args) => _orgRepo.updateOrganization(
        args.id,
        args.data,
        logoBytes: args.logoBytes,
        logoFileName: args.logoFileName,
      ),
      onSuccess: (org, args) {
        invalidateOrganizationsCache();
        ToastService.showSuccess('Organization "${org.name}" updated successfully!');
        onUpdated?.call(org);
      },
      onError: (args, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Update organization status
  Mutation<PlatformOrgModel, ({String id, String status})> getUpdateOrgStatusMutation({
    void Function(PlatformOrgModel org)? onUpdated,
  }) {
    return Mutation<PlatformOrgModel, ({String id, String status})>(
      mutationFn: (args) => _orgRepo.updateStatus(args.id, args.status),
      onSuccess: (org, args) {
        invalidateOrganizationsCache();
        ToastService.showSuccess('Organization "${org.name}" status updated to ${org.status}!');
        onUpdated?.call(org);
      },
      onError: (args, error, fallback) {
        ToastService.showError(error);
      },
    );
  }

  /// Mutation: Assign / change subscription for an organization
  Mutation<ActiveSubscriptionModel, ({String id, Map<String, dynamic> data})>
      getAssignSubscriptionMutation({
    void Function(ActiveSubscriptionModel sub)? onAssigned,
  }) {
    return Mutation<ActiveSubscriptionModel, ({String id, Map<String, dynamic> data})>(
      mutationFn: (args) => _orgRepo.assignSubscription(args.id, args.data),
      onSuccess: (sub, args) {
        invalidateOrganizationsCache();
        ToastService.showSuccess('Subscription assigned successfully!');
        onAssigned?.call(sub);
      },
      onError: (args, error, fallback) {
        ToastService.showError(error);
      },
    );
  }
}
