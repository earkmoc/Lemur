<?php

$buttons[]=array('klawisz'=>'Alt1','nazwa'=>'','js'=>"
	parent.$('li').removeClass('active');
	parent.$('div.tab-pane:not(#home)').removeClass('active');
	parent.$('#liEwidPrzeb').addClass('active');
	parent.$('#EwidPrzeb').addClass('active');
	parent.$('#iframeEwidPrzeb').focus();
");
$buttons[]=array('klawisz'=>'Alt2','nazwa'=>'','js'=>"
	parent.$('li').removeClass('active');
	parent.$('div.tab-pane:not(#home)').removeClass('active');
	parent.$('#liDokumenty').addClass('active');
	parent.$('#Dokumenty').addClass('active');
	parent.$('#iframeDokumenty').focus();
");
