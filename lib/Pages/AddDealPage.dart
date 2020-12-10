import 'dart:developer';

import 'package:case_planner/Settings/Settings.dart';
import 'file:///D:/CasePlanner/case_planner/lib/HelperComponents/InputDateTimeField.dart';
import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/Deal.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:case_planner/WorkWithData/ClockFace.dart';
import 'package:case_planner/WorkWithData/DateTimeUtility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AddDealPage extends StatefulWidget {
  final String title = 'Планировщик дел';
  final void Function() _toTODOListPage;

  AddDealPage(this._toTODOListPage);

  @override
  _AddDealPageState createState() => _AddDealPageState();
}

class _AddDealPageState extends State<AddDealPage> {
  TextEditingController _inputDeal = TextEditingController();

  DateTime startDate;
  TimeOfDay startTime;
  DateTime endDate;
  TimeOfDay endTime;

  String errorMessage = '';

  DateTime _addDateAndTime(DateTime dt, TimeOfDay tod) {
    return DateTimeUtility
        .withoutTime(dt)
        .add(Duration(hours: tod.hour, minutes: tod.minute));
  }

  @override
  Widget build(BuildContext context) {
    if (startDate == null) {
      startDate = Settings.minimStartDay;
      startTime = DateTimeUtility.timeFromHour(Settings.startDayHour);
      endDate = Settings.minimEndDay;
      endTime = DateTimeUtility.timeFromHour(Settings.endDayHour);
    }
    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white
          ),
          padding: EdgeInsets.all(12.0),
          margin: EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                child: DateTimePicker(
                  labelText: 'Начало:',
                  selectedDate: startDate,
                  selectedTime: startTime,
                  selectDate: (value) {
                    setState(() {
                      startDate = value;
                    });
                  },
                  selectTime: (value) {
                    setState(() {
                      startTime = value;
                    });
                  },
                ),
              ),

              Container(
                child: DateTimePicker(
                  labelText: 'Конец:',
                  selectedDate: endDate,
                  selectedTime: endTime,
                  selectDate: (value) {
                    setState(() {
                      endDate = value;
                    });
                  },
                  selectTime: (value) {
                    setState(() {
                      endTime = value;
                    });
                  },
                ),
              ),

              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),

                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _inputDeal,
                    showCursor: true,
                    maxLines: 5,
                    maxLength: 200,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0
                  ),
                ),
              ),

            ],
          ),
        ),
        FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
            onPressed: () async {
              Deal deal = Deal(
                deal: _inputDeal.text,
                start: _addDateAndTime(startDate, startTime),
                end: _addDateAndTime(endDate, endTime),
                done: false,
              );

              if (!deal.validate()) {
                setState(() {
                  errorMessage =
                  'Неправильно составлена дата или описание дела';
                });
                return;
              }

              if (!AllDeals.isDealCompatible(deal)) {
                setState(() {
                  errorMessage = 'Несовместно с другими делами';
                });
                return;
              }
              await AllDeals.addDeal(deal);
              TODOList.updateList();
              ClockFace.updateDealPoints();
              _inputDeal.text = '';
              widget._toTODOListPage();
              Settings.currentPage = 0;
              errorMessage = '';
            }

        ),
      ],
    );
  }

  @override
  void dispose() {
    log('dispose AddDealPage');
    Settings.inputStartDate = startDate;
    Settings.inputEndDate = endDate;
    Settings.inputStartTime = startTime;
    Settings.inputEndTime = endTime;
    Settings.inputDeal = _inputDeal.text;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    log('init AddDealPage');
    startDate = Settings.inputStartDate;
    endDate = Settings.inputEndDate;
    startTime = Settings.inputStartTime;
    endTime = Settings.inputEndTime;
    _inputDeal.text = Settings.inputDeal;
  }
}
