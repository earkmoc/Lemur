var $cegla="rgb(255, 102, 0)";
var $biezacy="rgb(255, 204, 102)";

$(document).ready(function() {
	$('a').on( "click", function(){
		$text=$(this).text();
		$params="option="+$(this).attr('id');
//		$params+="&NIP="+$('input[name=NIP]').val();
//		$params+="&NAZWA="+$('input[name=NAZWA]').val().replace('&',' and ');
		$(this).load("save.php",$params,function(){
			$(this).text($text);
		});
		return true;
	});
/*
	$('a[href=#obsluga]').on( "click", function(){
		scroll(0,0);
		return false;
	});
	$('#myModal').on('shown.bs.modal', function () {
		$('#iframeKontrahenci').focus();
	});
	$('input[name=NIP]')
		.on( "focus", function(){szukanie=true;$('#uwaga').hide();})
		.on( "blur", function(){szukanie=false;$('#uwaga').show();});
	$('input[name=NAZWA]')
		.on( "focus", function(){szukanie=true;$('#uwaga').hide();})
		.on( "blur", function(){szukanie=false;$('#uwaga').show();});
	$('select[name=magazyn]')
		.on( "focus", function(){szukanie=true;$('#uwaga').hide();})
		.on( "blur", function(){szukanie=false;$('#uwaga').show();});
*/
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

function Prawo()
{
	if($('a:focus').closest('div.table-responsive').parent().next('div').find('div.table-responsive th a').length>0)
	{
		$("th a").parent().css("background-color","");
		$('a:focus').parent().css("background-color","").closest('div.table-responsive').parent().next('div').find('div.table-responsive th a').first().focus().parent().css("background-color",$cegla);
		$('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
}

function Lewo()
{
	if($('a:focus').closest('div.table-responsive').parent().prev('div').find('div.table-responsive th a').length>0)
	{
		$("th a").parent().css("background-color","");
		$('a:focus').parent().css("background-color","").closest('div.table-responsive').parent().prev('div').find('div.table-responsive th a').first().focus().parent().css("background-color",$cegla);
		$('a:focus').closest('table').find('tr').last().find('td a').focus().parent().css("background-color",$biezacy);
	}
}

function Prev()
{
	if($('a:focus').closest('tr').prev('tr').find('td a').length>0)
	{
		$('td').css("background-color","");
		$('td a:focus').parent().css("background-color","").closest('tr').prev('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
	else if($('a:focus').closest('div.table-responsive').prev('div.table-responsive').find('td a').length>0)
	{
		$('td').css("background-color","");
		$("th a").parent().css("background-color","");
		$('a:focus').closest('div.table-responsive').prev('div.table-responsive').find('th a').first().parent().css("background-color",$cegla);
		$('a:focus').closest('div.table-responsive').prev('div.table-responsive').find('td a').last().focus().parent().css("background-color",$biezacy);
	}
	else
	{
		Lewo();
	}
}

function Next()
{
	if($('a:focus').closest('tr').next('tr').find('td a').length>0)
	{
		$('td').css("background-color","");
		$('a:focus').closest('tr').next('tr').find('td a').focus().parent().css("background-color",$biezacy);
	}
	else if($('a:focus').closest('div.table-responsive').next('div.table-responsive').find('td a').length>0)
	{
		$('td').css("background-color","");
		$("th a").parent().css("background-color","");
		$('a:focus').closest('div.table-responsive').next('div.table-responsive').find('th a').first().parent().css("background-color",$cegla);
		$('a:focus').closest('div.table-responsive').next('div.table-responsive').find('td a').first().focus().parent().css("background-color",$biezacy);
	}
	else
	{
		Prawo();
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
