import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Calendar/calendar_controller.dart';
import 'package:mathiflo/src/model/Calendar/calendar_event.dart';
import 'package:mathiflo/src/view/Calendar/event_popup.dart';
import 'package:mathiflo/src/widgets/async.dart';
import 'package:mathiflo/src/widgets/bar.dart';
import 'package:mathiflo/src/widgets/navigation_drawer.dart';
import 'package:state_extended/state_extended.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State createState() => _CalendarViewState();
}

class _CalendarViewState extends StateX<CalendarView> {
  _CalendarViewState() : super(CalendarController()) {
    _controller = controller! as CalendarController;
  }
  late CalendarController _controller;

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: WaitingApi(
          child: Scaffold(
            appBar: appBar("Calendrier"),
            body: TableCalendar(
              daysOfWeekStyle: const DaysOfWeekStyle(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.5),
                  ),
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) => _getDay(day),
                markerBuilder: (context, day, events) =>
                    _getMarkers(context, events as List<Event>),
                selectedBuilder: (context, day, focusedDay) => _getDay(
                  day,
                  selected: true,
                  today: isSameDay(day, DateTime.now()),
                ),
                todayBuilder: (context, day, focusedDay) =>
                    _getDay(day, today: true),
              ),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible:
                    false, // Hide days outside the current month
                weekendTextStyle: TextStyle(),
              ),
              eventLoader: (date) => _controller.matchEvents(date),
              firstDay: _controller.firstDate,
              focusedDay: DateTime.now(),
              headerStyle: HeaderStyle(
                decoration: const BoxDecoration(color: Colors.orange),
                // decoration: const BoxDecoration(color: Colors.red),
                formatButtonVisible: false,
                titleCentered: true,
                titleTextFormatter: (date, locale) =>
                    // Add first letter to upper case
                    _controller.formattedHeaderTitle(date, locale),
              ),
              lastDay: _controller.lastDate,
              locale: 'fr_FR',
              onDaySelected: (selectedDay, _) async {
                if (isSameDay(_controller.selectedDay, selectedDay)) {
                  await showDialog(
                    context: context,
                    builder: (context) => EventPopup(
                      calendarController: _controller,
                      date: selectedDay,
                    ),
                  );
                }
                _controller.onDaySelected(selectedDay);
              },
              onPageChanged: (focusedDay) {
                // Call API to log events
              },
              selectedDayPredicate: (day) =>
                  isSameDay(_controller.selectedDay, day),
              shouldFillViewport:
                  true, // The calendar takes up the entire screen
              startingDayOfWeek: StartingDayOfWeek.monday,
            ),
            drawer: const NavigationDrawerWidget(),
          ),
        ),
        onWillPop: () async => false,
      );

  Widget _getDay(DateTime day, {bool selected = false, bool today = false}) {
    final boxColor = selected ? Colors.grey.withOpacity(0.6) : null;
    final circleColor = today ? Colors.black : null;
    final textColor = selected || today ? Colors.white : Colors.black;
    return Container(
      alignment: Alignment.topCenter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            alignment: Alignment.topCenter,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMarkers(BuildContext context, List<Event> events) => Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(1.0),
            child: ColoredBox(
              color: mainColor,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  events[index].title,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _getSelectedDay(DateTime day) => Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.withOpacity(0.6),
        ),
        child: _getDayText(day, Colors.white),
      );

  Widget _getTodayDay(DateTime day) => Container(
        alignment: Alignment.topCenter,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: _getDayText(day, Colors.white),
        ),
      );

  Widget _getDayText(DateTime day, Color color) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: color,
          ),
        ),
      );
}
