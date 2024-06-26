<?hh
<<__EntryPoint>> function main(): void {
$classes = dict[
	'DirectoryIterator' => 0,
	'FilesystemIterator' => 1,
	'RecursiveDirectoryIterator' => 1,
	'GlobIterator' => 1,
];

foreach ($classes as $class => $flags) {
	echo "===$class===\n";
	$ref = new ReflectionClass($class);
	$obj = $ref->newInstance('glob://*');
	echo get_class($obj->current()) . "\n";
	if ($flags)
	{
		var_dump($obj->getFlags());
		$flags = dict[
			FilesystemIterator::CURRENT_AS_FILEINFO => 0,
			FilesystemIterator::CURRENT_AS_SELF     => 0,
			FilesystemIterator::CURRENT_AS_PATHNAME => 1,
		];
		foreach($flags as $flag => $isstring) {
			$obj->setFlags($flag);
			$obj->rewind();
			var_dump($obj->getFlags());
			if ($isstring) {
				$val = $obj->current();
				if (is_string($val)) {
					var_dump(true);
				} else {
					var_dump($val);
				}
			} else {
				echo get_class($obj->current()) . "\n";
			}
		}
	}
}
echo "===DONE===\n";
}
