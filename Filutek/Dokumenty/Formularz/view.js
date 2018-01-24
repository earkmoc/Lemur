$(document).ready(function() {
	$('select[name=TYP]').focus();
	$('#myModal').on('shown.bs.modal', function () {
		$('#iframeKontrahenci').focus();
	});
	$('#myModalP').on('shown.bs.modal', function () {
		$('#iframePrzedmioty').focus();
	});
	$('#myModalT').on('shown.bs.modal', function () {
		$('#iframeTypyRejestrow').focus();
	});
	$('#myModalWn').on('shown.bs.modal', function () {
		$('#iframeKontaWn').focus();
	});
	$('#myModalMa').on('shown.bs.modal', function () {
		$('#iframeKontaMa').focus();
	});
	$('#myModalMagazyn').on('shown.bs.modal', function () {
		$('#iframeMagazyn').focus();
	});
	$('iframe').on('focus', function () {
		if($(this).prop('src')=='')
		{
			$(this).hide();
			$(this).prop('src',$(this).attr('ssrc'));
			$(this).show();
		}
	});
	$('.nav-tabs a').on('shown.bs.tab', function(event){
		$('#'+$(this).parent().attr('id').replace('li','iframe')).focus();
	});
});

function EnterON()
{
	$("#button_Enter").prop("disabled",false);
	$("#button_Enter").show();
}

function EnterOFF()
{
	$("#button_Enter").prop("disabled",true);
	$("#button_Enter").hide();
}

function RedON($this,$title)
{
	$this.attr("title","<font style='font-size:14pt'>"+$title+"</font>");
	$this.tooltip({placement: "top", html: true}).tooltip("show");
//	$this.parent().prev().css("font-weight", "bold").css("background-color", "rgb(255, 102, 0)");
	$this.css("font-weight", "bold").css("color", "white").css("background-color", "red");
//	EnterOFF();
}

function RedOFF($this)
{
	if ($this.css("background-color")=="rgb(255, 0, 0)") 
	{
		$this.attr("title","");
		$this.tooltip("destroy");
		$this.parent().prev().css("font-weight", "").css("color", "");
		$this.css("font-weight", "").css("color", "").css("background-color", "");
//		EnterON();
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

function RegulaMR($name,$validType,$title)
{
	if($("input[name="+$name+"]").val()>$("input[name="+$validType+"]").val())
	{
		RegulaZlamana($name,$title);
	}
	else
	{
		RegulaOK($name);
	}
}

function RegulaWR($name,$validType,$title)
{
	if($("input[name="+$name+"]").val()<$("input[name="+$validType+"]").val())
	{
		RegulaZlamana($name,$title);
	}
	else
	{
		RegulaOK($name);
	}
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

function NextNumer($name,$validType)
{
	$typ=$("select[name=TYP]").val();
	$data=$("input[name=DDOKUMENTU]").val();
	$value=$("input[name=NUMER]").val();
	$params="typ="+$typ+"&data="+$data+"&val="+$value+"&validType=NextNumer";
	$("input[name=NUMER]").load("valid.php",$params,function(){
		$("input[name=NUMER]").val($(this).text());
	});
}

function CheckNumer($name,$validType)
{
	$typ=$("select[name=TYP]").val();
	$data=$("input[name=DDOKUMENTU]").val();
	$value=$("input[name="+$name+"]").val();
	$params="typ="+$typ+"&data="+$data+"&val="+$value+"&validType="+$validType;
	$("input[name="+$name+"]").load("valid.php",$params,function(){
		$wynik=$(this).text();
		if ($wynik.substr(0,4)=="jest") {
			RegulaZlamana($name,$wynik);
		}
		else
		{
			RegulaOK($name);
		}
	});
}

function valid($name,$validType) 
{
	if( ($validType=='DOPERACJI')
	  ||($validType=='DDOKUMENTU')
      )
	{
		$title="Zachowaj regu³ê:<br>Data wystawienia <= Data Operacji";
		RegulaMR('DDOKUMENTU','DOPERACJI',$title);
		RegulaWR('DOPERACJI','DDOKUMENTU',$title);
	}
	if($validType=='NIP') 		{GetKontrahentByNIP($name,$validType);}
	if($validType=='NAZWA') 	{GetKontrahentByNAZWA($name,$validType);}
	if($validType=='DOPERACJI') {NextNumer($name,$validType);}
	if($validType=='NUMER') 	{CheckNumer($name,$validType);}
	return true;
}
