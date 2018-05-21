<?php
@session_start ();
class Klocek {
	public $r = 0;
	public $c = 0;
	public $w = 0;
	public $h = 0;
	public $nr = 0;
	public $picture = '';
	function __construct(&$tablica, $row, $col, $width, $height, $nr, $picture) {
		$this->r = $row;
		$this->c = $col;
		$this->w = $width;
		$this->h = $height;
		$this->nr = $nr;
		$this->picture = $picture;
		$this->Ustaw ( $tablica );
	}
	// zdejmij ten klocek z tablicy przed ruchem
	function Zdejmij(&$tablica) {
		for($r = $this->r; $r < $this->r + $this->h; ++ $r) {
			for($c = $this->c; $c < $this->c + $this->w; ++ $c) {
				$tablica [$r] [$c] = '';
			}
		}
	}
	// jeśli po ruchu trafi w zajęte pole, to cofnij ruch
	function Zajete($tablica) {
		for($r = $this->r; $r < $this->r + $this->h; ++ $r) {
			for($c = $this->c; $c < $this->c + $this->w; ++ $c) {
				if ($tablica [$r] [$c]) {
					return true;
				}
			}
		}
		return false;
	}
	// ustaw klocek
	function Ustaw(&$tablica) {
		for($r = $this->r; $r < $this->r + $this->h; ++ $r) {
			for($c = $this->c; $c < $this->c + $this->w; ++ $c) {
				$tablica [$r] [$c] = $this->picture;
			}
		}
	}
	function Move($kierunek, &$tablica, $maxRow, $maxCol) {
		$prev_r = $this->r;
		$prev_c = $this->c;
		
		$this->Zdejmij ( $tablica );
		
		switch ($kierunek) {
			case 'up' :
				-- $this->r;
				break;
			case 'down' :
				++ $this->r;
				break;
			case 'right' :
				++ $this->c;
				break;
			case 'left' :
				-- $this->c;
				break;
			default :
				;
				break;
		}
		if ($this->r < 1) {
			$this->r = 1;
		}
		if ($this->r + $this->h - 1 > $maxRow) {
			$this->r = $maxRow - $this->h + 1;
		}
		if ($this->c < 1) {
			$this->c = 1;
		}
		if ($this->c + $this->w - 1 > $maxCol) {
			$this->c = $maxCol - $this->w + 1;
		}
		
		if ($this->Zajete ( $tablica )) {
			$this->r = $prev_r;
			$this->c = $prev_c;
		}
		
		$this->Ustaw ( $tablica );

		return  ( ($prev_r != $this->r)
				||($prev_c != $this->c)
				?1:0);
	}
	function Trafiony($row, $col) {
		if (($row >= $this->r) && ($row <= $this->r + $this->h - 1) && ($col >= $this->c) && ($col <= $this->c + $this->w - 1)) {
			return true;
		}
		return false;
	}
	function Color($row, $col, $color) {
		if ($this->Trafiony ( $row, $col )) {
			return $this->color;
		}
		return $color;
	}
	function GetNumber($row, $col, $nr) {
		if ($this->Trafiony ( $row, $col )) {
			return $this->nr;
		}
		return $nr;
	}
	function GetPicture($row, $col, $picture) {
		if ($this->Trafiony ( $row, $col )) {
			return $this->picture;
		}
		return $picture;
	}
}
class Ukladanka {
	private $tablica = array ();
	private $klocki = array ();
	private $maxRow = 4;
	private $maxCol = 5;
	private $maxSize = 164;
	private $space = '';
	private $bgcolor = 'lightgray';
	private $klocekAktywny = 0;
	function __construct() {
		if ($_SESSION ['tablica']) {
			$this->tablica = unserialize ( $_SESSION ['tablica'] );
		}
		
		if ($_SESSION ['klocki']) {
			$this->klocki = unserialize ( $_SESSION ['klocki'] );
		} else {
			$this->Start ();
		}
		
		if ($_SESSION ['klocekAktywny']) {
			$this->klocekAktywny = $_SESSION ['klocekAktywny'];
		} else {
			$_SESSION ['klocekAktywny'] = $this->klocekAktywny;
		}
	}
	function Start() {
		$this->klocki [] = new Klocek ( $this->tablica, 1, 1, 2, 1, 1, 'yellowH.png' );
		$this->klocki [] = new Klocek ( $this->tablica, 1, 4, 2, 1, 2, 'yellowH.png' );
		$this->klocki [] = new Klocek ( $this->tablica, 2, 1, 2, 2, 3, 'red.png' );
		$this->klocki [] = new Klocek ( $this->tablica, 2, 3, 1, 2, 4, 'yellowV.png' );
		$this->klocki [] = new Klocek ( $this->tablica, 2, 4, 1, 1, 5, 'blue.png' );
		$this->klocki [] = new Klocek ( $this->tablica, 2, 5, 1, 1, 6, 'blue.png' );
		$this->klocki [] = new Klocek ( $this->tablica, 3, 4, 1, 1, 7, 'blue.png' );
		$this->klocki [] = new Klocek ( $this->tablica, 3, 5, 1, 1, 8, 'blue.png' );
		$this->klocki [] = new Klocek ( $this->tablica, 4, 1, 2, 1, 9, 'yellowH.png' );
		$this->klocki [] = new Klocek ( $this->tablica, 4, 4, 2, 1, 10, 'yellowH.png' );
		$_SESSION ['tablica'] = serialize ( $this->tablica );
		$_SESSION ['klocki'] = serialize ( $this->klocki );
	}
	function Move($kierunek) {
		$ruch=$this->klocki[$this->klocekAktywny]->Move( $kierunek, $this->tablica, $this->maxRow, $this->maxCol );
		$_SESSION['tablica'] = serialize ( $this->tablica );
		$_SESSION['klocki'] = serialize ( $this->klocki );
		@$_SESSION['counter']+=$ruch;
		$this->Show($_SESSION['counter']);
	}
	function Aktywuj($numerKlocka) {
		$this->klocekAktywny = $numerKlocka - 1;
		$_SESSION ['klocekAktywny'] = $this->klocekAktywny;
		$this->Show ();
	}
	function Akcja($akcja) {
		if ($akcja == 'clear') {
			unset($this->tablica);
			unset($this->klocki);
			unset($_SESSION ['tablica']);
			unset($_SESSION ['klocki']);
			unset($_SESSION['counter']);
			$this->Start ();
		}
		$this->Show ();
	}
	function Show($counter) {
		foreach ( $this->klocki as $klocek ) {
			echo "<div ";
			$border = "";
			if ($klocek == $this->klocki [$this->klocekAktywny]) {
				$border = "background-color: black";
			} else {
				echo "onmouseover='$(\"#tabela\").load(\"refresh.php\",\"aktywacja={$klocek->nr}\"); return false;'";
// 				echo "onclick='alert({$klocek->nr})'";
			}
			echo "      style='
							position: absolute; 
							left:" . ($this->maxSize * ($klocek->c - 1) + 70) . "px; 
							top:" . ($this->maxSize * ($klocek->r - 1) + 70) . "px; 
							$border
						'>
						<img src='{$klocek->picture}'/>
			</div>\n
			<script type='text/javascript'>\n
				$('#counter').text($counter);\n
			</script>\n";
		}
	}
}