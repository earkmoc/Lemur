<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 
//print_r($_GET);die;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($_GET['id_d'])
{
	$_SESSION["{$baza}DokumentyID_D"]=$_GET['id_d'];
}

if ($_GET['rejestr'])
{
	$rejestr=explode(',',$_GET['rejestr']);
	$_SESSION['rejestr']=$rejestr[0];
	$_SESSION['rejestrOkres']=$rejestr[1];
	$_SESSION['rejestrName']=$rejestr[2];
}

// ----------------------------------------------
// Parametry widoku

$id_d=$_SESSION["{$baza}DokumentyID_D"];
$rejestr=$_SESSION['rejestr'];
$rejestrName=$_SESSION['rejestrName'];
$rejestrOkres=$_SESSION['rejestrOkres'];
$polowaRoku=floor(mysqli_fetch_row(mysqli_query($link, "select count(*) from dokumenty"))[0]/2);	// limit $polowaRoku,1
$rok=mysqli_fetch_row(mysqli_query($link, "select left(DOPERACJI,4) from dokumenty order by DOPERACJI desc limit 1"))[0];

$title=($rejestr?"Rejestr $rejestr ($rejestrName) za ".($rejestrOkres?$rejestrOkres:"rok $rok"):'Rejestry ');
$title.=($kopia=($id_d<0)?"do kopii ":"");
//$title.=($id_d?"dokumentu o ID=".abs($id_d):'');

$tabela='dokumentr';

if ($rejestr)
{
	$widok='dokumenREJ';
	$mandatory=((strlen($rejestr)<3)?"($tabela.TYP like '$rejestr%')":"($tabela.TYP='$rejestr')");
	$mandatory.=($rejestrOkres?" and ($tabela.OKRES='$rejestrOkres')":'');
} else
{
	$widok=$tabela;//.(!isset($id_d)?'':'H');
	$mandatory="if('$id_d'='0',$tabela.ID_D=-1 and $tabela.KTO='$ido',$tabela.ID_D='$id_d')";
	$mandatory=(!isset($id_d)?'':$mandatory);
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";

if ($rejestr)
{
	$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Rejestry/&$params'+GetID()+'";
} else
{
	$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'";
}

$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";
$automat="automat.php?idd=$id_d&typ='+parent.$('select[name=TYP] option:selected').val()+'&data='+parent.$('input[name=DOPERACJI]').val()+'&brutto='+parent.$('input[name=WARTOSC]').val()+'";

$readonly=false;
$buttons=array();

if (!isset($id_d))
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
	//$buttons[]=array('klawisz'=>'AltT','nazwa'=>'Test','akcja'=>"test.php?$params'+GetID()+'");
} 
else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','js'=>"parent.$('input[name=NUMER]').select().focus(); parent.scrollTo(0,0);");
	$readonly=( ((mysqli_fetch_row(mysqli_query($link, "select GDZIE from dokumenty where ID=$id_d"))[0])=='ksiêgi')
				||( ($ido==0)
				  &&($id_d)
				  &&((mysqli_fetch_row(mysqli_query($link, "select KTO from dokumenty where ID=$id_d"))[0])!=$ido)
				  )
	);
}

if ($rejestr)
{
	$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$widok&strona1=15&stronan=16&tytul=$title");
} 
elseif (!$readonly)
{
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>$dopisz);
	$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>$kopia);
	$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>$usun);
	$buttons[]=array('klawisz'=>'AltA','nazwa'=>'Automat','akcja'=>$automat);
}

if (isset($id_d))
{
	$buttons[]=array('klawisz'=>'Alt1','nazwa'=>'','js'=>"
		parent.$('li').removeClass('active');
		parent.$('div.tab-pane:not(#home)').removeClass('active');
		parent.$('#liRejestryVAT').addClass('active');
		parent.$('#RejestryVAT').addClass('active');
		parent.$('#iframeRejestryVAT').focus();
	");
	$buttons[]=array('klawisz'=>'Alt2','nazwa'=>'','js'=>"
		parent.$('li').removeClass('active');
		parent.$('div.tab-pane:not(#home)').removeClass('active');
		parent.$('#liTowary').addClass('active');
		parent.$('#Towary').addClass('active');
		parent.$('#iframeTowary').focus();
	");
	$buttons[]=array('klawisz'=>'Alt3','nazwa'=>'','js'=>"
		parent.$('li').removeClass('active');
		parent.$('div.tab-pane:not(#home)').removeClass('active');
		parent.$('#liDekrety').addClass('active');
		parent.$('#Dekrety').addClass('active');
		parent.$('#iframeDekrety').focus();
	");
	$buttons[]=array('klawisz'=>'Alt4','nazwa'=>'','js'=>"
		parent.$('li').removeClass('active');
		parent.$('div.tab-pane:not(#home)').removeClass('active');
		parent.$('#liKPiR').addClass('active');
		parent.$('#KPiR').addClass('active');
		parent.$('#iframeKPiR').focus();
	");
	$buttons[]=array('klawisz'=>'Alt5','nazwa'=>'','js'=>"
		parent.$('li').removeClass('active');
		parent.$('div.tab-pane:not(#home)').removeClass('active');
		parent.$('#liEwidSprz').addClass('active');
		parent.$('#EwidSprz').addClass('active');
		parent.$('#iframeEwidSprz').focus();
	");
	$buttons[]=array('klawisz'=>'Alt6','nazwa'=>'','js'=>"
		parent.$('li').removeClass('active');
		parent.$('div.tab-pane:not(#home)').removeClass('active');
		parent.$('#liEwidPrzeb').addClass('active');
		parent.$('#EwidPrzeb').addClass('active');
		parent.$('#iframeEwidPrzeb').focus();
	");
} 
else
{
	$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
