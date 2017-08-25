<script type="text/javascript" language="JavaScript">

var szukanie=false;

$(document).ready(function() {
   $('.dateTimePicker').datetimepicker({
      format: 'yyyy-mm-dd hh:ii'
     ,forceParse: true
     ,autoclose: true
     ,todayBtn: true
     ,minuteStep: 15
     ,weekStart: 1
     ,language: "pl"
   });
   $('.datePicker').datepicker({
      format: 'yyyy-mm-dd'
     ,forceParse: true
     ,autoclose: true
     ,todayBtn: true
     ,minuteStep: 15
     ,weekStart: 1
     ,language: "pl"
   });
   //$("[data-toggle='confirmation-singleton']").confirmation();
   $('input,select,textarea').focusin(function(){
	   //$(this).parent().prev().css({'background':'#FF6600','font-weight':'bold'});
	   $(this).parent().prev().css({'background':'#FF6600'});
   });
   $('input,select,textarea').focusout(function(){
	   //$(this).parent().prev().css({'background':'','font-weight':'normal'});
	   $(this).parent().prev().css({'background':''});
   });
   //$('li.active').css('background','#FF6600');
});

function buttonsHide() {
<?php
	foreach($buttons as $button) {
		echo "      $('#button{$button['klawisz']}').hide();"."\n";
	}
?>
}

function buttonsShow() {
<?php
	foreach($buttons as $button) {
		echo "      $('#button{$button['klawisz']}').show();"."\n";
	}
?>
}

$(document).ready(function() {
<?php
	foreach($buttons as $button) {
		echo "   $('#button{$button['klawisz']}').on('click',function(){"."\n";
		if (@$button['akcja'])
		{
			echo "      buttonsHide();"."\n";
			echo "      $('#mainForm').attr('action','{$button['akcja']}');"."\n";
		};
		if (@$button['js'])
		{
			echo "      {$button['js']}; return false;"."\n";
		}
		echo "   });"."\n";
	}
?>
});

$(document).keydown(function(e) 
{
	switch ($key=e.keyCode) 
	{
	   case 13: $klawisz='Enter'; break;
	   case 27: $klawisz='Esc'; break;
	   case 33: $klawisz='PgUp'; break;
	   case 34: $klawisz='PgDown'; break;
	   case 35: $klawisz='End'; break;
	   case 36: $klawisz='Home'; break;
	   case 37: $klawisz='Left'; break;
	   case 38: $klawisz='Up'; break;
	   case 39: $klawisz='Right'; break;
	   case 40: $klawisz='Down'; break;
	   case 106: $klawisz='Multiply'; break;
	   case 107: $klawisz='Plus'; break;
	   case 109: $klawisz='Minus'; break;
	   case 111: $klawisz='Divide'; break;
	   default:
				$klawisz=String.fromCharCode($key);
	}
	if (e.altKey)
	{
		$klawisz='Alt'+$klawisz;
	}
	if (e.ctrlKey)
	{
		$klawisz='Ctrl'+$klawisz;
	}

	if(szukanie)
	{
		if($klawisz!='Enter')
		{
			return true;
		} else 
		{
			$('#mainForm').attr('action','szukaj.php?col='+col);
			$('#mainForm').submit();
			return false;
		}
	}

	switch ($klawisz) {
<?php
	foreach($buttons as $button) {
		echo "   case '{$button['klawisz']}':"."\n";
		echo "      $('#button{$button['klawisz']}').click();"."\n";
		echo "      return false;"."\n";
	}
?>
	   default:
		  return true;
   }
});

</script>