<?hh

class B<reify Ta, reify Tb> {}

class C<reify Ta, reify Tb> extends B<reify Ta, reify int> {}

$x = new C<reify string, reify bool>();

echo "-- Valid input of reified\n";
try {
  $x as B<string, bool>;
  var_dump(true);
} catch (Exception $_) {
  var_dump(false);
}
try {
  $x as B<string, int>;
  var_dump(true);
} catch (Exception $_) {
  var_dump(false);
}

echo "-- Wildcards\n";
try {
  $x as B<int, _>;
  var_dump(true);
} catch (Exception $_) {
  var_dump(false);
}
try {
  $x as B<string, _>;
  var_dump(true);
} catch (Exception $_) {
  var_dump(false);
}
try {
  $x as B<_, bool>;
  var_dump(true);
} catch (Exception $_) {
  var_dump(false);
}
try {
  $x as B<_, int>;
  var_dump(true);
} catch (Exception $_) {
  var_dump(false);
}

echo "-- Wrong number\n";
try {
  $x as B<int, bool, int>;
  var_dump(true);
} catch (Exception $_) {
  var_dump(false);
}
try {
  $x as B<_, _, _>;
  var_dump(true);
} catch (Exception $_) {
  var_dump(false);
}
try {
  $x as B<_>;
  var_dump(true);
} catch (Exception $_) {
  var_dump(false);
}
try {
  $x as B<string>;
  var_dump(true);
} catch (Exception $_) {
  var_dump(false);
}
