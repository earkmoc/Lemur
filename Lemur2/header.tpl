<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta, title, CSS, favicons, etc. -->
<meta charset="iso-8859-2">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">

<title><?php echo $title;?></title>

<style>
	.hiddenColumn {width:2px; font-size: 0px; padding: 0px !important; margin: 0px !important; visibility:hidden; }
</style>

<!-- Bootstrap core CSS -->
<link href="<?php echo 'http://'.$_SERVER['HTTP_HOST'];?>/bootstrap-master/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="<?php echo 'http://'.$_SERVER['HTTP_HOST'];?>/bootstrap-table-master/dist/bootstrap-table.min.css" rel="stylesheet">

<!-- Documentation extras -->
<link href="<?php echo 'http://'.$_SERVER['HTTP_HOST'];?>/bootstrap-master/docs/assets/css/docs.css" rel="stylesheet">
<link href="<?php echo 'http://'.$_SERVER['HTTP_HOST'];?>/bootstrap-master/docs/assets/css/pygments-manni.css" rel="stylesheet">
<!--[if lt IE 9]><script src="<?php echo 'http://'.$_SERVER['HTTP_HOST'];?>/bootstrap-master/docs/assets/js/ie8-responsive-file-warning.js"></script><![endif]-->

<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
  <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
<![endif]-->

<style>
	body {background-color: #049;}
	.fixed-table-container tbody td .th-inner, .fixed-table-container thead th .th-inner {text-align: center; white-space: normal;}
	.bootstrap-table .table > thead > tr > th {vertical-align: middle;}
	.bootstrap-table .table:not(.table-condensed) > tbody > tr > td.hiddenColumn {margin: 0px !important; padding: 0px !important; width: 0px !important; visibility:hidden !important; font-size: 0px;}
	.bootstrap-table .table:not(.table-condensed), .bootstrap-table .table:not(.table-condensed) > tbody > tr > td, .bootstrap-table .table:not(.table-condensed) > tbody > tr > th, .bootstrap-table .table:not(.table-condensed) > tfoot > tr > td, .bootstrap-table .table:not(.table-condensed) > tfoot > tr > th, .bootstrap-table .table:not(.table-condensed) > thead > tr > td {padding: 6px !important;}
</style>

</head>

<body>
	<a class="sr-only" href="#content">Skip to main content</a>

	<!-- Docs master nav
				<a href="<?php echo $_SERVER['DOCUMENT_ROOT'];?>/index.php" class="navbar-brand"><?php echo $title;?></a>
				<ul class="nav navbar-nav">
               
				</ul>
    -->

<form id="mainForm" role="form" method="POST" action="" class="panel panel-default" style="margin: 5px; padding: 5px;">

	<header class="navbar navbar-inverse navbar-fixed-top bs-docs-nav" role="banner">
		<div class="container-fluid">
			<div class="navbar-header">
				<button class="navbar-toggle" type="button" data-toggle="collapse"
					data-target=".bs-navbar-collapse">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<div style="color: white; font-size:20pt; margin: 5pt 2pt 0pt 10pt;">
					<?php echo $title;?>
				</div>
			</div>

			<nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation">
				<ul class="nav navbar-nav navbar-right">
<?php
					foreach($buttons as $button) {
						echo "<li><button id='button{$button['klawisz']}' class='btn btn-primary hidden-print";
						if (! $button['nazwa']) {
						    echo ' hidden ';
						}
						echo "'" . @$button['atrybuty'];
						//echo " data-toggle='confirmation-singleton' data-placement='bottom'";
						echo " style='margin: 5pt 2pt 0pt 0pt;'>{$button['nazwa']}</button></li>";
					}
?>
					<li><a href="http://ericom.pl">ericom</a></li>
				</ul>
			</nav>
		</div>
	</header>

	<!-- Docs page layout -->
	<div class="bs-header" id="content" hidden>
		<div class="container-fluid">
			<h><?php echo $title;?></h>
		</div>
	</div>
