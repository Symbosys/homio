import 'package:flutter/material.dart';

// ============================================================================
// 1. NOTIFICATIONS MODELS
// ============================================================================

enum NotificationChannelType {
  inApp('In-App Push', Icons.notifications_active_outlined, Color(0xFF2563EB)),
  push('Mobile Push', Icons.phone_android_rounded, Color(0xFF7C3AED)),
  whatsApp('WhatsApp Cloud', Icons.chat_outlined, Color(0xFF16A34A)),
  sms('Carrier SMS', Icons.sms_outlined, Color(0xFFD97706)),
  email('Transactional Email', Icons.mark_email_read_outlined, Color(0xFFDC2626));

  final String label;
  final IconData icon;
  final Color color;
  const NotificationChannelType(this.label, this.icon, this.color);
}

enum NotificationDeliveryStatus {
  delivered('Delivered', Color(0xFF16A34A)),
  sent('Dispatched / In-Flight', Color(0xFF2563EB)),
  pending('Queued / Scheduled', Color(0xFFD97706)),
  failed('Delivery Failed', Color(0xFFDC2626)),
  read('Read by Recipient', Color(0xFF059669));

  final String label;
  final Color color;
  const NotificationDeliveryStatus(this.label, this.color);
}

enum NotificationRecipientType {
  recordOwner('Record Owner'),
  assignedStaff('Assigned Staff'),
  reportingManager('Reporting Manager'),
  team('Entire Team'),
  department('Department'),
  customer('Customer / Client'),
  vendor('Vendor / Supplier'),
  laborContractor('Labor / Contractor'),
  specificUser('Specific Administrator');

  final String label;
  const NotificationRecipientType(this.label);
}

class AdminNotificationLog {
  final String id;
  final String recipientName;
  final String recipientRoleOrType;
  final String recipientContact; // Email / Phone / Device ID
  final String eventTitle;
  final String moduleName;
  final NotificationChannelType channel;
  final String relatedRecordType;
  final String relatedRecordId;
  final String relatedRecordTitle;
  final String messageBody;
  final String? templateCode;
  final DateTime sentAt;
  final NotificationDeliveryStatus deliveryStatus;
  final bool isRead;
  final DateTime? readAt;
  final int retryCount;
  final String triggeredBy;
  final Map<String, dynamic> metadata;
  final String? failureReason;
  final String? technicalPayload;

  const AdminNotificationLog({
    required this.id,
    required this.recipientName,
    required this.recipientRoleOrType,
    required this.recipientContact,
    required this.eventTitle,
    required this.moduleName,
    required this.channel,
    required this.relatedRecordType,
    required this.relatedRecordId,
    required this.relatedRecordTitle,
    required this.messageBody,
    this.templateCode,
    required this.sentAt,
    required this.deliveryStatus,
    this.isRead = false,
    this.readAt,
    this.retryCount = 0,
    required this.triggeredBy,
    this.metadata = const {},
    this.failureReason,
    this.technicalPayload,
  });
}

class NotificationRule {
  final String id;
  final String ruleName;
  final String eventCode;
  final String eventName;
  final String moduleName;
  final String description;
  final NotificationRecipientType recipientType;
  final String recipientTarget;
  final List<NotificationChannelType> channels;
  final String templateId;
  final String triggerCondition;
  final String scheduleOffset; // e.g. 'Immediate', '24h before meeting', '1h before meeting'
  final String priority; // 'High', 'Medium', 'Low', 'Critical'
  final bool isActive;
  final bool isSystemMandatory; // cannot be disabled by end-user preferences

  const NotificationRule({
    required this.id,
    required this.ruleName,
    required this.eventCode,
    required this.eventName,
    required this.moduleName,
    required this.description,
    required this.recipientType,
    required this.recipientTarget,
    required this.channels,
    required this.templateId,
    required this.triggerCondition,
    required this.scheduleOffset,
    this.priority = 'Medium',
    this.isActive = true,
    this.isSystemMandatory = false,
  });

  NotificationRule copyWith({
    String? id,
    String? ruleName,
    String? eventCode,
    String? eventName,
    String? moduleName,
    String? description,
    NotificationRecipientType? recipientType,
    String? recipientTarget,
    List<NotificationChannelType>? channels,
    String? templateId,
    String? triggerCondition,
    String? scheduleOffset,
    String? priority,
    bool? isActive,
    bool? isSystemMandatory,
  }) {
    return NotificationRule(
      id: id ?? this.id,
      ruleName: ruleName ?? this.ruleName,
      eventCode: eventCode ?? this.eventCode,
      eventName: eventName ?? this.eventName,
      moduleName: moduleName ?? this.moduleName,
      description: description ?? this.description,
      recipientType: recipientType ?? this.recipientType,
      recipientTarget: recipientTarget ?? this.recipientTarget,
      channels: channels ?? this.channels,
      templateId: templateId ?? this.templateId,
      triggerCondition: triggerCondition ?? this.triggerCondition,
      scheduleOffset: scheduleOffset ?? this.scheduleOffset,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      isSystemMandatory: isSystemMandatory ?? this.isSystemMandatory,
    );
  }
}

class UserNotificationPreference {
  final String category;
  final String title;
  final String description;
  final bool isMandatory; // if true, user cannot toggle off
  final Map<NotificationChannelType, bool> channelStates;

  const UserNotificationPreference({
    required this.category,
    required this.title,
    required this.description,
    this.isMandatory = false,
    required this.channelStates,
  });
}

// ============================================================================
// 2. AUTOMATIONS & WORKFLOW ENGINE MODELS
// ============================================================================

enum AutomationStatus {
  active('Active', Color(0xFF16A34A)),
  paused('Paused', Color(0xFFD97706)),
  draft('Draft', Color(0xFF64748B)),
  failed('Failed Runs Detected', Color(0xFFDC2626));

  final String label;
  final Color color;
  const AutomationStatus(this.label, this.color);
}

enum AutomationExecutionResult {
  successful('Successful', Color(0xFF16A34A)),
  partiallySuccessful('Partially Successful', Color(0xFFD97706)),
  failed('Failed', Color(0xFFDC2626)),
  skipped('Condition Not Met / Skipped', Color(0xFF64748B));

  final String label;
  final Color color;
  const AutomationExecutionResult(this.label, this.color);
}

class WorkflowCondition {
  final String field;
  final String operator; // 'equals', 'not_equals', 'contains', 'greater_than', 'is_in'
  final String value;
  final String logicalOp; // 'AND', 'OR'

  const WorkflowCondition({
    required this.field,
    required this.operator,
    required this.value,
    this.logicalOp = 'AND',
  });
}

class WorkflowAction {
  final String actionType; // 'send_whatsapp', 'send_email', 'create_task', 'assign_lead', 'update_stage', 'request_payment'
  final String target;
  final String description;
  final String? templateId;
  final String delayString; // 'Immediate', 'After 2 hours', '24h before meeting'

  const WorkflowAction({
    required this.actionType,
    required this.target,
    required this.description,
    this.templateId,
    this.delayString = 'Immediate',
  });
}

class WorkflowAutomation {
  final String id;
  final String name;
  final String module;
  final String triggerEvent;
  final String triggerDescription;
  final AutomationStatus status;
  final List<WorkflowCondition> conditions;
  final List<WorkflowAction> actions;
  final List<WorkflowAction> otherwiseActions;
  final DateTime? lastRunAt;
  final DateTime? nextRunAt;
  final int executionCount;
  final int failureCount;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkflowAutomation({
    required this.id,
    required this.name,
    required this.module,
    required this.triggerEvent,
    required this.triggerDescription,
    required this.status,
    required this.conditions,
    required this.actions,
    this.otherwiseActions = const [],
    this.lastRunAt,
    this.nextRunAt,
    this.executionCount = 0,
    this.failureCount = 0,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  WorkflowAutomation copyWith({
    String? id,
    String? name,
    String? module,
    String? triggerEvent,
    String? triggerDescription,
    AutomationStatus? status,
    List<WorkflowCondition>? conditions,
    List<WorkflowAction>? actions,
    List<WorkflowAction>? otherwiseActions,
    DateTime? lastRunAt,
    DateTime? nextRunAt,
    int? executionCount,
    int? failureCount,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkflowAutomation(
      id: id ?? this.id,
      name: name ?? this.name,
      module: module ?? this.module,
      triggerEvent: triggerEvent ?? this.triggerEvent,
      triggerDescription: triggerDescription ?? this.triggerDescription,
      status: status ?? this.status,
      conditions: conditions ?? this.conditions,
      actions: actions ?? this.actions,
      otherwiseActions: otherwiseActions ?? this.otherwiseActions,
      lastRunAt: lastRunAt ?? this.lastRunAt,
      nextRunAt: nextRunAt ?? this.nextRunAt,
      executionCount: executionCount ?? this.executionCount,
      failureCount: failureCount ?? this.failureCount,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AutomationExecutionLog {
  final String id;
  final String automationId;
  final String automationName;
  final DateTime executedAt;
  final String triggeredRecordType;
  final String triggeredRecordId;
  final String triggeredRecordTitle;
  final String triggerEvent;
  final AutomationExecutionResult result;
  final List<String> actionsExecuted;
  final String durationFormatted;
  final String? failureReason;
  final String stepTrace;

  const AutomationExecutionLog({
    required this.id,
    required this.automationId,
    required this.automationName,
    required this.executedAt,
    required this.triggeredRecordType,
    required this.triggeredRecordId,
    required this.triggeredRecordTitle,
    required this.triggerEvent,
    required this.result,
    required this.actionsExecuted,
    required this.durationFormatted,
    this.failureReason,
    required this.stepTrace,
  });
}

// ============================================================================
// 3. AUDIT LOGS & TRACEABILITY MODELS
// ============================================================================

enum AuditSeverity {
  info('Informational', Color(0xFF2563EB)),
  warning('Elevated Warning', Color(0xFFD97706)),
  critical('Critical / Sensitive', Color(0xFFDC2626));

  final String label;
  final Color color;
  const AuditSeverity(this.label, this.color);
}

enum AuditChangeType {
  create('Create Record', Icons.add_circle_outline_rounded),
  update('Update / Edit', Icons.edit_note_rounded),
  delete('Delete / Archive', Icons.delete_outline_rounded),
  permissionChange('Permission Modification', Icons.security_rounded),
  financialAction('Financial / Rate Transaction', Icons.account_balance_wallet_outlined),
  approval('Workflow Approval', Icons.fact_check_outlined),
  fileAccess('File Download / Deletion', Icons.attach_file_rounded),
  systemConfig('System Configuration Alteration', Icons.tune_rounded);

  final String label;
  final IconData icon;
  const AuditChangeType(this.label, this.icon);
}

class AuditFieldDiff {
  final String fieldName;
  final String previousValue;
  final String newValue;
  final bool isSensitiveMasked;

  const AuditFieldDiff({
    required this.fieldName,
    required this.previousValue,
    required this.newValue,
    this.isSensitiveMasked = false,
  });
}

class AuditLogEntry {
  final String id;
  final DateTime timestamp;
  final String userName;
  final String userRole;
  final String userEmail;
  final String actionTitle;
  final String moduleName;
  final String recordType;
  final String recordId;
  final String recordTitle;
  final AuditChangeType changeType;
  final String ipAddress;
  final String sessionLocation;
  final bool isSuccess;
  final AuditSeverity severity;
  final List<AuditFieldDiff> diffs;
  final String contextSummary;

  const AuditLogEntry({
    required this.id,
    required this.timestamp,
    required this.userName,
    required this.userRole,
    required this.userEmail,
    required this.actionTitle,
    required this.moduleName,
    required this.recordType,
    required this.recordId,
    required this.recordTitle,
    required this.changeType,
    required this.ipAddress,
    required this.sessionLocation,
    required this.isSuccess,
    required this.severity,
    this.diffs = const [],
    required this.contextSummary,
  });
}

// ============================================================================
// 4. BACKUP & RECOVERY MODELS
// ============================================================================

enum BackupType {
  scheduled('Automated Scheduled', Icons.schedule_rounded),
  manual('Ad-Hoc Manual Snapshot', Icons.touch_app_outlined),
  preRestore('Pre-Restore Protection', Icons.shield_outlined),
  systemRelease('System Baseline Release', Icons.verified_outlined);

  final String label;
  final IconData icon;
  const BackupType(this.label, this.icon);
}

enum BackupJobStatus {
  completed('Completed & Verified', Color(0xFF16A34A)),
  inProgress('Snapshotting & Encrypting', Color(0xFF2563EB)),
  failed('Dispatch Error', Color(0xFFDC2626)),
  expired('Retention Expired', Color(0xFF64748B));

  final String label;
  final Color color;
  const BackupJobStatus(this.label, this.color);
}

class BackupRecord {
  final String id;
  final String backupCode;
  final BackupType type;
  final DateTime startedAt;
  final DateTime completedAt;
  final String durationFormatted;
  final double sizeMb;
  final BackupJobStatus status;
  final String storageLocation; // e.g., 'AWS S3 (ap-south-1 Mumbai Vault)'
  final String encryptionStandard; // e.g. 'AES-256 GCM'
  final DateTime retentionUntil;
  final String sha256Checksum;
  final String destinationEmail;
  final String createdBy;
  final List<String> includedScopes;

  const BackupRecord({
    required this.id,
    required this.backupCode,
    required this.type,
    required this.startedAt,
    required this.completedAt,
    required this.durationFormatted,
    required this.sizeMb,
    required this.status,
    required this.storageLocation,
    this.encryptionStandard = 'AES-256 GCM Encrypted',
    required this.retentionUntil,
    required this.sha256Checksum,
    required this.destinationEmail,
    required this.createdBy,
    this.includedScopes = const ['PostgreSQL Relational DB', 'Document Metadata', 'Audit Ledgers', 'Rate Cards'],
  });
}

class BackupConfiguration {
  final bool automatedEnabled;
  final String frequency; // 'Weekly', 'Daily'
  final String scheduledDay; // 'Sunday'
  final String scheduledTime; // '02:00 AM'
  final String timezone; // 'Asia/Kolkata (IST)'
  final int retentionDays;
  final int maxRetainedCopies;
  final String primaryStorageProvider;
  final String storageBucket;
  final bool emailDeliveryEnabled;
  final String emailRecipients;
  final bool encryptionEnforced;

  const BackupConfiguration({
    this.automatedEnabled = true,
    this.frequency = 'Weekly Automated Archive',
    this.scheduledDay = 'Sunday',
    this.scheduledTime = '02:00 AM IST',
    this.timezone = 'Asia/Kolkata',
    this.retentionDays = 90,
    this.maxRetainedCopies = 12,
    this.primaryStorageProvider = 'AWS S3 Enterprise Vault',
    this.storageBucket = 's3://homio-crm-backups-secure-mumbai/',
    this.emailDeliveryEnabled = true,
    this.emailRecipients = 'superadmin@homio.in, compliance@homio.in',
    this.encryptionEnforced = true,
  });

  BackupConfiguration copyWith({
    bool? automatedEnabled,
    String? frequency,
    String? scheduledDay,
    String? scheduledTime,
    String? timezone,
    int? retentionDays,
    int? maxRetainedCopies,
    String? primaryStorageProvider,
    String? storageBucket,
    bool? emailDeliveryEnabled,
    String? emailRecipients,
    bool? encryptionEnforced,
  }) {
    return BackupConfiguration(
      automatedEnabled: automatedEnabled ?? this.automatedEnabled,
      frequency: frequency ?? this.frequency,
      scheduledDay: scheduledDay ?? this.scheduledDay,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      timezone: timezone ?? this.timezone,
      retentionDays: retentionDays ?? this.retentionDays,
      maxRetainedCopies: maxRetainedCopies ?? this.maxRetainedCopies,
      primaryStorageProvider: primaryStorageProvider ?? this.primaryStorageProvider,
      storageBucket: storageBucket ?? this.storageBucket,
      emailDeliveryEnabled: emailDeliveryEnabled ?? this.emailDeliveryEnabled,
      emailRecipients: emailRecipients ?? this.emailRecipients,
      encryptionEnforced: encryptionEnforced ?? this.encryptionEnforced,
    );
  }
}

class RestoreTestLog {
  final String id;
  final DateTime testDate;
  final String backupTestedCode;
  final bool isSuccessful;
  final String durationFormatted;
  final String validatedBy;
  final String testNotes;

  const RestoreTestLog({
    required this.id,
    required this.testDate,
    required this.backupTestedCode,
    required this.isSuccessful,
    required this.durationFormatted,
    required this.validatedBy,
    required this.testNotes,
  });
}

// ============================================================================
// 5. SYSTEM SETTINGS MODELS
// ============================================================================

class OrganizationSettings {
  final String orgName;
  final String legalName;
  final String logoUrl;
  final String businessAddress;
  final String contactEmail;
  final String supportPhone;
  final String website;
  final String gstNumber;
  final String defaultCurrency;
  final String defaultTimezone;

  const OrganizationSettings({
    required this.orgName,
    required this.legalName,
    required this.logoUrl,
    required this.businessAddress,
    required this.contactEmail,
    required this.supportPhone,
    required this.website,
    required this.gstNumber,
    required this.defaultCurrency,
    required this.defaultTimezone,
  });
}

class SecuritySettings {
  final int sessionTimeoutMinutes;
  final int maxLoginAttemptsBeforeLockout;
  final int lockoutDurationMinutes;
  final int passwordMinLength;
  final bool requireSpecialCharacters;
  final bool requireTwoFactorAuthForAdmins;
  final bool enforceIpAllowlistForFinance;

  const SecuritySettings({
    this.sessionTimeoutMinutes = 60,
    this.maxLoginAttemptsBeforeLockout = 5,
    this.lockoutDurationMinutes = 30,
    this.passwordMinLength = 10,
    this.requireSpecialCharacters = true,
    this.requireTwoFactorAuthForAdmins = true,
    this.enforceIpAllowlistForFinance = false,
  });
}

class CommercialDefaults {
  final String standardPaymentTerms;
  final int quotationValidityDays;
  final int invoiceGracePeriodDays;
  final double maxExecutiveDiscountPercent;
  final bool requireManagerApprovalAboveDiscount;

  const CommercialDefaults({
    this.standardPaymentTerms = '10% Advance Booking, 40% Woodwork Production, 40% Installation, 10% Handover',
    this.quotationValidityDays = 15,
    this.invoiceGracePeriodDays = 7,
    this.maxExecutiveDiscountPercent = 5.0,
    this.requireManagerApprovalAboveDiscount = true,
  });
}

class OperationalBusinessRules {
  final String workingDaysSummary;
  final String businessStartTime;
  final String businessEndTime;
  final String weekendHandling;
  final int defaultSlaFollowUpHours;
  final int meetingReminderHoursBefore;

  const OperationalBusinessRules({
    this.workingDaysSummary = 'Monday to Saturday (6 Days)',
    this.businessStartTime = '09:30 AM',
    this.businessEndTime = '07:00 PM',
    this.weekendHandling = 'Auto-shift task deadlines to following Monday',
    this.defaultSlaFollowUpHours = 4,
    this.meetingReminderHoursBefore = 24,
  });
}
