<?php
		$z=str_replace('ID_master',$ipole,$z);
		$z=str_replace('DB_master',"'$baza'",$z);
		$z=str_replace('tab_master',$batab,$z);
		$z=str_replace('zaznaczone',$zaznaczone,$z);
		$z=str_replace('osoba_id',$_SESSION['osoba_id'],$z);
		$z=str_replace('osoba_pu',$_SESSION['osoba_pu'],$z);
		$z=@str_replace('[lp]',$lps,$z);
		$z=@str_replace('[lp2]',$lps2,$z);
		$z=@str_replace('[lp22]',$lps2+floor((2*$lps2max+1)/2),$z);	//+floor(($lps2max+1)/2)
		$lpr=@$lps2+floor((2*@$lps2max+1)/2)-1;
		$lpr=(($lpr<0)?0:$lpr);
		$z=str_replace('[lp22_1]',$lpr,$z);
		if ($z=='osoba_upr') {$qs[0]=$_SESSION['osoba_upr'];
		} elseif ($z=='lp') {$qs[0]=$lps+1;
		} else {
			$qq=explode(';',$z);	//mo¿e byæ kilka zapytañ ¿eby ustaliæ iloœæ wierszy
			$i=0;
			do {
				if (count($buf_n=explode(',(*)',$qq[$i]))>1) {	//sam zdob¹dŸ listê pól
					$buf_n=$buf_n[1]*1;			//od n-tego pola
					$buf=explode('from ',$qq[$i]);
					$buf=explode(' ',$buf[1]);
					$buf=$buf[0];			//tabela
					$buf="show fields from $buf";	//nazwy pól w "Field", potem "Type (int(11))", "Null (YES)", "Key (PRI)", "Default", "Extra (auto_increment)"
					$buf=mysqli_query($link,$buf);
					$buf_s='';
					$buf_i=0;
					while ($buf_r=mysqli_fetch_row($buf)) {
						$buf_i++;
						if ($buf_i>=$buf_n) {$buf_s.=','.$buf_r[0];}	//lista pól od n-tego
					}
					$qq[$i]=str_replace(',(*)'.trim($buf_n),$buf_s,$qq[$i]);
				}
//echo $qq[$i].': ';
				$qqs=mysqli_query($link,$q=$qq[$i]);	//kolejne zapytanie
				if (mysqli_error($link)) {
					$i++;
					//die(mysqli_error($link).'<br>'.$q.'<br>'.$z);
				}
				elseif (strtoupper(substr(trim($qq[$i]),0,6))=='SELECT') {	//jeœli typu "SELECT"
					$qs=mysqli_fetch_row($qqs);			//to coœ zwraca
					$i++;
					if ($i<count($qq)) {				//jeœli s¹ nastêpne, to
						for ($j=0;$j<count($qs);$j++) {		//korzystaj¹ ze swoich wyników
							$qq[$i]=str_replace('['.$j.']',$qs[$j],$qq[$i]);
						}
					}
				} else {
					$i++;
				}
			} while ($i<count($qq));
		}
//echo $qs[0].'<br>';
		$qs[0]=StripSlashes($qs[0]);
		if ($n=='"s³ownie"')	 {$qs[0]=Slownie($qs[0],'',1).' i '.Slownie($qs[0],'',2).'/100 z³.';}
		if ($n=='"s³ownie_ang"') {$qs[0]=SlownieAng($qs[0],'',1).', '.Slownie($qs[0],'',2).'/100';}
		if ($f) {	// format: "%' +30s"
			if (substr($f,3,1)=='+') {		//centrowanie
				$x=substr($f,4);				//30
				$qs[0]=substr(trim($qs[0]),0,$x);
				$qs[0]=str_pad($qs[0],$x,substr($f,2,1),STR_PAD_BOTH);
				$wr=str_replace($n,$qs[0],$wr);
			} elseif ($f=='w') {		//waluta
				$wr=str_replace($n,number_format($qs[0],2,'.',','),$wr);
			} else {
				$wr=str_replace($n,sprintf($f,$qs[0]),$wr);
			}
		} else {
			$wr=str_replace($n,$qs[0],$wr);
		}
?>