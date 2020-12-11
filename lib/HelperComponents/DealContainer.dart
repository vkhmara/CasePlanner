import 'dart:developer';

import 'package:case_planner/WorkWithData/AllDeals.dart';
import 'package:case_planner/WorkWithData/DateTimeUtility.dart';
import 'package:case_planner/WorkWithData/Deal.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DealContainer extends StatefulWidget {
  final int dealPos;
  final bool isImmutable;

  DealContainer({@required this.dealPos, this.isImmutable=false});

  @override
  _DealContainerState createState() => _DealContainerState();
}

class _DealContainerState extends State<DealContainer> {
  @override
  Widget build(BuildContext context) {
    Deal deal = TODOList.at(widget.dealPos);
    if (deal.done) {
      return Container(
        margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          color: Color(0xB0EAEAEA),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    DateTimeUtility.timeAsString(deal.start) + ' — '
                        + DateTimeUtility.timeAsString(deal.end),
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                    child: Checkbox(
                      onChanged: (bool newDone) async {
                        if (widget.isImmutable) {
                          return;
                        }
                        Deal invDeal = Deal.fromDeal(deal);
                        invDeal.done = newDone;
                        await AllDeals.editDeal(deal, invDeal);
                        TODOList.editDealAt(widget.dealPos, invDeal);
                        setState(() {
                          deal.done = newDone;
                        });
                      },
                      value: deal.done,
                    )
                )
              ],
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.white,
              ),
              child: Container(
                  padding: const EdgeInsets.all(18.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    deal.deal,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Alice'
                    ),
                  )
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      margin: EdgeInsets.all(18.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        color: Color(0xF0F3F3F3),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  DateTimeUtility.timeAsString(deal.start) + ' — '
                      + DateTimeUtility.timeAsString(deal.end),
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                child: Checkbox(
                  onChanged: (bool newDone) async {
                    if (widget.isImmutable) {
                      return;
                    }
                    Deal invDeal = Deal.fromDeal(deal);
                    invDeal.done = newDone;
                    await AllDeals.editDeal(deal, invDeal);
                    TODOList.editDealAt(widget.dealPos, invDeal);
                    setState(() {
                      deal.done = newDone;
                    });
                  },
                  value: deal.done,
                )
              )
            ],
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
            ),
            child: Container(
                padding: const EdgeInsets.all(18.0),
                alignment: Alignment.topLeft,
                child: Text(
                  deal.deal,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontFamily: 'Alice'
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}
