<!-- Modal -->
<div class="modal" id="modalSzukaj" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
			 <div class="row">
				 <div class="col-md-7">
					<input name="szukaj" class="form-control" placeholder="Szukaj" value="" style="font-size:20px; height:30px" />
				 </div>
				 <div class="col-md-2">
					<span class="glyphicon glyphicon-sort-by-attributes"></span>
						<input type="radio" name="sortuj" value="+" style="font-size:20px; height:30px" title="rosn�co" />
					<span class="glyphicon glyphicon-sort-by-attributes-alt"></span>
						<input type="radio" name="sortuj" value="-" style="font-size:20px; height:30px" title="malej�co" />
					<span class="glyphicon glyphicon-sort-by-order"></span>
						<input type="radio" name="sortuj" value="0" style="font-size:20px; height:30px" title="domy�lnie" />
				 </div>
				 <div class="col-md-3">
					<div class="panel-heading">
					  <h4 class="panel-title">
						<a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
						  <span class="glyphicon glyphicon-hand-right"></span>
						  Instrukcja
						</a>
					  </h4>
					</div>
				 </div>
			 </div>
			<div class="panel-group" id="accordion">
				<div class="panel panel-default">
					<div id="collapseOne" class="panel-collapse collapse">
					  <div class="panel-body">
						<ul>
						<li><span>puste pole</span> "Szukaj" i <span>brak wyboru</span> sortowania oznaczaj� "poka� <span>wszystkie</span> dane". Nast�puje wtedy odwo�anie ewentualnych dotychczasowych warunk�w filtrowania danych i przywr�cenie domy�lnego sortowania w tabeli
						<hr>
						Wpisanie w polu "Szukaj" tekstu/liczby oznacza "poka� dane <span>zawieraj�ce</span> podany tekst/liczb� <b>w bie��cej kolumnie</b>", np.:
						<li><b>WALC</b> poka�e dane o warto�ciach <b>WALC</b>, a tak�e <b>WALC</b>ZAK, KO<b>WALC</b>ZYK, GROM-<b>WALC</b>, itp.
						<li><b>15</b> poka�e dane o warto�ciach <b>15</b>, a tak�e <b>15</b>97, 9<b>15</b>7, 97<b>15</b> itp.
						<hr>
						Na pocz�tku pola "Szukaj" mo�na stosowa� znaki <span>= < > *</span> lub dalej dwuznak <span>::</span> (dwa dwukropki), np.:
						<li><span>=</span><b>15</b> oznacza dane o warto�ciach <span>r�wnych</span> <b>15</b>
						<li><span><=</span><b>15</b> oznacza dane o warto�ciach <span>mniejszych lub r�wnych</span> <b>15</b>
						<li><span>*</span><b>15</b> oznacza dane o warto�ciach <span>ko�cz�cych si�</span> cyframi <b>15</b> (znak <span>*</span> zast�puje dowolny ci�g znak�w)
						<li><b>10</b><span>::</span><b>15</b> oznacza dane o warto�ciach <span>z zakresu</span>: od <b>10</b> (w��cznie) do <b>15</b> (w��cznie)
						<hr>
						Na ko�cu pola "Szukaj" mo�na stosowa� znak <span>*</span>, np.:
						<li><b>15</b><span>*</span> oznacza dane o warto�ciach <span>zaczynaj�cych si�</span> cyframi <b>15</b> (znak <span>*</span> zast�puje dowolny ci�g znak�w)
						<li><b>AJA</b><span>*</span> oznacza dane o warto�ciach <span>zaczynaj�cych si�</span> od tekstu <b>AJA</b>
						<hr>
						Je�li kolumna jest typu "tekst" lub "data", to po u�yciu znak�w <span> = < ></span> dalsz� cz�� warunku trzeba uj�� w cudzys�owy, np.:
						<li><span>>="</span><b>2016-12-01</b><span>"</span> oznacza dane o datach <span>r�wnych lub p�niejszych</span> ni� <b>2016-12-01</b>
						<li><span><>""</span> oznacza dane o warto�ciach <span>niepustych</span>
						<li><span>=""</span> oznacza dane o warto�ciach <span>pustych</span>
						<hr>
						Zaznaczaj�c odpowiednie pole wyboru mo�na posortowa� dane:
						<li><span class="glyphicon glyphicon-sort-by-attributes"></span> oznacza sortowanie <span>rosn�co</span>
						<li><span class="glyphicon glyphicon-sort-by-attributes-alt"></span> oznacza sortowanie <span>malej�co</span>
						<li><span class="glyphicon glyphicon-sort-by-order"></span> oznacza sortowanie <span>domy�lne</span> dla danej tabeli
						</ul>
					  </div>
					</div>
				</div>
			</div>
         </div>
	  </div>
   </div>
</div>

<script type="text/javascript">
	<?php	//w funkcji ParametryRefresh przekazane do refresh.php 
		if (false&&$mandatory)
		{
			$str=1;
			$row=1;
			$col=2;
		}

		$str=(!@$str||1*$str<1?1:$str);
		$row=(!@$row||1*$row<1?1:$row);
		$col=(!@$col||1*$col<1?1:$col);

		echo "var firma='$firma';\n";
		echo "var tabela='$tabela';\n";
		echo "var widok='$widok';\n";
		echo "var str=$str;\n";
		echo "var row=$row;\n";
		echo "var col=$col;\n";
		echo "var maxxrow=".(isset($id_d)?5:(($ido==10)?20:15)).";\n";
		echo "var mandatory=\"$mandatory\";\n";
	?>
</script>

<div class="container-fluid bs-docs-container">
	<div class="row">
		<div class="col-md-12">
				<div class="table-responsive" hidden>
					<table data-toggle="table" 
						data-query-params-type="limitt" 
						data-query-params="ParametryRefresh" 
						data-url="refresh.php" 
						data-side-pagination="server" 
						data-pagination="true" 
						data-page-number="<?php echo $str;?>" 
						data-page-size="<?php echo (isset($id_d)?5:(($ido==10)?20:15));?>" 
						data-page-list="[5,10,15,20,50,100,All]" 
						data-response-handler="UzyskaneDane" 
						data-mobile-responsive="true" 
						data-flat="true" 
						data-classes="table"
						class="table"
					>
<?php
echo '<thead>';
echo '<tr>';
foreach ( $fields as $field ) {
// 			  data-field='{$field[pole]}' 
//			data-sortable='true'
	echo "<th 
            data-events='operateEvents'
			data-formatter='operateFormatter'
			data-align='{$field['align']}'
	";
	if ($field['visible']=='false')
	{
		echo "
			data-cell-style='hiddenColumn'
			data-class='hiddenColumn'
		";
	}
	echo "
		>   {$field['nazwa']}
		  </th>
	";
}
echo '</tr>';
echo '</thead>';

?>
					</table>
				</div>
		</div>
	</div>
</div>

<script>
	window.operateEvents = {
        'click .cell': function (e, value, row) {
//             $('.search input').val(value).focus();
//             alert('You click value: ' + value + ' in row ' + JSON.stringify(row));
        }
    };
    function operateFormatter(value, row, index) {
        return [
            '<div class="cell" tabindex="'+index+'">',
            value,
            '</div>'
        ].join('');
    }
	function ParametryRefresh(params) {
		params['firma']=firma;
		params['tabela']=tabela;
		params['widok']=widok;
		params['mandatory']=mandatory;
		params['row']=row;
		params['col']=col;
		//alert(JSON.stringify(params));
		return params;
	}

	//data-response-handler="UzyskaneDane" 
	function UzyskaneDane(res) {
		//alert(JSON.stringify(res));
		//maxstr=1+res.total/res.pageSize;
		str=1+res.offset/res.pageSize;
		$('div.fixed-table-toolbar').html(res.filtr+'<span class="pull-right">'+res.sort+'</span>');
		return res;
	}

	//data-cell-style="hiddenColumn" 
	function hiddenColumn(value, row, index, field) {
	  return {
		classes: "hiddenColumn"
	  };
	}
</script>
