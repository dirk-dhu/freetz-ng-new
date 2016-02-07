<?php
//#!/usr/bin/php-cgi -q
require(__DIR__ . "/../sitefunctions.php");
 
/* Move page with 401 http status code*/
header('WWW-Authenticate: Basic realm="Login needed."');
quitPageWithError(401);
#movePage(401,"/logout/loggedout.html");
?>