var maxrow=0, maxcol=0, sumator=0;

$(document).ready(function() 
{
	$('#modalSzukaj').on('shown.bs.modal', function () {
		Focus();
		szukanie=true;
		$('input[name=szukaj]').focus();
	});
	$('#modalSzukaj').on('hidden.bs.modal', function () {
		Focus();
		szukanie=false;
	});
});

$('.table').on('load-success.bs.table', function () 
{
	$('.table-responsive').show();
	maxcol=$("table.table thead tr th").length;
	Check();
	if (mandatory=='')	//je¶li tabela nie ma "mandatory", to jest g³ówna i ma mieæ focus(), subtabele maj± "mandatory" i s± bez focus()
	{
		Focus();
	} else {
		ColorNagOff();
		ColorRowOn();
	}
});

$(window).on('focus',function()
{
	ColorNagOn();
	Focus();
});

$(window).on('blur',function()
{
	ColorNagOff();
});

function Focus() 
{
	$("tr[data-index="+(row-1)+"] td:nth-child("+(col)+") div").focus();
	//$("th[data-field="+(col-1)+"]").focus();
	$("input[name=szukaj]").prop('placeholder','Szukaj w "'+$("th[data-field="+(col-1)+"]").text().trim()+'"');
	Color();
}

Number.prototype.formatMoney = function(c, d, t)
{
var n = this, 
    c = isNaN(c = Math.abs(c)) ? 2 : c, 
    d = d == undefined ? "." : d, 
    t = t == undefined ? "," : t, 
    s = n < 0 ? "-" : "", 
    i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))), 
    j = (j = i.length) > 3 ? j % 3 : 0;
   return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
}
 
function Sumator(delta) 
{
	if (delta==undefined)
	{;}
	else if (delta==0)
	{
		sumator=0;
	}
	else
	{
		sumator=sumator*1+delta*$("tr[data-index="+(row-1)+"] td:nth-child("+(col)+") div").text().replace(',','').replace(',','').replace(',','');
		sumator=1*sumator.toFixed(2);
	}
	$('span.pull-right').html('<b>Sumator: </b>'+sumator.formatMoney());
}

function Color() 
{
//#EFEFDF-warm gray, #FF6600-ceg³a
	ColorNagOff();
	ColorNagOn();
	ColorRowOn();
}

function ColorNagOff() 
{
	$("th").css('background','#EFEFDF');
}

function ColorNagOn() 
{
	$("th[data-field="+(col-1)+"]").css('background','#FF6600');
}

function ColorRowOn()
{
	$("tr[data-index="+(row-1)+"]").css('background','#FFCC66');
}

function Page(delta) 
{
	if (delta<0)
	{
		if ($(".page-pre.disabled").length==0)
		{
			$(".page-pre").click()
		}
		else
		{
			Row(-maxrow);
		}
	} else {
		if ($(".page-next.disabled").length==0)
		{
			$(".page-next").click()
		}
		else
		{
			Row(maxrow);
		}
	}
}

function PageFirst()
{
	$(".page-first").click()
}

function PageLast()
{
	$(".page-last").click()
}

function Row(delta) 
{
	$("tr[data-index="+(row-1)+"]").css('background','');
	row=row+delta;
	Check();
	Focus();
}

function Col(delta) 
{
	$("th[data-field="+(col-1)+"]").css('background','');
	col=col+delta;
	Check();
	Focus();
}

function GetID() 
{
	return $("tr[data-index="+(row-1)+"] td div").html();
}

function GetCol($nr) 
{
	return $("tr[data-index="+(row-1)+"] td:nth-child("+$nr+") div").html();
}

function Check() 
{
	maxrow=$("table.table tbody tr").length;
	if  (	(row>maxrow)
		&&	(maxrow>0)
		) 
	{
		if  (	$(".page-next.disabled").length==1
			||	row==1000
			)
		{
			row=maxrow;
		} else {
			row=1;
			$(".page-next").click();
		}
	}

	if (row<1) 
	{
		if ($(".page-pre.disabled").length==1)
		{
			row=1;
		} else {
			row=maxxrow;
			$(".page-pre").click();
		}
	}

	if (col<1) 
	{
		col=2;
	}

	if (col>maxcol) 
	{
		col=maxcol;
	}
}
