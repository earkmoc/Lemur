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
function KodDaty(data)
{
	return data.substr(8,2);
}
function RzymskiMc(mc)
{
	return mce[mc-1];
}
function Feed(data,kod)
{
	var m=ArabskiMc(data);
	var d=ArabskiDzien(data);
	var k=KodDaty(data);
	var s=RzymskiMc(m);
	var dd=d+1;
	var mm=m*2+2;
	$('td:nth-child(1)').each(function(){
		if($(this).text().substr(0,s.length)==s)
		{
			if(dd>1)
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
			else
			{
				switch(k) {
					case 'O':
						$('table tbody tr:nth-child('+(mm-1)+') td:nth-child(34)').text(kod);
						break;
					case 'NS':
						$('table tbody tr:nth-child('+(mm-1)+') td:nth-child(35)').text(kod);
						break;
					case 'N':
						$('table tbody tr:nth-child('+(mm-1)+') td:nth-child(36)').text(kod);
						break;
					case 'GN':
						$('table tbody tr:nth-child('+(mm-1)+') td:nth-child(37)').text(kod);
						break;
					case 'DW':
						$('table tbody tr:nth-child('+(mm-1)+') td:nth-child(38)').text(kod);
						break;
					default:
				}
			}
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
		var uwagi='';
		jQuery.each(wynik,function(){
			if(this.DATA)
			{
				Feed(this.DATA,this.KOD);
			}
			else
			{
				uwagi=this;
			}
		});
		for(i=0;i<20;++i)
		{
			uwagi=uwagi.replace(String.fromCharCode(13),"<br>");
		}
		uwagi=uwagi+"<br><br>";
		uwagi=$('table tbody tr td[colspan=33]').text().replace('UWAGI:',uwagi);
		$('table tbody tr td[colspan=33]').html(uwagi);
		print();
	});
});
