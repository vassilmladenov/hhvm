//// module_a.php
<?hh
new module a {}     // package pkg1
//// module_c.php
<?hh
new module c {}     // package pkg3 (include pkg2)
//// module_b.php
<?hh
new module b.b1 {}  // package pkg2
//// module_d.php
<?hh
new module d {}     // package pkg4

//// a.php
<?hh
module a;
public function f1(): void {}

//// b.php
<?hh
module b.b1;
public function f2(): void {}

//// d.php
<?hh
module d;
public function f4(): void {}

//// c.php
<?hh

module c;
public function f3(): void {}

public function test_do_while() : void {
  do {
    if (package pkg1) {
      f1();
    } else {
      f3();
    }
  } while (package pkg1);
}

public function test_while() : void {
    while (!(package pkg1)) {
    f2(); // ok; pkg3 includes pkg2
  };

  f1(); // error; package info doesn't transfer after while statement
}
