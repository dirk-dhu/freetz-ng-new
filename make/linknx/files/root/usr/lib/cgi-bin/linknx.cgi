#!/bin/sh


. /usr/lib/libmodcgi.sh

check "$LINKNX_ENABLED" yes:auto "*":man

sec_begin '$(lang de:"Starttyp" en:"Start type")'

cat << EOF
<p>
<input id="e1" type="radio" name="enabled" value="yes"$auto_chk><label for="e1">$(lang de:"Automatisch" en:"Automatic")</label>
<input id="e2" type="radio" name="enabled" value="no"$man_chk><label for="e2">$(lang de:"Manuell" en:"Manual")</label>
</p>
EOF

sec_end
sec_begin '$(lang de:"Linknx" en:"Linknx")'
cat << EOF
<p>$(lang de:"Die Oberfl&auml;che kann" en:"You and open the site") <b><a style='font-size:14px;' target='_blank' href=/linknx/index.php>$(lang de:"hier" en:"here")</a></b>$(lang de:" ge&ouml;ffnet werden." en:".")<p>
EOF
sec_end
sec_begin '$(lang de:"Hinweise" en:"Hints")'
cat << EOF
$(lang de:"Das linknx.xml Dokument muss um die EIB/KNX Objekte erg&auml;nzt werden, dies ist am leichtesten mit folgender " 
en:"The linknx.xml document has to be extended by the according EIB/KNX objects, this can be best done by following the ")
<b><a style='font-size:14px;' target='_blank' href=http://sourceforge.net/p/linknx/wiki/Create_linknx_object_definitions_from_ETS_group-address_exports/>$(lang de:"Anleitung" en:"tutorial")</a></b>
$(lang de:" nachzuvollziehen." en:".")
</p>
<hr>
<p>$(lang de:"Desweiteren muss das linknx.php Dokument um Querverweise von den Objekten zu der HTML Schaltern erg&auml;nzt werden, &auml;hnlich wie: " 
en:"Furtheron the linknx.php document has to be extended by references between objects and HTML switches, similar to the following pattern: ")
</p>
<p style="font-size:10px;">&lt;object id=&quot;Bad Licht Decke&quot; gad=&quot;0/0/1&quot; type=&quot;1.001&quot; flags=&quot;cwtus&quot;&gt;Bad Licht Decke&lt;/object&gt; -&gt;<br> 
switching(&#36;fp, &quot;Bad Licht Decke&quot;, &quot;Bad Licht Decke&quot;); 

EOF
sec_end

