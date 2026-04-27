enum WorkStatus {
  pending, // 0
  onMyWay, // 1
  onSite, // 2
  started, // 3
  postponed, // 3
  stopped, // 4
  completed, // 5
  cancelled, // 5
}

extension WorkStatusX on WorkStatus {
  int get level {
    switch (this) {
      case WorkStatus.pending:
        return 0;
      case WorkStatus.onMyWay:
        return 1;
      case WorkStatus.onSite:
        return 2;
      case WorkStatus.started:
      case WorkStatus.postponed:
        return 3;
      case WorkStatus.stopped:
        return 4;
      case WorkStatus.completed:
      case WorkStatus.cancelled:
        return 5;
    }
  }

  String get label {
    switch (this) {
      case WorkStatus.pending:
        return "Pending";
      case WorkStatus.onMyWay:
        return "On my way";
      case WorkStatus.onSite:
        return "On site";
      case WorkStatus.started:
        return "Start work";
      case WorkStatus.postponed:
        return "Postpone";
      case WorkStatus.stopped:
        return "Stop work";
      case WorkStatus.completed:
        return "Complete work";
      case WorkStatus.cancelled:
        return "Cancel job";
    }
  }
}

bool canTransition(WorkStatus current, WorkStatus next) {
  return next.level >= current.level;
}

final preStartStatuses = [
  WorkStatus.pending,
  WorkStatus.onMyWay,
  WorkStatus.onSite,
  WorkStatus.started,
  WorkStatus.postponed,
];

final postStartStatuses = [
  WorkStatus.stopped,
  WorkStatus.completed,
  WorkStatus.cancelled,
];
