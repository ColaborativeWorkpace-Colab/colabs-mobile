enum JobBid { milestone, project }

extension JobBidExtension on JobBid {
  String get name {
    switch (this) {
      case JobBid.milestone:
        return "Divide the project into smaller segments, called milestones. You'll be paid for milestones as they are completed and approved.";
      case JobBid.project:
        return "Complete the entire project as a single unit. You'll be paid upon successful completion and approval of the entire project.";
    }
  }
}
