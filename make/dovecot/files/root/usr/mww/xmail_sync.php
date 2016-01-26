#!/usr/bin/php-cgi -q
<?php
//$XMailFile = $argv[1];
//$WriteFile = $argv[2];
//$Passwords = $argv[3];
$XMailFile = '/mod/etc/xmail/mailusers.tab';
$WriteFile = '/mod/etc/xmail/dovecotusers.tab';
$Passwords = 'md5';
//$Passwords = 'clear';

function DecryptXMailPassword($EncryptedPassword) {
 $EncryptedPasswordLength = strlen($EncryptedPassword);
 $Counter = 0;
 $DecryptedPassword = '';

 for($Counter=0;$Counter<$EncryptedPasswordLength;$Counter+=2) {
  $SubEncPass = substr($EncryptedPassword,$Counter,2);
  sscanf($SubEncPass,"%02x",$CharNum);
  $DecryptedCharacterNum = $CharNum^101;
  $DecryptedCharacter = sprintf("%c",$DecryptedCharacterNum);
  $DecryptedPassword .= $DecryptedCharacter;
 }

 return($DecryptedPassword);
}

function shadow($password) {
 $hash = '';
 for($i=0;$i<8;$i++) {
  $j = mt_rand(0,53);
  if($j<26)$hash .= chr(rand(65,90));
  else if($j<52)$hash .= chr(rand(97,122));
  else if($j<53)$hash .= '.';
  else $hash .= '/';
 }
 return crypt($password,'$1$'.$hash.'$');
}

function Help() {
 echo "
This script needs the fallowing 3 arguments in this order.
 1. location of mailusers.tab (default: /var/MailRoot/mailusers.tab)
 2. location where we shoud creat (if needed) and write out username@domain:password
 3. Password output style (currently we onlt support md5/clear text)

-- Examples --
To create a file with usernames@domain and CLEAR TEXT password type:

 ./sync.php /var/MailRoot/mailusers.tab /tmp/passwords.txt clear

To create a file with usernames@domain and MD% (shadow file style) password type:

 ./sync.php /var/MailRoot/mailusers.tab /tmp/passwords.txt md5

";
}

if (is_file($XMailFile) != true || ($Passwords != 'clear' && $Passwords != 'md5') ) {
 Help();
}

$handle = fopen($XMailFile, 'r');
if ($handle) {
 if (!$Write_handle = fopen($WriteFile, 'w')) {
  echo "Cannot open file $WriteFile for writing !\n";
  exit;
 }

 while (!feof($handle)) {
  //$line = explode("\t",str_replace('"','',trim(fgets($handle, 4096))));
  $line = array_pad(explode("\t",str_replace('"','',trim(fgets($handle, 4096)))), 2, null);
  if ($line[1]) {
   switch ($Passwords) {

    case 'md5':
    $line = $line[1].'@'.$line[0].':'.shadow(DecryptXMailPassword($line[2]))."\n";
    break;

    case 'clear':
    $line = $line[1].'@'.$line[0].':'.DecryptXMailPassword($line[2])."\n";
    break;
   }

   if (fwrite($Write_handle, $line) === FALSE) {
    echo "Cannot write to file $WriteFile!!\n";
    exit;
   }
  }
 }
 fclose($Write_handle);
 fclose($handle);
 echo "Converted $XMailFile to $WriteFile using $Passwords method!\n";
}
?>