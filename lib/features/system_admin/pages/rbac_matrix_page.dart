import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../models/system_admin_models.dart';
import '../models/system_admin_mock_data.dart';

class RbacMatrixPage extends StatefulWidget {
  const RbacMatrixPage({super.key});

  @override
  State<RbacMatrixPage> createState() => _RbacMatrixPageState();
}

class _RbacMatrixPageState extends State<RbacMatrixPage> {
  final List<String> _roles = [
    'Super Admin',
    'Sales Head',
    'Deal Closer',
    'Junior Telecaller',
    'Project Manager (PM)',
    '3D Artist & Renderer',
    'Site Supervisor',
    'Service Manager',
    'Accountant / Finance',
  ];

  late String _selectedRole;
  late Map<String, List<RbacPermissionRow>> _rolePermissionsMap;
  String _searchQuery = '';
  AdminModuleCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedRole = 'Junior Telecaller';

    // Clone permissions per role
    _rolePermissionsMap = {};
    for (final role in _roles) {
      _rolePermissionsMap[role] = SystemAdminMockData.rbacPermissions.map((row) {
        final isSuperAdmin = role == 'Super Admin';
        final isSalesHead = role == 'Sales Head';
        final isTelecaller = role == 'Junior Telecaller';
        final isPM = role == 'Project Manager (PM)';

        if (isSuperAdmin) {
          return row.copyWith(
            canView: true,
            canCreate: true,
            canEdit: true,
            canDelete: true,
            canExport: true,
            canApprove: true,
            isFieldIsolated: false,
            phoneMasking: FieldMaskLevel.fullAccess,
            marginVisibility: FieldMaskLevel.fullAccess,
            canOverrideCost: true,
          );
        }

        if (isTelecaller) {
          final isSales = row.category == AdminModuleCategory.sales;
          return row.copyWith(
            canView: isSales,
            canCreate: isSales,
            canEdit: isSales,
            canDelete: false,
            canExport: false,
            canApprove: false,
            isFieldIsolated: true,
            phoneMasking: FieldMaskLevel.maskedPartial,
            marginVisibility: FieldMaskLevel.hidden,
            canOverrideCost: false,
          );
        }

        if (isSalesHead) {
          final isSalesOrQuote = row.category == AdminModuleCategory.sales || row.category == AdminModuleCategory.quotation;
          return row.copyWith(
            canView: isSalesOrQuote || row.category == AdminModuleCategory.hrms,
            canCreate: isSalesOrQuote,
            canEdit: isSalesOrQuote,
            canDelete: false,
            canExport: true,
            canApprove: isSalesOrQuote,
            isFieldIsolated: false,
            phoneMasking: FieldMaskLevel.fullAccess,
            marginVisibility: FieldMaskLevel.fullAccess,
            canOverrideCost: true,
          );
        }

        if (isPM) {
          final isDesignOrExec = row.category == AdminModuleCategory.dam || row.category == AdminModuleCategory.execution;
          return row.copyWith(
            canView: true,
            canCreate: isDesignOrExec,
            canEdit: isDesignOrExec,
            canDelete: false,
            canExport: true,
            canApprove: isDesignOrExec,
            isFieldIsolated: false,
            phoneMasking: FieldMaskLevel.fullAccess,
            marginVisibility: FieldMaskLevel.maskedPartial,
            canOverrideCost: false,
          );
        }

        return row;
      }).toList();
    }
  }

  List<RbacPermissionRow> get _filteredPermissions {
    final list = _rolePermissionsMap[_selectedRole] ?? [];
    return list.where((p) {
      if (_selectedCategory != null && p.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return p.moduleName.toLowerCase().contains(q) || p.moduleCode.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }

  void _toggleAction(int index, String action) {
    setState(() {
      final list = _rolePermissionsMap[_selectedRole]!;
      final perm = list[index];
      RbacPermissionRow updated;

      switch (action) {
        case 'view':
          updated = perm.copyWith(canView: !perm.canView);
          break;
        case 'create':
          updated = perm.copyWith(canCreate: !perm.canCreate);
          break;
        case 'edit':
          updated = perm.copyWith(canEdit: !perm.canEdit);
          break;
        case 'delete':
          updated = perm.copyWith(canDelete: !perm.canDelete);
          break;
        case 'export':
          updated = perm.copyWith(canExport: !perm.canExport);
          break;
        case 'approve':
          updated = perm.copyWith(canApprove: !perm.canApprove);
          break;
        case 'fieldIsolated':
          updated = perm.copyWith(isFieldIsolated: !perm.isFieldIsolated);
          break;
        case 'costOverride':
          updated = perm.copyWith(canOverrideCost: !perm.canOverrideCost);
          break;
        default:
          return;
      }
      list[index] = updated;
    });
  }

  void _setPhoneMasking(int index, FieldMaskLevel level) {
    setState(() {
      final list = _rolePermissionsMap[_selectedRole]!;
      list[index] = list[index].copyWith(phoneMasking: level);
    });
  }

  void _setMarginVisibility(int index, FieldMaskLevel level) {
    setState(() {
      final list = _rolePermissionsMap[_selectedRole]!;
      list[index] = list[index].copyWith(marginVisibility: level);
    });
  }

  void _savePolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.security_update_good_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Granular RBAC Security Matrix published for $_selectedRole. Changes take effect across active session tokens.',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F9D58),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= Breakpoints.medium;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark, isDesktop),
            const SizedBox(height: 20),
            _buildMetricsRow(isDark, width),
            const SizedBox(height: 24),
            _buildRoleSelectorCard(isDark, isDesktop),
            const SizedBox(height: 24),
            _buildPersonaSimulatorBanner(isDark, isDesktop),
            const SizedBox(height: 24),
            _buildSearchAndFilters(isDark, isDesktop),
            const SizedBox(height: 16),
            isDesktop ? _buildPermissionsTable(isDark) : _buildPermissionsMobile(isDark),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.security_rounded, color: AppColors.gold, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  'Granular RBAC Permission Matrix',
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'PRD Module 14.1: Fine-grained CRUD, export, approve, field isolation and data-masking controls per role.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _savePolicy,
          icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
          label: const Text('Publish Policy'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.deepNavy,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsRow(bool isDark, double width) {
    final isDesktop = width >= Breakpoints.medium;
    final currentList = _rolePermissionsMap[_selectedRole] ?? [];
    final accessibleModules = currentList.where((p) => p.canView).length;
    final fieldIsolatedModules = currentList.where((p) => p.isFieldIsolated).length;
    final maskedPhoneModules = currentList.where((p) => p.phoneMasking != FieldMaskLevel.fullAccess).length;

    final cards = [
      _buildMetricCard(
        title: 'Inspected Role',
        value: _selectedRole,
        subtitle: 'Enterprise Security Profile',
        icon: Icons.badge_outlined,
        color: AppColors.gold,
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Accessible Modules',
        value: '$accessibleModules of ${currentList.length}',
        subtitle: 'Can view and open module pages',
        icon: Icons.view_quilt_rounded,
        color: const Color(0xFF3B82F6),
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Field Isolated Modules',
        value: '$fieldIsolatedModules Modules',
        subtitle: 'Restricted to My Leads / Tasks Only',
        icon: Icons.lock_outline_rounded,
        color: fieldIsolatedModules > 0 ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        isDark: isDark,
      ),
      _buildMetricCard(
        title: 'Masked Phone Numbers',
        value: '$maskedPhoneModules Modules',
        subtitle: 'Customer phone protection active',
        icon: Icons.phone_locked_rounded,
        color: const Color(0xFFF59E0B),
        isDark: isDark,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    } else {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: cards.map((c) => SizedBox(width: (width - 44) / 2, child: c)).toList(),
      );
    }
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelectorCard(bool isDark, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.manage_accounts_rounded, color: AppColors.gold, size: 20),
              const SizedBox(width: 10),
              Text(
                'Select Role to Configure Permissions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _roles.map((role) {
                final isSelected = role == _selectedRole;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    selected: isSelected,
                    showCheckmark: false,
                    avatar: Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.person_outline_rounded,
                      size: 16,
                      color: isSelected ? AppColors.deepNavy : AppColors.gold,
                    ),
                    label: Text(role),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.deepNavy : (isDark ? AppColors.pureWhite : AppColors.deepNavy),
                    ),
                    selectedColor: AppColors.gold,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? AppColors.gold : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedRole = role);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonaSimulatorBanner(bool isDark, bool isDesktop) {
    final currentList = _rolePermissionsMap[_selectedRole] ?? [];
    final salesPerm = currentList.firstWhere(
      (p) => p.moduleCode == 'MOD-SALES',
      orElse: () => currentList.first,
    );

    String simulatedPhone;
    if (salesPerm.phoneMasking == FieldMaskLevel.fullAccess) {
      simulatedPhone = '+91 98101 44210 (Full Unrestricted)';
    } else if (salesPerm.phoneMasking == FieldMaskLevel.maskedPartial) {
      simulatedPhone = '+91 98*** **210 (Masked: Click-to-Call Only)';
    } else {
      simulatedPhone = '••••••••••• (Restricted: Telecaller Privacy)';
    }

    String simulatedMargin;
    if (salesPerm.marginVisibility == FieldMaskLevel.fullAccess) {
      simulatedMargin = '24.5% Gross Margin (Visible)';
    } else if (salesPerm.marginVisibility == FieldMaskLevel.maskedPartial) {
      simulatedMargin = 'Margin Tier: Safe (Exact % Masked)';
    } else {
      simulatedMargin = '•••• (Hidden: Cost Column Blacked Out)';
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.remove_red_eye_outlined, color: AppColors.gold, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Live Persona Security Preview: "$_selectedRole"',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: salesPerm.isFieldIsolated
                      ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                      : const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  salesPerm.isFieldIsolated ? 'MY_LEADS_TASKS (ISOLATED)' : 'ORGANIZATION-WIDE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: salesPerm.isFieldIsolated ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Below is how confidential data rows render for users logged in under this security profile:',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                _buildSimItem('Sample Client Lead', 'Priya Sharma (Sobha Unit 1402)', isDark),
                _buildSimItem('Customer Phone Field', simulatedPhone, isDark, isHighlight: true),
                _buildSimItem('Internal Cost & Margin', simulatedMargin, isDark, isHighlight: true),
                _buildSimItem('Discount Override Cap', salesPerm.canOverrideCost ? 'Authorized (Up to 15%)' : 'Locked (0% - Requires Super Admin)', isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimItem(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isHighlight ? AppColors.gold : (isDark ? AppColors.pureWhite : AppColors.deepNavy),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(bool isDark, bool isDesktop) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
              ),
              decoration: InputDecoration(
                hintText: 'Search modules or permissions...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        DropdownButtonHideUnderline(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: DropdownButton<AdminModuleCategory?>(
              value: _selectedCategory,
              hint: Text(
                'All Categories',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                ),
              ),
              dropdownColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
              items: [
                DropdownMenuItem<AdminModuleCategory?>(
                  value: null,
                  child: Text(
                    'All Categories',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                ),
                ...AdminModuleCategory.values.map(
                  (cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(
                      cat.label,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                      ),
                    ),
                  ),
                ),
              ],
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsTable(bool isDark) {
    final permissions = _filteredPermissions;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'MODULE / DOMAIN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ),
                _buildHeaderCell('VIEW', isDark),
                _buildHeaderCell('CREATE', isDark),
                _buildHeaderCell('EDIT', isDark),
                _buildHeaderCell('DELETE', isDark),
                _buildHeaderCell('EXPORT', isDark),
                _buildHeaderCell('APPROVE', isDark),
                _buildHeaderCell('ISOLATED', isDark),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PHONE MASKING',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'MARGIN VISIBILITY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: permissions.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            itemBuilder: (context, index) {
              final perm = permissions[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    // Module info
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                perm.moduleName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  perm.moduleCode,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.gold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            perm.category.label,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Actions
                    _buildToggleCell(perm.canView, () => _toggleAction(index, 'view'), isDark),
                    _buildToggleCell(perm.canCreate, () => _toggleAction(index, 'create'), isDark),
                    _buildToggleCell(perm.canEdit, () => _toggleAction(index, 'edit'), isDark),
                    _buildToggleCell(perm.canDelete, () => _toggleAction(index, 'delete'), isDark, color: const Color(0xFFEF4444)),
                    _buildToggleCell(perm.canExport, () => _toggleAction(index, 'export'), isDark),
                    _buildToggleCell(perm.canApprove, () => _toggleAction(index, 'approve'), isDark, color: const Color(0xFF10B981)),
                    _buildToggleCell(perm.isFieldIsolated, () => _toggleAction(index, 'fieldIsolated'), isDark, color: const Color(0xFFEF4444)),

                    // Phone Masking Dropdown
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<FieldMaskLevel>(
                            value: perm.phoneMasking,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                            ),
                            dropdownColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
                            items: FieldMaskLevel.values.map((l) {
                              return DropdownMenuItem(
                                value: l,
                                child: Text(l.label),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) _setPhoneMasking(index, val);
                            },
                          ),
                        ),
                      ),
                    ),

                    // Margin Visibility Dropdown
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<FieldMaskLevel>(
                            value: perm.marginVisibility,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                            ),
                            dropdownColor: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
                            items: FieldMaskLevel.values.map((l) {
                              return DropdownMenuItem(
                                value: l,
                                child: Text(l.label),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) _setMarginVisibility(index, val);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, bool isDark) {
    return Expanded(
      flex: 1,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
        ),
      ),
    );
  }

  Widget _buildToggleCell(bool active, VoidCallback onTap, bool isDark, {Color color = AppColors.gold}) {
    return Expanded(
      flex: 1,
      child: Center(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: active ? color.withValues(alpha: 0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: active ? color : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: 1.5,
              ),
            ),
            child: active ? Icon(Icons.check_rounded, size: 16, color: color) : null,
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionsMobile(bool isDark) {
    final permissions = _filteredPermissions;

    return Column(
      children: permissions.asMap().entries.map((entry) {
        final index = entry.key;
        final perm = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : AppColors.pureWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      perm.moduleName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      perm.moduleCode,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                perm.category.label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                ),
              ),
              const Divider(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildMobileChip('View', perm.canView, () => _toggleAction(index, 'view'), isDark),
                  _buildMobileChip('Create', perm.canCreate, () => _toggleAction(index, 'create'), isDark),
                  _buildMobileChip('Edit', perm.canEdit, () => _toggleAction(index, 'edit'), isDark),
                  _buildMobileChip('Delete', perm.canDelete, () => _toggleAction(index, 'delete'), isDark, color: const Color(0xFFEF4444)),
                  _buildMobileChip('Export', perm.canExport, () => _toggleAction(index, 'export'), isDark),
                  _buildMobileChip('Approve', perm.canApprove, () => _toggleAction(index, 'approve'), isDark, color: const Color(0xFF10B981)),
                  _buildMobileChip('Field Isolated', perm.isFieldIsolated, () => _toggleAction(index, 'fieldIsolated'), isDark, color: const Color(0xFFEF4444)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phone Masking:',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkSubtext : AppColors.lightTextMuted,
                    ),
                  ),
                  Text(
                    perm.phoneMasking.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.pureWhite : AppColors.deepNavy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileChip(String label, bool active, VoidCallback onTap, bool isDark, {Color color = AppColors.gold}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.15) : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? color : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              size: 14,
              color: active ? color : (isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? color : (isDark ? AppColors.darkSubtext : AppColors.lightTextMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
