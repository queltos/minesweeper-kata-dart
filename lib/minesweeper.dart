// Copyright (c) 2015, Humpty Dumpty. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// No if allowed :)

/// The minesweeper library.
library bombsweeper;

import 'dart:io';

class Minesweeper {
  static Map symbolMap = {"x": createBomb, '-': createNoBomb};

  Set<Bomb> bombs;
  List<List> playfield;

  Minesweeper.fromStdin() {
    playfield = [];
    bombs = new Set<Bomb>();

    var line = stdin.readLineSync();
    var lengths = line.split(' ');
    var lineLen = int.parse(lengths[1]);

    var charList, fieldList;

    // create a border list of dummy fields
    List<Field> prevLine = new List<Field>.generate(lineLen, (_) => new NoBomb());

    line = stdin.readLineSync();
    while(line != null) {
      charList = line.split('');
      fieldList = charList.map((char) => symbolMap[char](this)).toList();

      setNeighbors(prevLine, fieldList);

      playfield.add(fieldList);

      prevLine = line;
      line = stdin.readLineSync();
    }
  }

  setNeighbors(List<Field> prevLine, List<Field> fieldLine) {
    print('something');
//    print(prevLine.toString());
    var paddedPrevLine = [new NoBomb()].addAll(prevLine);
    var i = 0;
    var prevField = new NoBomb();
    for(Field field in fieldLine) {
      setAsNeighbors(prevField, field);
      for(var j = i; j < 3; j++) {
        setAsNeighbors(paddedPrevLine[j], field);
      }

      prevField = field;
      i++;
    }

    playfield.add(fieldLine);
  }

  setAsNeighbors(Field field1, Field field2) {
    field1.addNeighbor(field2);
    field2.addNeighbor(field1);
  }

  solve() {
    bombs.map((bomb) => bomb.informNeighbors());
  }

  print() {
    playfield.map((List<Field> line) {
      print(line.join(' ').toString());
    });
  }
}

abstract class Field {
  Set<Field> _neighbors = new Set<Field>();

  addNeighbor(Field neighbor) {
    _neighbors.add(neighbor);
  }

  incNeighboringBombs();
  toString();
}

class NoBomb extends Field {
  int _neighboringBombs = 0;

  toString() {
    return _neighboringBombs.toString();
  }

  incNeighboringBombs() {
    _neighboringBombs++;
  }
}

class Bomb extends Field {
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
  minesweeper.bombs.add(bomb);
  return bomb;
}

createNoBomb(Minesweeper minesweeper) {
  return new NoBomb();
}
