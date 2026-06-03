// class ContactModel {
//   final int? id;
//   final int userId;
//   final String contactName;
//   final String contactPhone;
//
//   ContactModel({
//     this.id,
//     required this.userId,
//     required this.contactName,
//     required this.contactPhone,
//   });
//
//   factory ContactModel.fromMap(Map<String, dynamic> json) {
//     return ContactModel(
//       id: json['id'],
//       userId: json['user_id'],
//       contactName: json['contact_name'],
//       contactPhone: json['contact_phone'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'user_id': userId,
//       'contact_name': contactName,
//       'contact_phone': contactPhone,
//     };
//   }
// }