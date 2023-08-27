class Booking {
  Booking(
      {required this.from,
        required this.to,
        this.status = '',
        this.eventName = '',
        this.tradieName = '',
        this.consumerName = '',
        this.description = '',
        this.key='',
        this.consumerId='',
        this.tradieId='',
        this.quote=0,
        this.rating=0,
        this.comment=''});

  final String tradieName;
  final String consumerName;
  final String eventName;
  DateTime from;
  DateTime to;
  String status;
  String description;
  String key;
  String consumerId;
  String tradieId;
  num quote;
  num rating;
  String comment;
}