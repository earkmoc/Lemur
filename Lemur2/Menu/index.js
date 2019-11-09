//musi być to podane z użyciem "rgb()" bo tak to jest potem zwracane z funkcji "css()"
var $cegla="rgb(85, 85, 85)";
var $biezacy="rgb(255, 255, 255)";

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

function Menu($cyfra)
{
	//wszystkim komórkom nagłówkowym (th), zgaś background
	$("th a").parent().css("background-color","");
	//jednej komórce nagłówkowej (th) (rodzicowi  jednego głównego linku (a)) zapal background
	$("#"+$cyfra).focus().parent().css("background-color",$cegla);
	SubMenu("a");
}

function SubMenu($litera)
{
	//wszystkim cells, które mają kolor $biezacy, zgaś kolor
	$("td").filter(function(){
		return ($(this).css("background-color")==$biezacy);
	}).css("background-color","");
	
	//znajdź komórkę nagłówkową (th), która ma kolor $cegla i dla tego menu (np.: 1) zaznacz opcję $litera (np.: 1a), a komórce nadaj kolor $biezacy
	$("#"
	+$("th").filter(function(){
		return ($(this).css("background-color")==$cegla);
	}).text()[0]+$litera).focus().parent().css("background-color",$biezacy);
}

//KEY_UP
function Prev()
{
	//jest jakaś poprzednia opcja w tym submenu, tj. focus nie stał na pierwszej opcji tego submenu
	if($('a:focus').closest('tr').prev('tr').find('td a').length>0)
	{
		$('td a').parent().css("background-color","");
		$('a:focus').closest('tr').prev('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
	else
	{
		//jest jakieś poprzednie submenu w tej szpalcie, tj. focus nie stał w pierwszym submenu
		if($('a:focus').closest('div.table-responsive').prev('div.table-responsive').length>0)
		{
			//przejdź do poprzedniego submenu w tej szpalcie
			$("a").parent().css("background-color","");
			//          przejdź do root tego submenu,  przejdź do root poprz submenu, znajdź link główny i zapal go
			$('a:focus').closest('div.table-responsive').prev('div.table-responsive').find('th a').focus().parent().css("background-color",$cegla);
			//zapal w powyższym submenu ostatni wiersz
			$('a:focus').closest('table tbody').find('tr td a').last().focus().parent().css("background-color",$biezacy);
		}
		else
		{
			//przejdź do ostatniej opcji ostatniego submenu w tej szpalcie
			if($('a:focus').closest('div.szpalta').find('div.table-responsive table tr th a').length>0)
			{
				$("a").parent().css("background-color","");
				$('a:focus').closest('div.szpalta').find('div.table-responsive table tr th a').last().focus().parent().css("background-color",$cegla);
				$('a:focus').closest('table tbody').find('tr td a').last().focus().parent().css("background-color",$biezacy);
			}
		}
	}
}

//KEY_DOWN
function Next()
{
	//jest jakaś następna opcja w tym submenu, tj. focus nie stał na ostatniej opcji tego submenu
	if($('a:focus').closest('tr').next('tr').find('td a').length>0)
	{
		$('td a').parent().css("background-color","");
		$('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
	else
	{
		//jest jakieś następne submenu w tej szpalcie, tj. focus nie stał w ostatnim submenu
		if($('a:focus').closest('div.table-responsive').next('div.table-responsive').find('th a').length>0)
		{
			$("a").parent().css("background-color","");
			$('a:focus').closest('div.table-responsive').next('div.table-responsive').find('th a').focus().parent().css("background-color",$cegla);
		    $('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
		}
		else
		{
			//przejdź do pierwszej opcji pierwszego submenu w tej szpalcie
			if($('a:focus').closest('div.szpalta').find('div.table-responsive table tr th a').length>0)
			{
				$("a").parent().css("background-color","");
				$('a:focus').closest('div.szpalta').find('div.table-responsive table tr th a').first().focus().parent().css("background-color",$cegla);
				$('a:focus').closest('div.szpalta').find('tr td a').first().focus().parent().css("background-color",$biezacy);
			}
		}
	}
}

function Prawo()
{
	//jest jakaś następna szpalta
	if($('a:focus').closest('div.szpalta').next('div.szpalta').find('th a').length>0)
	{
		$("a").parent().css("background-color","");
		$('a:focus').closest('div.szpalta').next('div.szpalta').find('th a').first().focus().parent().css("background-color",$cegla);
		$('a:focus').closest('div.szpalta').find('td a').first().focus().parent().css("background-color",$biezacy);
	}
	else
	{
		$("a").parent().css("background-color","");
		$('#1').focus().parent().css("background-color",$cegla);
		$('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
}

function Lewo()
{
	//jest jakaś poprzednia szpalta
	if($('a:focus').closest('div.szpalta').prev('div.szpalta').find('th a').length>0)
	{
		$("a").parent().css("background-color","");
		$('a:focus').closest('div.szpalta').prev('div.szpalta').find('th a').first().focus().parent().css("background-color",$cegla);
		$('a:focus').closest('div.szpalta').find('td a').first().focus().parent().css("background-color",$biezacy);
	}
	else
	{
		$("a").parent().css("background-color","");
		$('a:focus').closest('div.szpalta').parent().find('div.szpalta').last().find('th a').first().focus().parent().css("background-color",$cegla);
		$('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
}

function RedON($this,$title)
{
	$this.attr("title","<font style='font-size:14pt'>"+$title+"</font>");
	$this.tooltip({placement: "right", html: true}).tooltip("show");
	$this.css("font-weight", "bold").css("color", "white").css("background-color", "red");
}

function RedOFF($this)
{
	if ($this.css("background-color")=="rgb(255, 0, 0)") 
	{
		$this.attr("title","");
		$this.tooltip("destroy");
		$this.parent().prev().css("font-weight", "").css("color", "");
		$this.css("font-weight", "").css("color", "").css("background-color", "");
	}
}

function RegulaZlamana($name,$title)
{
	$this=$("input[name="+$name+"]");
	RedON($this,$title);
}

function RegulaOK($name)
{
	$this=$("input[name="+$name+"]");
	RedOFF($this);
}

function GetKontrahentByNIP($name,$validType)
{
	$value=$("input[name="+$name+"]").val();
	$params="val="+$value+"&validType="+$validType;
	$("input[name="+$name+"]").load("valid.php",$params,function(){
		$wynik=$(this).text();
		if ($wynik.substr(0,3)=="nie") {
			RegulaZlamana($name,$wynik);
		}
		else
		{
			RegulaOK($name);
			if($wynik!="")
			{
				var arr=$wynik.split(",");
				$("input[name=NIP]").val(arr[0]);
				$("input[name=NAZWA]").val(arr[1]);
				if(arr[2]>1)
				{
					$('#myModal').modal('show');
					$('#iframeKontrahenci').attr( 'src', function ( i, val ) { return val; });
				}
			}
		}
	});
}

function GetKontrahentByNAZWA($name,$validType)
{
	$value=$("input[name="+$name+"]").val();
	$params="val="+$value+"&validType="+$validType;
	$("input[name="+$name+"]").load("valid.php",$params,function(){
		$wynik=$(this).text();
		if ($wynik.substr(0,3)=="nie") {
			RegulaZlamana($name,$wynik);
		}
		else
		{
			RegulaOK($name);
			if($wynik!="")
			{
				var arr=$wynik.split(",");
				$("input[name=NIP]").val(arr[0]);
				$("input[name=NAZWA]").val(arr[1]);
				if(arr[2]>1)
				{
					$('#myModal').modal('show');
					$('#iframeKontrahenci').attr( 'src', function ( i, val ) { return val; });
				}
			}
		}
	});
}

function valid($name,$validType) 
{
	if($validType=='NIP') 		{GetKontrahentByNIP($name,$validType);}
	if($validType=='NAZWA') 	{GetKontrahentByNAZWA($name,$validType);}
	return true;
}
