// Copyright (c) 2015, Humpty Dumpty. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// No if allowed :)

/// The minesweeper library.
library minesweeper;

import 'dart:io';

class Minesweeper {
  static Map symbolMap = {"x": createBomb, '-': createNoBomb};

  Set<Bomb> _bombs;
  List<List> _playfield;

  Minesweeper.fromStdin() {
    _playfield = [];
    _bombs = new Set<Bomb>();

    var line = stdin.readLineSync();
    var lengths = line.split(' ');
    var noLines = int.parse(lengths[0]);
    var lineLen = int.parse(lengths[1]);

    var charList, fieldList;

    // create a border list of dummy fields
    List<Field> prevLine = new List<Field>.generate(lineLen, (_) => new NoBomb());

    line = stdin.readLineSync();
    for(var i = 0; i < noLines; i++) {
      charList = line.split('');
      fieldList = charList.map((char) => symbolMap[char](this)).toList();

      setNeighborsForLine(prevLine, fieldList);

      _playfield.add(fieldList);

      prevLine = fieldList;
      line = stdin.readLineSync();
    }
  }

  setNeighborsForLine(List<Field> prevLine, List<Field> currentLine) {
    var paddedPrevLine = [new NoBomb()]..addAll(prevLine)..add(new NoBomb());
    var i = 0;
    var prevField = new NoBomb();
    for(Field field in currentLine) {
      setAsNeighbors(prevField, field);
      for(var j = i; j < i + 3; j++) {
        setAsNeighbors(paddedPrevLine[j], field);
      }
      prevField = field;
      i++;
    }
  }

  addBomb(Bomb bomb) => _bombs.add(bomb);

  static setAsNeighbors(Field field1, Field field2) {
    field1.addNeighbor(field2);
    field2.addNeighbor(field1);
  }

  solve() {
    for(var bomb in _bombs) {
      bomb.informNeighbors();
    }
  }

  toString() {
    var lineStr = '';
    for(var line in _playfield) {
      lineStr += line.join(' ').toString();
      lineStr += '\n';
    }

    return lineStr;
  }
}

abstract class Field {
  Set<Field> _neighbors;
  Set<Field> get neighbors => _neighbors;

  Field() {
    _neighbors = new Set<Field>();
  }

  addNeighbor(Field neighbor) {
    _neighbors.add(neighbor);
  }

  incNeighboringBombs();
  toString();
}

class NoBomb extends Field {
  int _neighboringBombs = 0;
  int get neighboringBombs => _neighboringBombs;

  NoBomb() : super();

  toString() {
    return _neighboringBombs.toString();
  }

  incNeighboringBombs() {
    _neighboringBombs++;
  }
}

class Bomb extends Field {
  Bomb() : super();

  informNeighbors() {
    for(var neighbor in _neighbors) {
      neighbor.incNeighboringBombs();
    }
  }

  incNeighboringBombs() {}

  toString() => "B";
}

createBomb(Minesweeper minesweeper) {
  var bomb = new Bomb();
  minesweeper.addBomb(bomb);
  return bomb;
}

createNoBomb(Minesweeper minesweeper) {
  return new NoBomb();
}
