// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library minesweeper.test;

import 'package:test/test.dart';

import 'package:minesweeper/minesweeper.dart';

void main() {
  test('informNeighbors', () {
    var field = new NoBomb();
    var bomb = new Bomb();

    Minesweeper.setAsNeighbors(field, bomb);
    bomb.informNeighbors();

    expect(field.neighboringBombs, 1);
  });

  test('integration1', () {

  });
}
