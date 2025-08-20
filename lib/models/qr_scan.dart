class QrScan {
  late String id;
  late String qrCode;
  late String scannedAt;
  late String? attractionId;
  late String? ticketId;
  late String status;
  late Map<String, dynamic>? metadata;

  QrScan();

  QrScan.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    qrCode = json['qr_code'];
    scannedAt = json['scanned_at'];
    attractionId = json['attraction_id']?.toString();
    ticketId = json['ticket_id']?.toString();
    status = json['status'] ?? 'pending';
    metadata = json['metadata'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qr_code': qrCode,
      'scanned_at': scannedAt,
      'attraction_id': attractionId,
      'ticket_id': ticketId,
      'status': status,
      'metadata': metadata,
    };
  }
}
