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
	var dd=d+1;
	var mm=m*2+2;
	$('td:nth-child(1)').each(function(){
		if($(this).text().substr(0,s.length)==s)
		{
			cyfry=kod.substring(kod.length-1);
			litery=kod.substring(0,kod.length-1);
			if(isNaN(cyfry))
			{
				cyfry='';
				litery=kod;
			}
			$('table tbody tr:nth-child('+(mm-1)+') td:nth-child('+(dd+1)+')').text(cyfry);
			$('table tbody tr:nth-child('+mm+') td:nth-child('+dd+')').text(litery);
		}
	});
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
		wynik=jQuery.parseJSON(wynik);
		jQuery.each(wynik,function(){
			Feed(this.DATA,this.KOD);
		});
		print();
	});
});
