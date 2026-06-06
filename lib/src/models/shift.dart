class Shift {
  int? id;
  int? dayInMonth;
  String? location;
  String? date;
  String? shiftTime;
  String? type;
  bool? accept;

  Shift(
      {this.id,
      this.dayInMonth,
      this.location,
      this.date,
      this.shiftTime,
      this.type,
      this.accept});

  Shift.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayInMonth = json['day_in_month'];
    location = json['location'];
    date = json['date'];
    shiftTime = json['shift_time'];
    type = json['type'];
    accept = json['accept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['day_in_month'] = dayInMonth;
    data['location'] = location;
    data['date'] = date;
    data['shift_time'] = shiftTime;
    data['type'] = type;
    data['accept'] = accept;
    return data;
  }
}
