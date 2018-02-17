$(document).ready(function() {
   $('input[name=DATANABYCIA]').focus();
});

function valid($name,$validType) {
  $value=$('input[name='+$name+']').val();
  $params='val='+$value+'&validType='+$validType;
  $('input[name='+$name+']').load("valid.php",$params,function(){
    $wynik=$(this).html();
    if ($(this).parent().prev().css('color')=='rgb(255, 0, 0)') {
      $(this).attr("title","");
      $(this).tooltip("destroy");
      $(this).parent().prev().css('font-weight', '').css('color', '');
      $(this).css('font-weight', '').css('color', '');
      $('#button_Enter').prop('disabled',false);
      $('#button_Enter').show();
    }
    if ($wynik.substr(0,4)=='brak') {
      $(this).attr("title",'<font style="font-size:12pt">'+$wynik+'</font>');
      $(this).tooltip({placement: "top", html: true}).tooltip("show");
      $(this).parent().prev().css('font-weight', 'bold').css('color', 'red');
      $(this).css('font-weight', 'bold').css('color', 'red');
      $('#button_Enter').prop('disabled',true);
      $('#button_Enter').hide();
      $wynik=$value;
    }
    $(this).val($wynik);
  });
  return true;
}