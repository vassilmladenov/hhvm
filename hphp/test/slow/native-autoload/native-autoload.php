<?hh // strict
// Copyright 2004-present Facebook. All Rights Reserved.

<<__EntryPoint>>
function main_native_autoload(): void {
  test_fn(new TestClass());

  $is_native = HH\autoload_is_native() ? 'true' : 'false';
  print "Native Autoload: $is_native\n";
}
