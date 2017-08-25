<?php

session_start();

echo str_replace(array("\n","    "),array('<br>',"...."),print_r($_SESSION,true));
