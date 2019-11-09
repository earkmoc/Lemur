var $cegla="rgb(255, 102, 0)";
var $biezacy="rgb(255, 204, 102)";

$(document).ready(function() {
	$('a').on( "click", function(){
		$text=$(this).text();
		$params="option="+$(this).attr('id');
		$(this).load("save.php",$params,function(){
			$(this).text($text);
		});
		return true;
	});
	Menu(menu);
	SubMenu(option);
});

function Menu($litera)
{
	$("th a").parent().css("background-color","");
	$("#"+$litera).focus().parent().css("background-color",$cegla);
	SubMenu("a");
}

function SubMenu($litera)
{
	//wszystkim cells, które mają kolor $biezacy, zgaś kolor
	$("td").filter(function(){
		return ($(this).css("background-color")==$biezacy);
	}).css("background-color","");
	
	//znajdź komórkę nagłówkową (th), która ma kolor $cegla i dla tego menu (np.: 1) zaznacz opcję $litera (np.: 1a), a komórce nadal kolor $biezacy
	$("#"
	+$("th").filter(function(){
		return ($(this).css("background-color")==$cegla);
	}).text()[0]+$litera).focus().parent().css("background-color",$biezacy);
}

function Prev()
{
	if($('a:focus').closest('tr').prev('tr').find('td a').length>0)
	{
		$('td').css("background-color","");
		$('td a:focus').parent().css("background-color","").closest('tr').prev('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
	else
	{
		if($('a:focus').closest('div.table-responsive').prev('div.table-responsive').length>0)
		{
			$("th a").parent().css("background-color","");
			$('a:focus').parent().css("background-color","").closest('div.table-responsive').prev('div').find('th a').focus().parent().css("background-color",$cegla);
			$('a:focus').closest('table tbody').find('tr td a').last().focus().parent().css("background-color",$biezacy);
		}
		else
		{
			if($('a:focus').closest('div.col-md-4').prev('div.col-md-4').find('div.table-responsive table tr th a').length>0)
			{
				$("th a").parent().css("background-color","");
				$('a:focus').parent().css("background-color","").closest('div.col-md-4').prev('div.col-md-4').find('div.table-responsive table tr th a').last().focus().parent().css("background-color",$cegla);
				$('a:focus').closest('table tbody').find('tr td a').last().focus().parent().css("background-color",$biezacy);
			}
		}
	}
}

function Next()
{
	if($('a:focus').closest('tr').next('tr').find('td a').length>0)
	{
		$('td').css("background-color","");
		$('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
	else
	{
		if($('a:focus').closest('div.table-responsive').next('div').find('th a').length>0)
		{
			$("th a").parent().css("background-color","");
			$('a:focus').parent().css("background-color","").closest('div.table-responsive').next('div').find('th a').focus().parent().css("background-color",$cegla);
		}
		else
		{
			if($('a:focus').closest('div.col-md-4').next('div').find('div.table-responsive table tr th a').length>0)
			{
				$("th a").parent().css("background-color","");
				$('a:focus').parent().css("background-color","").closest('div.col-md-4').next('div').find('div.table-responsive table tr th a').first().focus().parent().css("background-color",$cegla);
			}
		}
		$('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
}

function Prawo()
{
	if($('a:focus').closest('div.table-responsive').next('div').find('th a').length>0)
	{
		$("th a").parent().css("background-color","");
		$('a:focus').parent().css("background-color","").closest('div.table-responsive').next('div').find('th a').focus().parent().css("background-color",$cegla);
		$('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
	else
	{
		if($('a:focus').closest('div.col-md-4').next('div').find('div.table-responsive table tr th a').length>0)
		{
			$("th a").parent().css("background-color","");
			$('a:focus').parent().css("background-color","").closest('div.col-md-4').next('div').find('div.table-responsive table tr th a').first().focus().parent().css("background-color",$cegla);
			$('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
		}
	}
}

function Lewo()
{
	if($('a:focus').closest('div.table-responsive').prev('div').find('th a').length>0)
	{
		$("th a").parent().css("background-color","");
		$('a:focus').parent().css("background-color","").closest('div.table-responsive').prev('div').find('th a').focus().parent().css("background-color",$cegla);
		$('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
	else
	{
		if($('a:focus').closest('div.col-md-4').prev('div').find('div.table-responsive table tr th a').length>0)
		{
			$("th a").parent().css("background-color","");
			$('a:focus').parent().css("background-color","").closest('div.col-md-4').prev('div').find('div.table-responsive table tr th a').last().focus().parent().css("background-color",$cegla);
			$('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
		}
	}
}
