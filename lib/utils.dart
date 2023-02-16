int daysInMonth(int year, month) {
  var d = DateTime(year, month + 1, 1).difference(DateTime(year, month, 1));
  return d.inDays;
}

int gestionWeeks = 40;
int daysInWeek = 7;
