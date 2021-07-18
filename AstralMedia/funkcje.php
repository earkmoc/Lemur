<?php 
function iso885922utf8($text) {
	 $text = str_replace('±', "\xC4\x85", $text);
	 $text = str_replace('¡', "\xC4\x84", $text);
	 $text = str_replace('æ', "\xC4\x87", $text);
	 $text = str_replace('Æ', "\xC4\x86", $text);
	 $text = str_replace('ê', "\xC4\x99", $text);
	 $text = str_replace('Ê', "\xC4\x98", $text);
	 $text = str_replace('³', "\xC5\x82", $text);
	 $text = str_replace('£', "\xC5\x81", $text);
	 $text = str_replace('ñ', "\xc5\x84", $text);
	 $text = str_replace('Ñ', "\xc5\x83", $text);
	 $text = str_replace('ó', "\xC3\xB3", $text);
	 $text = str_replace('Ó', "\xC3\x93", $text);
	 $text = str_replace('¶', "\xC5\x9B", $text);
	 $text = str_replace('¦', "\xC5\x9A", $text);
	 $text = str_replace('¿', "\xC5\xBC", $text);
	 $text = str_replace('¯', "\xC5\xBB", $text);
	 $text = str_replace('¼', "\xC5\xBA", $text);
	 $text = str_replace('¬', "\xC5\xB9", $text);
return $text;
}
	