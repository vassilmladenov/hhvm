<?php

class __call {
  function __call($x, $y) { echo "ok\n"; var_dump($x, $y); }
}

<<__EntryPoint>>
function main_call_class() {
new __call(1,2);
}
