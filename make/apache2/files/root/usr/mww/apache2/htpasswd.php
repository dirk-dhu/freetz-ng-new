#!/usr/bin/php-cgi -q
<?php
require(__DIR__ . "/../sitefunctions.php");
// APR1-MD5 encryption method (windows compatible)
function crypt_apr1_md5($plainpasswd)
{
    $tmp = NULL;
    $salt = substr(str_shuffle("abcdefghijklmnopqrstuvwxyz0123456789"), 0, 8);
    $len = strlen($plainpasswd);
    $text = $plainpasswd.'$apr1$'.$salt;
    $bin = pack("H32", md5($plainpasswd.$salt.$plainpasswd));
    for($i = $len; $i > 0; $i -= 16) { $text .= substr($bin, 0, min(16, $i)); }
    for($i = $len; $i > 0; $i >>= 1) { $text .= ($i & 1) ? chr(0) : $plainpasswd{0}; }
    $bin = pack("H32", md5($text));
    for($i = 0; $i < 1000; $i++)
    {
        $new = ($i & 1) ? $plainpasswd : $bin;
        if ($i % 3) $new .= $salt;
        if ($i % 7) $new .= $plainpasswd;
        $new .= ($i & 1) ? $bin : $plainpasswd;
        $bin = pack("H32", md5($new));
    }
    for ($i = 0; $i < 5; $i++)
    {
        $k = $i + 6;
        $j = $i + 12;
        if ($j == 16) $j = 5;
        $tmp = $bin[$i].$bin[$k].$bin[$j].$tmp;
    }
    $tmp = chr(0).chr(0).$bin[11].$tmp;
    $tmp = strtr(strrev(substr(base64_encode($tmp), 2)),
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
    "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
 
    return "$"."apr1"."$".$salt."$".$tmp;
}

function show_html_result_page($username, $password, $referer_url, $cmd_output) {
$html_output = <<<EOM
<html>
<body bgcolor="#ffffff" text="#000000">
<br>
<font face="Arial" size="+1">Success</font><br><br>
<font face="Arial" size="-1"><center>
Remember your details:-
Username: $username
Password: $password
</font></center><br><br>
<font face="Arial" size="-1"> 
<a href="$referer_url">back</a><br>
</font>
<hr>
<br><br>
<tt>$cmd_output</tt>
</body></html>
EOM;
echo $html_output;
}

try {
  global $argv;
  ob_start();
  // Dies entspricht error_reporting(E_ALL);
  $from_server = FALSE;
  if ($_SERVER["REQUEST_METHOD"] == "POST" or $_SERVER["REQUEST_METHOD"] == "GET") {
    //print "Content-type:text/html\n\n";
    $from_server = TRUE;
  }

  // Password to be used for the user
  $where = "undef";
  $username = "";
  $password = "";
  if ($argv) {
    $username = $argv[1];
    $password = $argv[2];
    $where = "cmd";
  }
  elseif ($_SERVER["REQUEST_METHOD"] == "POST") {
    if(isset($_POST['userNamePasswordData'])) {
      $daten = json_decode($_POST['userNamePasswordData'], true);
      $username = htmlspecialchars($daten['username']);
      $password = htmlspecialchars($daten['password']);
      $where = "post";
    }
    else {
      $username = htmlspecialchars($_POST['username']);
      $password = htmlspecialchars($_POST['password']);
      $where = "post";
    }

  }
  elseif ($_SERVER["REQUEST_METHOD"] == "GET") {
    $username = htmlspecialchars($_GET['username']);
    $password = htmlspecialchars($_GET['password']);
    $where = "get";
  }
  elseif(count(getenv("QUERY_STRING")) > 0) {
    parse_str(getenv("QUERY_STRING"),$_GET); 
    $username = htmlspecialchars($_GET['username']);
    $password = htmlspecialchars($_GET['password']);
    $where = "query";
  }

  if (empty($username) or empty($password)) {
    echo "username(" . $username . ") or password(" . $passsword . ") is empty, taken from " . $where .  "!\n";
    if ($from_server == FALSE) {
      print_r($argv);
      print_r($_GET);
    }
    exit;  
  }

  // Encrypt password
  $encrypted_password = crypt_apr1_md5($password);
  
  $HtPasswdFile = '/tmp/flash/apache2/.htpasswd';
  $UserPresent  = FALSE;
  $HtPasswdLine =  $username . ':' . $encrypted_password;

  // check if user already present
  $handle = fopen($HtPasswdFile, 'r');
  if ($handle) {
    do {
      $line = fgets($handle);
      if(strpos($line, $username) !== FALSE) {
	$UserPresent = TRUE;
	break;
      }
    } while (!feof($handle));
    fclose($handle);
  }

  $ret = FALSE;
  if ($UserPresent === TRUE) {
    // exchange password for user
    $file_contents = file_get_contents($HtPasswdFile);
    $file_contents = preg_replace('/^' . $username . ':(.*)\n$/',$HtPasswdLine . "\n",$file_contents);
    $ret = file_put_contents($HtPasswdFile,$file_contents);
  }
  else {
    // Print line to be added to .htpasswd file
    $file_contents = file_get_contents($HtPasswdFile);
    #print($file_contents);
    $ret = file_put_contents($HtPasswdFile,$file_contents . $HtPasswdLine . "\n");
  }
  if ($ret !== FALSE) {
    system("modsave flash");
    if ($from_server === TRUE) {
      $output_content = ob_get_contents();
      ob_end_clean();
      if (isset($_SERVER['HTTP_REFERER'])) {
         $http_referer = $_SERVER['HTTP_REFERER'];
      } else {
         $http_referer = '/cgi-bin/conf/apache2';
      }
      movePageAfterTimeout($http_referer, 7);
      show_html_result_page($username, $password, $http_referer, $output_content);
    } else {
      print "Username: " . $username . "\n" . "Password: " . $password . "\nentered successfully\n";
    }
  } else {
      $output_content = ob_get_contents();
      ob_end_clean();
      echo $output_content;
  }
} catch(Exception $e) {
  echo 'Exception: ', $e->getMessage(),"\n";
}
?>