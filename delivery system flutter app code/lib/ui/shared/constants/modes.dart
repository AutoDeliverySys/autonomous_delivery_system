import 'package:flutter/material.dart';

const modeNo = 0;
List<List<Color>> modeColors = _modes[modeNo];
const List<List<List<Color>>> _modes = [
  [
    [Color(0xFF303d60), Color(0xFF282D46), Color(0xFF121523)],
    [Color(0xFF82B1FF), Color(0xFF448AFF), Color(0xFF2979FF)],
    [Color(0xFFFFFFFF), Color(0xFFCCCCCC), Color(0xFF999999)],
    [Color(0xFFFF0000), Color(0xFFBB0000), Color(0xFF770000)],
  ],
  [
    [Color(0xFFFFFFFF), Color(0xFFCCCCCC), Color(0xFF999999)],
    [Color(0xFF00796B), Color(0xFF00594B), Color(0xFF004647)],
    [Color(0xFF222222), Color(0xFF111111), Color(0xFF000000)],
    [Color(0xFFFF0000), Color(0xFFBB0000), Color(0xFF770000)],
  ],
  [
    [Color(0xFFFFFEEE), Color(0xFFBA9876), Color(0xFF876543)],
    [Color(0xFF4DB6AC), Color(0xFF009688), Color(0xFF00796B)],
    [Color(0xFF222222), Color(0xFF111111), Color(0xFF000000)],
    [Color(0xFFFF0000), Color(0xFFBB0000), Color(0xFF770000)],
  ]
];
