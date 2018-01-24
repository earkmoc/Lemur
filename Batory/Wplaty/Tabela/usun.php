<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$idd=mysqli_fetch_row(mysqli_query($link, "
select ID_D
  from $tabela 
 where ID=$id
"))[0];

mysqli_query($link, "
delete 
  from $tabela 
 where ID=$id
");
if (mysqli_error($link)) {
	die(mysqli_error($link));
}

$suma=mysqli_fetch_row(mysqli_query($link, "
select sum(KWOTA)
  from $tabela 
 where ID_D=$idd
"))[0];

?>

<script type="text/javascript">
	parent.$('input[name=WPLACONO]').val(<?php echo "'$suma'";?>);
	location="../Tabela";
</script>
