var rok=0;

function Feed(s,n)
{
	var rokNapis="rok: ";
	$('span.big').each(function(){
		if($(this).text().substr(0,rokNapis.length)==rokNapis)
		{
			rok=$(this).text().replace(rokNapis,"");
		}
	});
	$('td').each(function(){
		if($(this).text().substr(0,s.length)==s)
		{
			$(this).text('test').parent().children(':not(td[bgcolor=lightgrey])').text('8');
			$(this).text('test').parent().next().children(':not(td[bgcolor=lightgrey])').text('U');
		}
	});
//	$('table#tab tbody tr td:nth-child('+n+')').each(function(){
//		var cur=$(this).text();
//	});
}

$(document).ready(function() {
//	Feed("VIII",8);
});
