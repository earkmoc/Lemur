<?php

echo str_replace(array("\n","    "),array('<br>',"...."),print_r($_SERVER,true));

$url=$_SERVER['REQUEST_URI'];
echo str_replace(array("\n","    "),array('<br>',"...."),print_r(parse_url($url),true));
