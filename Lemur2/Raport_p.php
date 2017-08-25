dataw.innerHTML="<?php echo (@$_POST['data']?$_POST['data']:date('Y.m.d'));?>";
czasw.innerHTML="<?php echo (@$_POST['czas']?$_POST['czas']:date('G.i.s'));?>";
onona.innerHTML="Wykona³<?php
$x=strtoupper(trim($_SESSION['osoba_upr']));
$dane=explode(' ',$x);
if (substr($dane[0],-1,1)=='A' || substr($dane[1],-1,1)=='A') {echo 'a';};
echo ":&nbsp;";
?>";
wykonal.innerHTML="<?php echo $_SESSION['osoba_upr'];?>";
