function Aggregate(n)
{
	var pop="";
	var objToAggregate;
	var colAggregated=1;
	$('table#tab tbody tr td:nth-child('+n+')').each(function(){
		var cur=$(this).text();
		if	( (cur!="")
			&&(pop==cur)
			)
		{
			$(this).remove();
			colAggregated+=1;
			objToAggregate.attr('rowspan',colAggregated);
		}
		else
		{
			objToAggregate=$(this);
			colAggregated=1;
		}
		pop=cur;
	});
}

$(document).ready(function() {
//	Aggregate(4);
	Aggregate(3);
	Aggregate(2);
});