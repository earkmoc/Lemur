var rok=0;
var wynik=0;
var mce=["I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII"];

function ArabskiMc(data)
{
	return data.substr(5,2)*1;
}
function ArabskiDzien(data)
{
	return data.substr(8,2)*1;
}
function RzymskiMc(mc)
{
	return mce[mc-1];
}
function Feed(data,kod)
{
	var m=ArabskiMc(data);
	var d=ArabskiDzien(data);
	var s=RzymskiMc(m);
	$('td:nth-child(1)').each(function(){
		if($(this).text().substr(0,s.length)==s)
		{
			d=d+1;
			m=m*2+2;
			$('table tbody tr:nth-child('+m+') td:nth-child('+d+')').text(kod);
//			$(this).parent().children(':not(td[bgcolor=lightgrey])').text('8');
//			$(this).parent().next().children(':not(td[bgcolor=lightgrey])').text(kod);
		}
	});
//	$('table#tab tbody tr td:nth-child('+n+')').each(function(){
//		var cur=$(this).text();
//	});
}

$(document).ready(function() {
	var rokNapis="rok: ";
	$('span.big').each(function(){
		if($(this).text().substr(0,rokNapis.length)==rokNapis)
		{
			rok=$(this).text().replace(rokNapis,"");
		}
	});

	$params='id='+id+'&rok='+rok;
	$('table[width=2100]').load('ecpAbsencje.php',$params,function(){
		wynik=$(this).html();
		$(this).html('');
		//alert(wynik);
		wynik=jQuery.parseJSON(wynik);
		jQuery.each(wynik,function(){
			Feed(this.DATA,this.KOD);
		});
	});
});
