import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

/// Neon Light Clock - digital clock

class NeonLightsClock extends StatefulWidget {
  const NeonLightsClock(this.model);

  final ClockModel model;

  @override
  _NeonLightsClockState createState() => _NeonLightsClockState();
}

class _NeonLightsClockState extends State<NeonLightsClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(NeonLightsClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        const Duration(seconds: 1) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final String monthString = DateFormat('MMM').format(_dateTime);
    final String dayString = DateFormat('dd').format(_dateTime);

    final String hourString =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final String minuteString = DateFormat('mm').format(_dateTime);

    final int hour = _dateTime.hour;
    final int second = _dateTime.second;
    final int weekDay = _dateTime.weekday;

    final double digitFontSize = MediaQuery.of(context).size.width / 4;

    final String temperature = widget.model.temperatureString;
    final String condition = widget.model.weatherString;

    final TextStyle bigDigitOnStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Beon',
      fontSize: digitFontSize,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 0,
          color: Colors.black38,
          offset: const Offset(10, 10),
        ),
        Shadow(
          blurRadius: 50,
          color: Colors.white,
          offset: const Offset(0, 0),
        ),
        Shadow(
          blurRadius: 30,
          color: Colors.yellow,
          offset: const Offset(0, 0),
        ),
      ],
    );

    final TextStyle bigDigitOffStyle = TextStyle(
      color: Colors.black54,
      fontFamily: 'Beon',
      fontSize: digitFontSize,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 0,
          color: Colors.black,
          offset: const Offset(0, 0),
        ),
        Shadow(
          blurRadius: 0,
          color: Colors.black38,
          offset: const Offset(10, 10),
        ),
        Shadow(
          blurRadius: 30,
          color: Colors.black,
          offset: const Offset(10, 0),
        ),
      ],
    );

    final TextStyle amPmOnStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Beon',
      fontSize: MediaQuery.of(context).size.width / 15,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 0,
          color: Colors.black38,
          offset: const Offset(4, 4),
        ),
        Shadow(
          blurRadius: 30,
          color: Colors.white,
          offset: const Offset(0, 0),
        ),
        Shadow(
          blurRadius: 20,
          color: Colors.blue,
          offset: const Offset(0, 0),
        ),
      ],
    );

    final TextStyle amPmOffStyle = TextStyle(
      color: Colors.white24,
      fontFamily: 'Beon',
      fontSize: MediaQuery.of(context).size.width / 15,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 0,
          color: Colors.black38,
          offset: const Offset(4, 4),
        ),
        Shadow(
          blurRadius: 30,
          color: Colors.black38,
          offset: const Offset(0, 0),
        ),
      ],
    );

    TextStyle amStyle = amPmOffStyle;
    TextStyle pmStyle = amPmOffStyle;

    if (!widget.model.is24HourFormat) {
      if (hour >= 12) {
        pmStyle = amPmOnStyle;
      } else {
        amStyle = amPmOnStyle;
      }
    }

    final TextStyle smallFontStyle = TextStyle(
        color: Colors.white,
        fontFamily: 'Beon',
        fontSize: MediaQuery.of(context).size.width / 25,
        shadows: <Shadow>[
          Shadow(
            blurRadius: 0,
            color: Colors.black54,
            offset: const Offset(4, 4),
          ),
          Shadow(
            blurRadius: 20,
            color: Colors.white,
            offset: const Offset(0, 0),
          ),
          Shadow(
            blurRadius: 10,
            color: Colors.lightBlue,
            offset: const Offset(0, 0),
          ),
          Shadow(
            blurRadius: 8,
            color: Colors.blue,
            offset: const Offset(0, 0),
          ),
        ]);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        image: const DecorationImage(
          image: AssetImage('assets/brick_wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(),
                      ),
                      Flexible(
                        flex: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextWidget(
                                '$temperature - $condition', smallFontStyle),
                            TextWidget(
                                '$dayString $monthString', smallFontStyle),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BigDigitWidget('${hourString[0]}', bigDigitOnStyle),
                    BigDigitWidget('${hourString[1]}', bigDigitOnStyle),
                    BigDigitWidget(
                      ':',
                      ((second % 2) == 0) ? bigDigitOnStyle : bigDigitOffStyle,
                    ),
                    BigDigitWidget('${minuteString[0]}', bigDigitOnStyle),
                    BigDigitWidget('${minuteString[1]}', bigDigitOnStyle),
                    ComponentWidget(amStyle, pmStyle),
                  ],
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DayWidget(1, weekDay),
                      DayWidget(2, weekDay),
                      DayWidget(3, weekDay),
                      DayWidget(4, weekDay),
                      DayWidget(5, weekDay),
                      DayWidget(6, weekDay),
                      DayWidget(7, weekDay),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  TextWidget(this.text, this.textStyle);

  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '$text',
        style: textStyle,
      ),
    );
  }
}

class BigDigitWidget extends StatelessWidget {
  BigDigitWidget(this.text, this.textStyle);

  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final double digitWidth = MediaQuery.of(context).size.width / 8;

    return Container(
      width: (text == ':') ? null : digitWidth,
      child: Text(
        '$text',
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class DayWidget extends StatelessWidget {
  DayWidget(this.day, this.currentWeekDay);

  final int day;
  final int currentWeekDay;

  @override
  Widget build(BuildContext context) {
    final TextStyle onStyle = TextStyle(
        color: Colors.white,
        fontFamily: 'Beon',
        fontSize: MediaQuery.of(context).size.width / 25,
        shadows: <Shadow>[
          Shadow(
            blurRadius: 0,
            color: Colors.black38,
            offset: const Offset(3, 3),
          ),
          Shadow(
            blurRadius: 20,
            color: Colors.white,
            offset: const Offset(0, 0),
          ),
          Shadow(
            blurRadius: 10,
            color: Colors.lightBlue,
            offset: const Offset(0, 0),
          ),
          Shadow(
            blurRadius: 8,
            color: Colors.blue,
            offset: const Offset(0, 0),
          ),
        ]);

    final TextStyle offStyle = TextStyle(
        color: Colors.white24,
        fontFamily: 'Beon',
        fontSize: MediaQuery.of(context).size.width / 25,
        shadows: <Shadow>[
          Shadow(
            blurRadius: 0,
            color: Colors.black38,
            offset: const Offset(3, 3),
          ),
        ]);

    final List<String> weekDays = <String>[
      'MON',
      'TUES',
      'WED',
      'THU',
      'FRI',
      'SAT',
      'SUN',
    ];

    return Container(
      child: Text(
        weekDays[day - 1],
        style: (currentWeekDay == day) ? onStyle : offStyle,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 100,
      ),
    );
  }
}

class ComponentWidget extends StatelessWidget {
  ComponentWidget(this.amStyle, this.pmStyle);

  final TextStyle amStyle;
  final TextStyle pmStyle;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 7;

    return Container(
      width: width,
      child: Column(
        children: <Widget>[
          AmPmWidget('AM', amStyle),
          AmPmWidget('PM', pmStyle),
        ],
      ),
    );
  }
}

class AmPmWidget extends StatelessWidget {
  AmPmWidget(this.text, this.textStyle);

  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle,
      textAlign: TextAlign.right,
    );
  }
}
