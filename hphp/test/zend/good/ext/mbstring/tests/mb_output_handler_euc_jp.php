<?hh
<<__EntryPoint>>
function main_entry(): void {
  // TODO: Do real test

  // EUC-JP
  $euc_jp = "\xa5\xc6\xa5\xb9\xa5\xc8\xcd\xd1\xc6\xfc\xcb\xdc\xb8\xec\xca\xb8\xbb\xfa\xce\xf3\xa1\xa3\xa4\xb3\xa4\xce\xa5\xe2\xa5\xb8\xa5\xe5\xa1\xbc\xa5\xeb\xa4\xcfPHP\xa4\xcb\xa5\xde\xa5\xeb\xa5\xc1\xa5\xd0\xa5\xa4\xa5\xc8\xb4\xd8\xbf\xf4\xa4\xf2\xc4\xf3\xb6\xa1\xa4\xb7\xa4\xde\xa4\xb9\xa1\xa3";
  mb_http_output('EUC-JP') || print("mb_http_output() failed\n");
  ob_start('mb_output_handler');
  echo $euc_jp;
  $output = ob_get_clean();

  var_dump( $output );
}
