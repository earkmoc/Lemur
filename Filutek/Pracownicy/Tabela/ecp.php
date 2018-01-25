<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$noPrint=true;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/WydrukWzor.php");

echo '<script type="text/javascript">'."\n".'var id='.($_GET['id']).';'."\n".'</script>';
echo '<script type="text/javascript" src="ecp.js"></script>';
