// ignore_for_file: non_constant_identifier_names

String constant = "";
bool isProduction = false;
String server_url = "https://97b7cccd3ab2.ngrok-free.app";

enum RideStatus {
  requested,
  accepted,
  inProgress,
  completed,
  cancelled,
}

extension RideStatusX on RideStatus {
  String get label => switch (this) {
        RideStatus.requested => "requested",
        RideStatus.accepted => "accepted",
        RideStatus.inProgress => "in_progress",
        RideStatus.completed => "completed",
        RideStatus.cancelled => "cancelled",
      };
  String get pretty =>
      label.replaceAll('_', ' ').replaceFirst(label[0], label[0].toUpperCase());
}
