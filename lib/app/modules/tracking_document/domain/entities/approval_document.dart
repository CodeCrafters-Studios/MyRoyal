class ApprovalDocument {
  ApprovalDocument({
    required this.title,
    required this.body,
    required this.status,
    required this.date,
    required this.attachment,
  });

  final String title;
  final String body;
  final List status;
  final String date;
  final int attachment;
}
