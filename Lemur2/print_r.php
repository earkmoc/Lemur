<?php

session_start();
//echo "SERVER: ".str_replace(array("\n","    "),array('<br>',"...."),print_r($_SERVER,true)).'<br>';
echo "SESSION: ".str_replace(array("\n","    "),array('<br>',"...."),print_r($_SESSION,true)).'<br>';
