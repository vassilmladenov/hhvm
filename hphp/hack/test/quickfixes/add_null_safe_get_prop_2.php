<?hh

class Thing {
  public int $value = 3;
}

function foo(): void {
  if (1 < 2) {
    $thing = new Thing();
  } else {
    $thing = null;
  }
  // A newline before a property access is rare.
  // We currently produce an ill-formatted quickfix in such cases because of a lie
  // about positions in typing_subtype.
  $thing
  ->
  value;
}
