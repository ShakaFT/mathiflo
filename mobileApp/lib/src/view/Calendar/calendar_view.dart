import 'package:flutter/material.dart';
import 'package:mathiflo/constants.dart';
import 'package:mathiflo/src/controller/Calendar/calendar_controller.dart';
import 'package:mathiflo/src/extensions/date_time_extension.dart';
import 'package:mathiflo/src/model/Calendar/calendar_event.dart';
import 'package:mathiflo/src/view/Calendar/event_popup.dart';
import 'package:mathiflo/src/widgets/async.dart';
import 'package:mathiflo/src/widgets/bar.dart';
import 'package:mathiflo/src/widgets/navigation_drawer.dart';
import 'package:mathiflo/src/widgets/popups.dart';
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
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _controller.loadEvents();
  }

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
                defaultBuilder: (context, day, focusedDay) =>
                    _getDay(day.midnight),
                headerTitleBuilder: (context, day) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _controller.formattedHeaderTitle(
                        day.midnight,
                        "fr_FR",
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                markerBuilder: (context, day, events) =>
                    _getMarkers(context, day, events as List<Event>),
                selectedBuilder: (context, day, focusedDay) => _getDay(
                  day.midnight,
                  selected: true,
                  today: isSameDay(day.midnight, DateTime.now()),
                ),
                todayBuilder: (context, day, focusedDay) =>
                    _getDay(day.midnight, today: true),
              ),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible:
                    false, // Hide days outside the current month
                weekendTextStyle: TextStyle(),
              ),
              daysOfWeekHeight: 25,
              eventLoader: (day) => _controller.matchEvents(day.midnight),
              firstDay: _controller.firstDate,
              focusedDay: _controller.selectedDay,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextFormatter: (date, locale) =>
                    // Add first letter to upper case
                    _controller.formattedHeaderTitle(
                  date.midnight,
                  locale,
                ),
              ),
              lastDay: _controller.lastDate,
              locale: 'fr_FR',
              onPageChanged: (focusedDay) async {
                _controller.onDaySelected(focusedDay.midnight);
                await _controller.loadEvents();
              },
              selectedDayPredicate: (day) =>
                  isSameDay(_controller.selectedDay, day.midnight),
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

  Widget _getMarkers(BuildContext context, DateTime day, List<Event> events) =>
      InkWell(
        onTap: () async => {
          if (isSameDay(_controller.selectedDay, day))
            {
              await showDialog(
                context: context,
                builder: (context) => EventPopup(
                  calendarController: _controller,
                  date: day,
                ),
              )
            },
          _controller.onDaySelected(day)
        },
        onLongPress: () async {
          await showDialog(
            context: context,
            builder: (context) => EventPopup(
              calendarController: _controller,
              date: day,
            ),
          );
          _controller.onDaySelected(day);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(1.0),
              child: ColoredBox(
                color: events[index].isMultipleDays
                    ? mainColor
                    : Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    events[index].title,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: events[index].isMultipleDays
                          ? Colors.white
                          : mainColor,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  Future<void> _loadEvents() async {
    final error = await _controller.loadEvents();
    if (error.isNotEmpty && context.mounted) {
      snackbar(context, error, error: true);
    }
  }
}
