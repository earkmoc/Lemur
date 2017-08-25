$(document).ready(function() {
   $('#mainForm').removeClass("panel");
   $('#mainForm').css("margin","");
   $('#mainForm').css("padding","");
   $('select[name=KLIENT]').focus();
   $('input[name=LP]').focus();
   $('#buttonTAK').on('click',function(){
		alert('Akcja na "TAK"');
   });
	$('#myModal').on('shown.bs.modal', function () {
		$('#iframeKontrahenci').focus();
	});
	$('#myModal').on('hidden.bs.modal', function () {
		$('input[name=OPIS]').focus();
	});
});

function valid($name,$validType) {
  $value=$("input[name="+$name+"]").val();
  $params="val="+$value+"&validType="+$validType;
  $("input[name="+$name+"]").load("valid.php",$params,function($wynik){
    //$wynik=$(this).text();
    if ($(this).css("background-color")=="rgb(255, 0, 0)") {
      $(this).attr("title","");
      $(this).tooltip("destroy");
      $(this).parent().prev().css("font-weight", "").css("color", "");
      $(this).css("font-weight", "").css("color", "").css("background-color", "");
      $("#button_Enter").prop("disabled",false);
      $("#button_Enter").show();
    }
    if ($wynik.substr(0,3)=="nie") {
      $(this).attr("title","<font style='font-size:12pt'>"+$wynik+"</font>");
      $(this).tooltip({placement: "right", html: true}).tooltip("show");
      $(this).parent().prev().css("font-weight", "bold").css("background-color", "rgb(255, 102, 0)");
      $(this).css("font-weight", "bold").css("color", "white").css("background-color", "red");
      $("#button_Enter").prop("disabled",true);
      $("#button_Enter").hide();
    }
    //$(this).val($wynik);
  });
  return true;
}