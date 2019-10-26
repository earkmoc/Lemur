<?php

//die(print_r($_POST));

function Dekretuj($link,$dokument,$ido)
{
	$idd=$dokument['ID'];
	if	( 	mysqli_fetch_row(mysqli_query($link,$q="
				select count(*) from dokumentk where ID_D=$idd
			"))[0]>0
		)
	{
		return;
	}

	if(substr($dokument['TYP'],0,2)=='LP')
	{
		//Listy p³ac
		$idListy=mysqli_fetch_row(mysqli_query($link,$q="
			select ID from listyplac where NUMER='$dokument[NUMER]'
		"))[0];

		$pozycjeListy=mysqli_query($link,$q="
			select *
			  from listyplacp
			 where ID_D='$idListy'
		"); 
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		$kolumny=array();
		$kolumnyPozycjiListy=mysqli_query($link,$q="
			show fields from listyplacp
		"); 
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		while($kolumnaPozycjiListy=mysqli_fetch_array($kolumnyPozycjiListy))
		{
			$kolumny[]=$kolumnaPozycjiListy[0];
		}

		while($pozycjaListy=mysqli_fetch_array($pozycjeListy))
		{
			$pozycjeSchematu=mysqli_query($link,$q="
				select schematys.*
				  from schematys
			 left join schematy
					on schematy.ID=schematys.ID_D
				 where schematy.TYP='LP'
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

			while($pozycjaSchematu=mysqli_fetch_array($pozycjeSchematu))
			{
				$kwota=$pozycjaSchematu['KWOTAS'];

				foreach($kolumny as $key => $value)
				{
					$kwota=str_replace($value,$pozycjaListy[$value],$kwota);
				}

				$pozycjaSchematu['KONTOWN']=str_replace('x',$pozycjaListy['ID_P'],$pozycjaSchematu['KONTOWN']);
				$pozycjaSchematu['KONTOMA']=str_replace('x',$pozycjaListy['ID_P'],$pozycjaSchematu['KONTOMA']);

				mysqli_query($link,$q="
					insert
					  into dokumentk
					   set ID_D='$idd'
						 , KTO='$ido'
						 , CZAS=Now()
						 , PRZEDMIOT='$pozycjaSchematu[OPIS]'
						 , WINIEN=$kwota
						 , MA=0
						 , KONTOWN='$pozycjaSchematu[KONTOWN]'
						 , KONTOMA='$pozycjaSchematu[KONTOMA]'
				");
				if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			}
		}
	}
	elseif(substr($dokument['TYP'],0,3)=='STR')
	{
		//¦rodki Trwa³e
		$pozycjeListy=mysqli_query($link,$q="
			select *
			  from srodkihi
			 where left(DATA,7)=left('$dokument[doperacji]',7)
		"); 
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		$kolumny=array();
		$kolumnyPozycjiListy=mysqli_query($link,$q="
			show fields from srodkihi
		"); 
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		while($kolumnaPozycjiListy=mysqli_fetch_array($kolumnyPozycjiListy))
		{
			$kolumny[]=$kolumnaPozycjiListy[0];
		}

		while($pozycjaListy=mysqli_fetch_array($pozycjeListy))
		{
			$pozycjeSchematu=mysqli_query($link,$q="
				select schematys.*
				  from schematys
			 left join schematy
					on schematy.ID=schematys.ID_D
				 where schematy.TYP='STR'
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

			while($pozycjaSchematu=mysqli_fetch_array($pozycjeSchematu))
			{
				$kwota=$pozycjaSchematu['KWOTAS'];

				foreach($kolumny as $key => $value)
				{
					$kwota=str_replace($value,$pozycjaListy[$value],$kwota);
				}

				$pozycjaSchematu['KONTOWN']=str_replace('x',$pozycjaListy['ID_D'],$pozycjaSchematu['KONTOWN']);
				$pozycjaSchematu['KONTOMA']=str_replace('x',$pozycjaListy['ID_D'],$pozycjaSchematu['KONTOMA']);

				mysqli_query($link,$q="
					insert
					  into dokumentk
					   set ID_D='$idd'
						 , KTO='$ido'
						 , CZAS=Now()
						 , PRZEDMIOT='$pozycjaSchematu[OPIS]'
						 , WINIEN=$kwota
						 , MA=0
						 , KONTOWN='$pozycjaSchematu[KONTOWN]'
						 , KONTOMA='$pozycjaSchematu[KONTOMA]'
				");
				if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			}
		}
	}
	elseif(substr($dokument['TYP'],0,2)=='KP')
	{
		$pozycjeSchematu=mysqli_query($link,$q="
			select schematys.*
			  from schematys
		 left join schematy
				on schematy.ID=schematys.ID_D
			 where schematy.TYP='KP'
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		while($pozycjaSchematu=mysqli_fetch_array($pozycjeSchematu))
		{
			$kwota=$pozycjaSchematu['KWOTAS'];
			$dokument['WPLACONO']=(!$dokument['WPLACONO']?'0':$dokument['WPLACONO']);
			$kwota=str_replace('gotówka',str_replace(',','.',$dokument['WPLACONO']),$kwota);
			$pozycjaSchematu['KONTOWN']=str_replace('x',$dokument['NRKONT'],$pozycjaSchematu['KONTOWN']);
			$pozycjaSchematu['KONTOMA']=str_replace('x',$dokument['NRKONT'],$pozycjaSchematu['KONTOMA']);
			$pozycjaSchematu['OPIS']=str_replace('przedmiot',$dokument['PRZEDMIOT'],$pozycjaSchematu['OPIS']);
			
			mysqli_query($link,$q="
				insert
				  into dokumentk
				   set ID_D='$idd'
					 , KTO='$ido'
					 , CZAS=Now()
					 , PRZEDMIOT='$pozycjaSchematu[OPIS]'
					 , WINIEN=$kwota
					 , MA=0
					 , KONTOWN='$pozycjaSchematu[KONTOWN]'
					 , KONTOMA='$pozycjaSchematu[KONTOMA]'
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		}
	}
	else
	{
		//Rejestry VAT
		$pozycjeRejestru=mysqli_query($link,$q="
			select *
			  from dokumentr
			 where ID_D='$idd'
			   and if(1*'$idd'=-1,KTO='$ido',1)
		"); 
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		$ileRazyDekretWplaty=0;
		while($pozycjaListy=mysqli_fetch_array($pozycjeRejestru))
		{
			$pozycjeSchematu=mysqli_query($link,$q="
				select schematys.*
				  from schematys
			 left join schematy
					on schematy.ID=schematys.ID_D
				 where schematy.REJESTR='$pozycjaListy[TYP]'
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

			while($pozycjaSchematu=mysqli_fetch_array($pozycjeSchematu))
			{
				$kwota=$pozycjaSchematu['KWOTAS'];

				$kwota=str_replace('brutto',$pozycjaListy['BRUTTO'],$kwota);
				$kwota=str_replace('netto',$pozycjaListy['NETTO'],$kwota);
				$kwota=str_replace('vat',$pozycjaListy['VAT'],$kwota);

				$dokument['WPLACONO']=(($dokument['WPLACONO']&&(strtoupper(substr($dokument['SPOSZAPL'],0,1))=='G'))?$dokument['WPLACONO']:'0');
				$pozycjaListy['GOTOWKA']=str_replace(',','.',$dokument['WPLACONO']);
				$pozycjaListy['PRZELEW']='0';
				if($kwota<>str_replace('gotówka',$pozycjaListy['GOTOWKA'],$kwota))
				{
					++$ileRazyDekretWplaty;
				}
				if($ileRazyDekretWplaty>1)
				{
					$pozycjaListy['GOTOWKA']=0;
				}
				
				$kwota=str_replace('gotówka',$pozycjaListy['GOTOWKA'],$kwota);
				$kwota=str_replace('przelew',$pozycjaListy['PRZELEW'],$kwota);

				$pozycjaSchematu['KONTOWN']=str_replace('x',$dokument['NRKONT'],$pozycjaSchematu['KONTOWN']);
				$pozycjaSchematu['KONTOMA']=str_replace('x',$dokument['NRKONT'],$pozycjaSchematu['KONTOMA']);

				mysqli_query($link,$q="
					insert
					  into dokumentk
					   set ID_D='$idd'
						 , KTO='$ido'
						 , CZAS=Now()
						 , PRZEDMIOT='$pozycjaSchematu[OPIS]'
						 , WINIEN=$kwota
						 , MA=0
						 , KONTOWN='$pozycjaSchematu[KONTOWN]'
						 , KONTOMA='$pozycjaSchematu[KONTOMA]'
				");
				if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			}
		}
	}

	//usuniecie zerowych dekretow
	mysqli_query($link,$q="
		delete
		  from dokumentk
		 where ID_D='$idd'
		   and if(1*'$idd'=-1,KTO='$ido',1)
		   and WINIEN=0
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

$czas=date('Y-m-d H:i:s');

ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if($_POST['zastapic'])
{
	mysqli_query($link,$q="
		update dokumentk
	 left join dokumenty
			on dokumenty.ID=dokumentk.ID_D
			set dokumentk.ID_D=-2
		 where dokumenty.GDZIE='bufor'
		   and if('$_POST[okres]'<>'',left(dokumenty.DOPERACJI,7)='$_POST[okres]',1)
		   and if('$_POST[typ]'<>'',dokumenty.TYP='$_POST[typ]',1)
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	mysqli_query($link,$q="
		delete 
		  from dokumentk
		 where ID_D=-2
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

$dokumenty=mysqli_query($link,$q="
	select *
	  from dokumenty
	 where GDZIE='bufor'
	   and if('$_POST[okres]'<>'',left(DOPERACJI,7)='$_POST[okres]',1)
	   and if('$_POST[typ]'<>'',TYP='$_POST[typ]',1)
	 order by DOPERACJI, ID
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$wynik=0;
while($dokument=mysqli_fetch_array($dokumenty))
{
	++$wynik;
	Dekretuj($link,$dokument,$ido);
}

$title="Masowe dekretowanie dokumentów: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td width='33%'></td>";
echo "<td>";

echo "<h1>Raport masowego dekretowania:</h1>";
echo "<br>$wynik dokumentów zadekretowanych";
echo '<hr>';

echo '<div class="form-group">';
echo $czas.' czas rozpoczêcia';
echo '</div>';

echo '<div class="form-group">';
echo date('Y-m-d H:i:s').' czas zakoñczenia';
echo '</div>';

echo "</td>";
echo "<td width='33%'></td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");