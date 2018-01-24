<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
$bazaCurrent=$baza;
$innaBaza=$baza;

$wydruki=array();
$wydruki["rs"]="Rejestry sprzeda¿y VAT - zestawienie i szczegó³owo poszczególne rejestry";
$wydruki["rz"]="Rejestry zakupów VAT - zestawienie i szczegó³owo poszczególne rejestry";
$wydruki["lp"]="Lista p³ac";
$wydruki["wb"]="Wyci±gi bankowe";
$wydruki["ak"]="Analityka obrotów konta - raport kasowy";
$wydruki["nin"]="PK - Nale¿ny i naliczony podatek VAT";
$wydruki["zus"]="ZUS P DRA";
$wydruki["snuz"]="PK - Sk³adka na ubezpieczenie zdrowotne";
$wydruki["ww"]="PK - Wyp³ata wynagrodzenia";
$wydruki["dg"]="Dziennik g³ówny";
$wydruki["zs"]="Zestawienie syntetyczne";
$wydruki["bi"]="Bilans (Aktywa, Pasywa, Rachunek wyników) na ostatni dzieñ miesi±ca";
$wydruki["VUE"]="VAT-UE";
$wydruki["V-7"]="VAT-7";

if(count($_POST)>0)
{
	//miejsce na znaczniki wyboru wydruków
	foreach($wydruki as $key => $value)
	{
		if(!@$_POST[$key])
		{
			$_POST[$key]='';
		}
	}

	//data, okres i zaznaczenia wydruków
	foreach($_POST as $key => $value)
	{
		$value=AddSlashes($value);
		$sets="TYP='parametry'
		   , SYMBOL='Sprawozdaw'
		   , TRESC='$key'
		   , OPIS='$value'
		";
		mysqli_query($link,$q="
						  insert 
							into $bazaCurrent.slownik
							 set $sets
		 on duplicate key update $sets
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
	}

	//okres do rejestrów
	$okres=$_POST['okres'];
	mysqli_query($link,$q="
					  update $bazaCurrent.slownik
						 set OPIS='$okres'
					   where TYP='dokumentr'
	");

	//data do zestawienia
	mysqli_query($link,$q="
					  update $bazaCurrent.slownik
						 set OPIS='$_POST[data]'
					   where TYP='parametry'
					     and SYMBOL='REJ'
						 and TRESC='data'
	");

	//czas do zestawienia
	mysqli_query($link,$q="
					  update $bazaCurrent.slownik
						 set OPIS='$_POST[czas]'
					   where TYP='parametry'
					     and SYMBOL='REJ'
						 and TRESC='czas'
	");

	function Zestawienie($curl)
	{
		require($curl);
		if($strona % 2)
		{
			echo '<p class="breakhere">&nbsp;</p>';
		}
	}
				
	$nrWydruku=0;
	$buforPost=$_POST;
	foreach($buforPost as $keyWydruki => $valueWydruki)
	{
		$tabelaa='';
		$_GET=array();	//niech nie zapisuje parametrów w nie swoich zestawach
		$_POST=array();	//niech nie zapisuje parametrów w nie swoich zestawach

		switch($keyWydruki)
		{
			case 'rs':
			case 'rz':

				if(!$valueWydruki) {continue;}
				if($nrWydruku++) {echo '<p class="breakhere">&nbsp;</p>';}

				$innaBaza=$bazaCurrent;
				require('../Rejestry/Tabela/setup.php');
				$idTabeliRejestry=$idTabeli;

				$w=mysqli_query($link,$q="
					select TRESC
						 , OPIS
					  from $bazaCurrent.slownik
					 where TYP='parametry'
					   and SYMBOL='REJ'
				");
				while($r=mysqli_fetch_array($w))
				{
					$_POST[$r[0]]=StripSlashes($r[1]); 
				}

				$_GET['wydruk']='Raporta';
				$_GET['batab']=$tabela;
				$_GET['natab']=($keyWydruki=='rs'?'slownikzes':'slownikzez');

				$_POST['tytul']=($keyWydruki=='rs'?'Rejestry VAT - zestawienie sprzeda¿y':'Rejestry VAT - zestawienie zakupów');
				$_POST['naglowekN']=$_POST['tytul'];
				$_POST['osobneStrony']='';
				$_POST['tylkoSumy']='';

				$innaBaza=$bazaCurrent;
				Zestawienie('../Rejestry/Tabela/drukuj.php');

				//-----------------------------------------------------------

				//czas do zestawienia
				mysqli_query($link,$q="
								  update $bazaCurrent.slownik
									 set OPIS='$_POST[czas]'
								   where TYP='parametry'
									 and SYMBOL='REJVAT'
									 and TRESC='czas'
				");
				if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

				if($keyWydruki=='rs')
				{
					$rejestry=mysqli_query($link,$q="
						select *
						  from $bazaCurrent.slownik
						 where TYP='dokumentr'
						   and SYMBOL like 'RS%'
						   and SYMBOL not like 'RS'
					  order by LP*1, ID
					");
				}
				else
				{
					$rejestry=mysqli_query($link,$q="
						select *
						  from $bazaCurrent.slownik
						 where TYP='dokumentr'
						   and SYMBOL like 'RZ%'
						   and SYMBOL not like 'RZ'
					  order by LP*1, ID
					");
				}

				while($tenRejestr=mysqli_fetch_array($rejestry))
				{
					if($nrWydruku++)
					{
						echo '<p class="breakhere">&nbsp;</p>';
					}

					$tabelaa='';
					$_GET=array();	//niech nie zapisuje parametrów w nie swoich zestawach
					$_POST=array();	//niech nie zapisuje parametrów w nie swoich zestawach

					$innaBaza=$bazaCurrent;
					$_GET['id']=$tenRejestr['ID'];
					$_GET['idTabeli']=$idTabeliRejestry;
					require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
					
					//rejestr=RZT,2016-07,Rejestr%20zakupu%20towar%F3w
					$_GET['rejestr']="$tenRejestr[SYMBOL],$tenRejestr[OPIS],$tenRejestr[TRESC]";

					$innaBaza=$bazaCurrent;
					require('../RejestryVAT/Tabela/setup.php');

					$tableInit=true;				//wyczy¶ci dziwne "WARUNKI" i "SORTOWANIE"
					$innaBaza=$bazaCurrent;
					$_GET['idTabeli']=$idTabeli;	//musi byæ po "setup"
					require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

					$w=mysqli_query($link,$q="
						select TRESC
							 , OPIS
						  from $bazaCurrent.slownik
						 where TYP='parametry'
						   and SYMBOL='REJVAT'
					");
					while($r=mysqli_fetch_array($w))
					{
						$_POST[$r[0]]=StripSlashes($r[1]);
					}

					$_GET['wydruk']='Raporta';
					$_GET['batab']=$tabela;
					$_GET['natab']=$widok;

					$_POST['tytul']=$title;
					$_POST['naglowekN']=$title;
					$_POST['zawijanie']='';
					$_POST['borderNag']=1;
					$_POST['osobneStrony']='';
					$_POST['tylkoSumy']='';

					Zestawienie('../Rejestry/Tabela/drukuj.php');
				}

				break;

			case 'lp':

				if(!$valueWydruki) {continue;}
				if($nrWydruku++) {echo '<p class="breakhere">&nbsp;</p>';}

				$innaBaza=$bazaCurrent;
				require('../ListyPlac/Tabela/setup.php');
				$_GET['idTabeli']=$idTabeli;
				$_GET['id']=mysqli_fetch_row(mysqli_query($link, $q="select ID from $bazaCurrent.listyplac where DOTYCZY='$okres'"))[0];

				$innaBaza=$bazaCurrent;
				require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

				$innaBaza=$bazaCurrent;
				require('../ListyPlacPozycje/Tabela/setup.php');

				$w=mysqli_query($link,$q="
					select TRESC
						 , OPIS
					  from $bazaCurrent.slownik
					 where TYP='parametry'
					   and SYMBOL='LPP'
				");
				while($r=mysqli_fetch_array($w))
				{
					$_POST[$r[0]]=StripSlashes($r[1]); 
				}

				$_GET['wydruk']='Raporta';
				$_GET['batab']=$tabela;
				$_GET['natab']=$widok;

				$_POST['tytul']="Lista p³ac za $okres";
				$_POST['naglowekN']=$_POST['tytul'];
				$_POST['borderNag']='';
				$_POST['borderPol']='';
				$_POST['osobneStrony']=1;
				$_POST['tylkoSumy']='';

				$innaBaza=$bazaCurrent;
				Zestawienie('../Rejestry/Tabela/drukuj.php');

				break;
		}
	}
}
else
{
	$title="Sprawozdawczo¶æ";
	$buttons=array();
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"../Menu");
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wykonaj wydruki','akcja'=>".");
	$buttons[]=array('klawisz'=>'AltZ','nazwa'=>'Zaznacz wszystkie','js'=>"$('input').prop('checked', true)");
	$buttons[]=array('klawisz'=>'AltO','nazwa'=>'Odznacz wszystkie','js'=>"$('input').prop('checked', false)");

	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

	$w=mysqli_query($link,$q="
		select TRESC
			 , OPIS
		  from $bazaCurrent.slownik
		 where TYP='parametry'
		   and SYMBOL='Sprawozdaw'
	");
	while($r=mysqli_fetch_array($w))
	{
		$_POST[$r[0]]=StripSlashes($r[1]);
	}

	echo "<table width='100%' height='100%'>\n";
	echo "<tr>\n";
	echo "<td>\n";
?>
<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
		<div class="row">
			<div class="col-md-3 nag">
				Data wydruków
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="data" value="<?php echo (@$_POST['data']?$_POST['data']:date('Y-m-d'));?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Czas wydruków
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="czas" value="<?php echo (@$_POST['czas']?date('H:i:s'):date('H:i:s'));?>" />
			</div>
		</div>
		<div class="row">
			<div class="col-md-3 nag">
				Okres sprawozdawczy:
			</div>
			<div class="col-md-2">
				<input name='okres' value='<?php echo (@$_POST['okres']?$_POST['okres']:date('Y-m'));?>' class='form-control' />
			</div>
		</div>
<?php
	echo '<h1>Wybierz wydruki, a potem u¿yj opcji "Enter=wykonaj wydruki"</h1>'."\n";
	echo "<hr>\n";

	foreach($wydruki as $key => $value)
	{
		$checked=(@$_POST[$key]?'checked':'');
		echo "<input $checked type='checkbox' name='$key' /> $value<br>\n";
	}
?>
      </div>
   </div>
</div>
<?php
	echo "</td>\n";
	echo "</tr>\n";
	echo "</table>\n\n";

	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");

	echo '<link href="index.css" rel="stylesheet">';
	echo '<script type="text/javascript" src="index.js"> </script>';

}