<?php

$buttons[]=array('klawisz'=>'Alt1','nazwa'=>'','js'=>"
	parent.$('li').removeClass('active');
	parent.$('div.tab-pane:not(#home)').removeClass('active');
	parent.$('#liTowary').addClass('active');
	parent.$('#Towary').addClass('active');
	parent.$('#iframeTowary').focus();
");
$buttons[]=array('klawisz'=>'Alt2','nazwa'=>'','js'=>"
	parent.$('li').removeClass('active');
	parent.$('div.tab-pane:not(#home)').removeClass('active');
	parent.$('#liRejestryVAT').addClass('active');
	parent.$('#RejestryVAT').addClass('active');
	parent.$('#iframeRejestryVAT').focus();
");
