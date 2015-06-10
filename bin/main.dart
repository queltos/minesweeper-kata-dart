// Copyright (c) 2015, Humpty Dumpty. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// No if allowed :)

import 'package:minesweeper/minesweeper.dart';

main(List<String> arguments) {
  var minesweeper = new Minesweeper.fromStdin();
  minesweeper.solve();
  print(minesweeper.toString());
}
