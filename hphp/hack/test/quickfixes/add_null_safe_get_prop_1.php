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
  $thing->value;
}
