import 'package:flutter/cupertino.dart';

class MenuPoint extends StatelessWidget {
  final String _pointName;
  final void Function() _onTap;
  MenuPoint(this._pointName, this._onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0x20000000),
              ),
              bottom: BorderSide(
                color: Color(0x20000000),
              ),
            ),
            color: Color(0x10000000),
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(20.0),
                child: Text(
                    _pointName,
                    style: TextStyle(
                        fontSize: 20.0
                    )
                ),
              )
            ],
          ),
        ),
        onTap: _onTap
    );
  }
}