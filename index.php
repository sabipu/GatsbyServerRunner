<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

include("./common.php");
echo "<html><body><h1>Running gatsby update for Test <span style='font-size: 85%'> - webtstgat</span></h1>";

run_cmd_output("sudo /usr/local/bin/run_gatsby_tmp webtstgat");
?> 