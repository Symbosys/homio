import 'dart:async';
import '../domain/dashboard_enums.dart';
import '../domain/dashboard_models.dart';

/// Repository for Task & Follow-up operations.
abstract class ITaskRepository {
  Future<List<TaskItem>> getTasks({
    String? searchQuery,
    TaskPriority? priority,
    TaskStatus? status,
    DashboardDateFilter? dateFilter,
  });

  Future<List<FollowUpItem>> getFollowUps({
    String? searchQuery,
    bool? isDone,
  });

  Future<TaskItem> createTask(TaskItem task);
  Future<TaskItem> updateTaskStatus(String taskId, TaskStatus status);
  Future<TaskItem> toggleTaskCompletion(String taskId);
  Future<TaskItem> toggleChecklistItem(String taskId, String itemId);
  Future<TaskItem> addComment(String taskId, String commentText, String authorName);
  Future<FollowUpItem> completeFollowUp(String followupId);
  Future<FollowUpItem> rescheduleFollowUp(String followupId, String newTime);
}

/// In-memory reactive task repository instance.
class TaskRepository implements ITaskRepository {
  static final TaskRepository instance = TaskRepository._internal();
  TaskRepository._internal() {
    _initializeData();
  }
  factory TaskRepository() => instance;

  final List<TaskItem> _tasks = [];
  final List<FollowUpItem> _followups = [];

  void _initializeData() {
    _tasks.addAll([
      TaskItem(
        id: 'TSK-101',
        title: 'Physical Site Inspection — Project #104',
        description: 'Verify false ceiling framing, electrical conduit drop points, and AC drain slopes.',
        clientName: 'Rahul Sharma',
        projectName: 'DLF Phase 5 Villa #104',
        priority: TaskPriority.urgent,
        status: TaskStatus.inProgress,
        dueDate: 'Today',
        dueTime: '10:30 AM',
        category: 'Field Execution',
        assignedTo: 'Vikram Malhotra',
        checklist: const [
          TaskChecklistItem(id: 'c1', title: 'Verify ceiling level with rotary laser', isDone: true),
          TaskChecklistItem(id: 'c2', title: 'Test AC drain pipe slope with water flow test', isDone: true),
          TaskChecklistItem(id: 'c3', title: 'Photograph DB box junction wiring', isDone: false),
          TaskChecklistItem(id: 'c4', title: 'Obtain client representative signature', isDone: false),
        ],
        comments: const [
          TaskComment(
            id: 'cm1',
            authorName: 'Aarav Sharma',
            authorRole: 'Site Engineer',
            text: 'False ceiling channels anchored. Waiting for laser level inspection.',
            timeAgo: '2 hours ago',
          ),
        ],
      ),
      TaskItem(
        id: 'TSK-102',
        title: 'Follow-up Client Call — Rahul Sharma',
        description: 'Discuss modular kitchen finish swatches (PU Matte vs Acrylic Gloss).',
        clientName: 'Rahul Sharma',
        projectName: 'DLF Phase 5 Villa #104',
        priority: TaskPriority.high,
        status: TaskStatus.todo,
        dueDate: 'Today',
        dueTime: '11:00 AM',
        category: 'Client Relationship',
        assignedTo: 'Vikram Malhotra',
        checklist: const [
          TaskChecklistItem(id: 'c5', title: 'Prepare Häfele hardware price comparison sheet', isDone: true),
          TaskChecklistItem(id: 'c6', title: 'Send digital finish swatch catalog via WhatsApp', isDone: false),
        ],
      ),
      TaskItem(
        id: 'TSK-103',
        title: 'Quotation Approval & Signoff',
        description: 'Review structural wood panelling surcharge with chief commercial estimator.',
        clientName: 'Pooja Verma',
        projectName: 'Sobha City Penthouse #402',
        priority: TaskPriority.high,
        status: TaskStatus.todo,
        dueDate: 'Today',
        dueTime: '02:00 PM',
        category: 'Billing & Commercials',
        assignedTo: 'Vikram Malhotra',
        checklist: const [
          TaskChecklistItem(id: 'c7', title: 'Review 8% early sign-up margin threshold', isDone: true),
          TaskChecklistItem(id: 'c8', title: 'Attach vendor quotation for Burmese Teak', isDone: false),
        ],
      ),
      TaskItem(
        id: 'TSK-104',
        title: '3D VR Render Revision Approval',
        description: 'Complete high-fidelity ray-traced render of double-height foyer and chandelier.',
        clientName: 'Vikramaditya Singhania',
        projectName: 'Magnolias Penthouse',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        dueDate: 'Today',
        dueTime: '04:30 PM',
        category: '3D CAD Design',
        assignedTo: 'Neha Saxena',
      ),
      TaskItem(
        id: 'TSK-105',
        title: 'Review MEP Drawing Layer Alignment',
        description: 'Coordinate plumbing core locations with structural architectural plans.',
        clientName: 'Capt. R. K. Singhal',
        projectName: 'The Camellias Residence',
        priority: TaskPriority.medium,
        status: TaskStatus.waiting,
        dueDate: 'Tomorrow',
        dueTime: '12:00 PM',
        category: 'Architecture & MEP',
        assignedTo: 'Vikram Malhotra',
      ),
      TaskItem(
        id: 'TSK-106',
        title: 'Procure Italian Botticino Marble Slabs',
        description: 'Select and tag 4,200 sqft of first-grade slabs at Kishangarh stockyard.',
        clientName: 'Ananya Deshmukh',
        projectName: 'Godrej Woods 3BHK',
        priority: TaskPriority.urgent,
        status: TaskStatus.completed,
        dueDate: 'Yesterday',
        dueTime: '06:00 PM',
        category: 'Procurement',
        assignedTo: 'Vikram Malhotra',
        completedAt: DateTime.now().subtract(const Duration(hours: 18)),
      ),
      TaskItem(
        id: 'TSK-107',
        title: 'Site Handover Snaglist Verification',
        description: 'Inspect paint touchups, socket plate fittings, and deep clean polish.',
        clientName: 'Deepak Chopra',
        projectName: 'Jaypee Greens Villa',
        priority: TaskPriority.low,
        status: TaskStatus.completed,
        dueDate: 'Sep 5',
        dueTime: '05:00 PM',
        category: 'Handover & Ops',
        assignedTo: 'Vikram Malhotra',
        completedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);

    _followups.addAll([
      const FollowUpItem(
        id: 'FLP-001',
        clientName: 'Rahul Sharma',
        phone: '+91 98102 44321',
        projectName: 'DLF Phase 5 Turnkey Villa',
        budgetRange: '₹35 – ₹45 Lakhs',
        lastContact: 'Yesterday 04:30 PM',
        scheduledTime: '11:00 AM Today',
        sentiment: 'hot',
        notes: 'Client reviewed 3D walkthrough. Wants to lock kitchen finishes and deposit token advance.',
      ),
      const FollowUpItem(
        id: 'FLP-002',
        clientName: 'Ananya Deshmukh',
        phone: '+91 97204 88120',
        projectName: 'Godrej Woods 3BHK Renovation',
        budgetRange: '₹18 – ₹24 Lakhs',
        lastContact: '3 days ago',
        scheduledTime: '02:30 PM Today',
        sentiment: 'warm',
        notes: 'Needs confirmation on delivery timeline for German hardware fittings.',
      ),
      const FollowUpItem(
        id: 'FLP-003',
        clientName: 'Brig. K. S. Rathore',
        phone: '+91 94140 19283',
        projectName: 'Heritage Bungalow Turnkey',
        budgetRange: '₹60 – ₹75 Lakhs',
        lastContact: '5 days ago',
        scheduledTime: '05:00 PM Today',
        sentiment: 'hot',
        notes: 'Wants contract agreement reviewed by legal advisor before signing.',
      ),
      const FollowUpItem(
        id: 'FLP-004',
        clientName: 'Sanjay Kapoor',
        phone: '+91 98991 22334',
        projectName: 'Golf Course Extension Penthouse',
        budgetRange: '₹80 – ₹1.2 Cr',
        lastContact: '1 week ago',
        scheduledTime: '10:00 AM Tomorrow',
        sentiment: 'nurturing',
        notes: 'Sent luxury residential portfolio. Follow up on site possession dates.',
      ),
      const FollowUpItem(
        id: 'FLP-005',
        clientName: 'Meera Nambiar',
        phone: '+91 98450 67890',
        projectName: 'Bespoke Lakefront Villa',
        budgetRange: '₹50 – ₹65 Lakhs',
        lastContact: 'Yesterday',
        scheduledTime: 'Completed Today',
        sentiment: 'scheduled',
        notes: 'Meeting conducted. Signed preliminary turnkey booking agreement.',
        isDone: true,
      ),
    ]);
  }

  @override
  Future<List<TaskItem>> getTasks({
    String? searchQuery,
    TaskPriority? priority,
    TaskStatus? status,
    DashboardDateFilter? dateFilter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var results = List<TaskItem>.from(_tasks);

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      results = results.where((t) =>
        t.title.toLowerCase().contains(q) ||
        t.clientName.toLowerCase().contains(q) ||
        t.projectName.toLowerCase().contains(q) ||
        t.category.toLowerCase().contains(q)
      ).toList();
    }

    if (priority != null) {
      results = results.where((t) => t.priority == priority).toList();
    }

    if (status != null) {
      results = results.where((t) => t.status == status).toList();
    }

    return results;
  }

  @override
  Future<List<FollowUpItem>> getFollowUps({
    String? searchQuery,
    bool? isDone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var results = List<FollowUpItem>.from(_followups);

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      results = results.where((f) =>
        f.clientName.toLowerCase().contains(q) ||
        f.phone.contains(q) ||
        f.projectName.toLowerCase().contains(q)
      ).toList();
    }

    if (isDone != null) {
      results = results.where((f) => f.isDone == isDone).toList();
    }

    return results;
  }

  @override
  Future<TaskItem> createTask(TaskItem task) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _tasks.insert(0, task);
    return task;
  }

  @override
  Future<TaskItem> updateTaskStatus(String taskId, TaskStatus status) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final updated = _tasks[index].copyWith(
        status: status,
        completedAt: status == TaskStatus.completed ? DateTime.now() : null,
      );
      _tasks[index] = updated;
      return updated;
    }
    throw Exception('Task $taskId not found');
  }

  @override
  Future<TaskItem> toggleTaskCompletion(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final current = _tasks[index];
      final newStatus = current.isCompleted ? TaskStatus.inProgress : TaskStatus.completed;
      final updated = current.copyWith(
        status: newStatus,
        completedAt: newStatus == TaskStatus.completed ? DateTime.now() : null,
      );
      _tasks[index] = updated;
      return updated;
    }
    throw Exception('Task $taskId not found');
  }

  @override
  Future<TaskItem> toggleChecklistItem(String taskId, String itemId) async {
    final tIdx = _tasks.indexWhere((t) => t.id == taskId);
    if (tIdx != -1) {
      final current = _tasks[tIdx];
      final updatedChecklist = current.checklist.map((item) {
        if (item.id == itemId) {
          return item.copyWith(isDone: !item.isDone);
        }
        return item;
      }).toList();
      final updated = current.copyWith(checklist: updatedChecklist);
      _tasks[tIdx] = updated;
      return updated;
    }
    throw Exception('Task $taskId not found');
  }

  @override
  Future<TaskItem> addComment(String taskId, String commentText, String authorName) async {
    final tIdx = _tasks.indexWhere((t) => t.id == taskId);
    if (tIdx != -1) {
      final current = _tasks[tIdx];
      final newComment = TaskComment(
        id: 'cm_${DateTime.now().millisecondsSinceEpoch}',
        authorName: authorName,
        authorRole: 'Team Member',
        text: commentText,
        timeAgo: 'Just now',
      );
      final updated = current.copyWith(
        comments: [...current.comments, newComment],
      );
      _tasks[tIdx] = updated;
      return updated;
    }
    throw Exception('Task $taskId not found');
  }

  @override
  Future<FollowUpItem> completeFollowUp(String followupId) async {
    final index = _followups.indexWhere((f) => f.id == followupId);
    if (index != -1) {
      final updated = _followups[index].copyWith(isDone: true);
      _followups[index] = updated;
      return updated;
    }
    throw Exception('Follow-up $followupId not found');
  }

  @override
  Future<FollowUpItem> rescheduleFollowUp(String followupId, String newTime) async {
    final index = _followups.indexWhere((f) => f.id == followupId);
    if (index != -1) {
      final updated = _followups[index].copyWith(scheduledTime: newTime, isDone: false);
      _followups[index] = updated;
      return updated;
    }
    throw Exception('Follow-up $followupId not found');
  }
}
