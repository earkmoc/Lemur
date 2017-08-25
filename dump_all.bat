call dump.bat Lemur2
call dump.bat Inez2016a
call dump.bat Inez2016DOS
call dump.bat MAKLER_162
call dump.bat MASTER2005
call dump.bat MASTER2006
call dump.bat MP2008
call dump.bat Lemur
call dump.bat Prosp
call dump.bat Prosper2017
call dump.bat Prosper2016

call dump.bat Arkom2017
call dump.bat Dorota2017
call dump.bat KS2017
call dump.bat AM2017
call dump.bat MAKLER2017
call dump.bat Anna2017
call dump.bat Jan2017
call dump.bat JL2017
call dump.bat ULEV2017
call dump.bat ML2017
call dump.bat MAKLER_17k
call dump.bat Inez2017
call dump.bat Inez2016
call dump.bat Inez2015
call dump.bat Inez2014

call dump.bat Arkom2016
call dump.bat Dorota2016
call dump.bat AK2011
call dump.bat AK2012
call dump.bat AK2013
call dump.bat AM2016
call dump.bat KS2016
call dump.bat MAKLER2016
call dump.bat MAKLER_16k
call dump.bat ML2016
call dump.bat Anna2016
call dump.bat Jan2016
call dump.bat JL2016
call dump.bat ULEV2016

call dump.bat AM2015
call dump.bat Anna2015
call dump.bat Jan2015
call dump.bat JL2015
call dump.bat ULEV2015
call dump.bat KS2015
call dump.bat MAKLER2015
call dump.bat MAKLER_15k

call dump.bat AM2014
call dump.bat Anna2014
call dump.bat Jan2014
call dump.bat JL2014
call dump.bat ULEV2014
call dump.bat KS2014
call dump.bat MAKLER2014
call dump.bat MP2014
call dump.bat ARKOM2014
call dump.bat ETNA2014

call dump.bat AK2013
call dump.bat AM2013
call dump.bat Anna2013
call dump.bat ARKOM2013
call dump.bat ETNA2013
call dump.bat Jan2013
call dump.bat JL2013
call dump.bat KS2013
call dump.bat MAKLER2013
call dump.bat MP2013
call dump.bat ULEV2013

call dump.bat AK2012
call dump.bat AM2012
call dump.bat ARKOM2012
call dump.bat ETNA2012
call dump.bat JL2012
call dump.bat KS2012
call dump.bat MAKLER2012
call dump.bat MAKLER_12o
call dump.bat MP2012
call dump.bat PR2012

call dump.bat AK2011
call dump.bat AM2011
call dump.bat ETNA2011
call dump.bat JL2011
call dump.bat KS2011
call dump.bat MAKLER2011
call dump.bat MP2011
call dump.bat PR2011

call dump.bat AM2010
call dump.bat ETNA2010
call dump.bat JL2010
call dump.bat KS2010
call dump.bat MAKLER2010
call dump.bat MP2010

call dump.bat AM2009
call dump.bat ETNA2009
call dump.bat JL2009
call dump.bat KS2009
call dump.bat MAKLER2009
call dump.bat PR2009

call dump.bat AM2008
call dump.bat ETNA2008
call dump.bat JL2008
call dump.bat KS2008
call dump.bat MAKLER2008
call dump.bat PR2008

call dump.bat AM2007
call dump.bat PR2007

call dump.bat ETNA2006
call dump.bat MAKLER2006
call dump.bat PR2006

call dump.bat ETNA2005
call dump.bat MAKLER2005
call dump.bat PR2005

call dump.bat CDO2004
call dump.bat ETNA2004
call dump.bat PR2004

call dump.bat ETNA2003
call dump.bat ETNA2002
call dump.bat ETNA2001
call dump.bat PR2001

call dump.bat Slucham2000
call dump.bat Slucham2001
call dump.bat Slucham2002
call dump.bat Slucham2003
call dump.bat Slucham2004
call dump.bat Slucham2005
call dump.bat Slucham2006
call dump.bat Slucham2007
call dump.bat Slucham2008
call dump.bat Slucham2009
call dump.bat Slucham2010
call dump.bat Slucham2011
call dump.bat Slucham2012
call dump.bat Slucham2013
call dump.bat Slucham2014

call dump.bat Profitland2013
call dump.bat Profitland2014
call dump.bat Profitland2015

"C:\Program Files\7-Zip\7z.exe" a -m0=Copy -sdel \Archiwa\BazaDanych_%date:~0,13%_%RANDOM%.7z *Dump.7z 
"C:\Program Files\7-Zip\7z.exe" a -p223 \Archiwa\Program_Lemur2_%date:~0,13%_%RANDOM%.7z Lemur* bootstrap* *.php *.bat

echo .
echo .
echo ******************************************************************************
echo **                                                                          **
echo ** Archiwizacja bazy danych i programu wykonana. Wszystko jest w C:\Archiwa **
echo **                                                                          **
echo ******************************************************************************
echo .
pause
