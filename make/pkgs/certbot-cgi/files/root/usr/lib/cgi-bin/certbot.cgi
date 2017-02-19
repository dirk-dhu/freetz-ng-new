#!/bin/sh
[ -r /etc/options.cfg ] && . /etc/options.cfg

. /usr/lib/libmodcgi.sh

check "$CERTBOT_ENABLED" yes:auto "*":man
check "$CERTBOT_STARTONCE" yes:startonce "*":renew
check "$CERTBOT_TEST" yes:test
check "$CERTBOT_CHALLENGE" http-01:http tls-alpn-01:https dns-01:dns 

sec_begin '$(lang de:"Starttyp" en:"Start type")'

cat << EOF
<p>
<input id="e1" type="radio" name="enabled" value="yes"$auto_chk><label for="e1">$(lang de:"Automatisch" en:"Automatic")</label>
<input id="e2" type="radio" name="enabled" value="no"$man_chk>  <label for="e2">$(lang de:"Manuell" en:"Manual")</label>
</p>
EOF

sec_end
sec_begin '$(lang de:"Bevorzugte Challenge" en:"Preferred challenge")'


cat << EOF
<p>
<input id="e3" type="radio" name="challenge" value="tls-alpn-01"$https_chk><label for="e3">$(lang de:"TLS-ALPN-01" en:"TLS-ALPN-01")</label>
<input id="e2" type="radio" name="challenge" value="http-01"$http_chk>    <label for="e2">$(lang de:"HTTP-01" en:"HTTP-01")</label>
EOF
if [ "$FREETZ_PACKAGE_CERTBOT_CGI_WITH_DNS_CHALLENGE" = 'y' ]; then
cat << EOF
<input id="e1" type="radio" name="challenge" value="dns-01"$dns_chk>      <label for="e1">$(lang de:"DNS-01" en:"DNS-01")</label>
EOF
fi
cat << EOF
</p>
EOF

sec_end
sec_begin '$(lang de:"CERTBOT SSL/TLS update damon" en:"CERTBOT SSL/TLS update damon")'

cat << EOF
<p>$(lang de:"Wenn dieser Service aktiviert ist, dann wird in der Monatsmitte das SSL/TLS Zertifikat automatisch mittles eines CRON Eintrages erneuert." 
          en:"If this service is enabled, then the SSL/TLS certificate will be automatically updated via a cron entry.")<br>
<p>$(lang de:"Bitte beachten: Certbot &ouml;ffnet tempor&auml;r auf den in Apache eingestellten SSL Port (oder Port 443) einen Webserver, um das produzierte Zertifikat zu verifizieren.
              Damit das klappt, muss der Port im AVM Forwarding freigeben werden, wenn apache nicht konfiguriert wird, wird er port 10443 benutzt!" 
          en:"Please remember, that certbot opens temporary a web service on the same port as used in Apache or port 443, to verify the created certificate.
              In order for that, you have to create a port forwarding using the AVM Forwarding admin page from 443 to 10443 or apache port!")<br>
<p> $(lang de:"SSL Port" en:"SSL port"): <input type="text" name="sslport" size="5" maxlength="5" value="$(html "$CERTBOT_SSLPORT")"></p>
<p>$(lang de:"Wenn HTTP als bevorzugte Challenge genommen wird, wird ein http server auf dem Port auf den in Apache eingestellten HTTP Port oder 8081 gestartet, d.h. AVM-Forwarding vom Port 80 auf den untrigen Port muss vorhanden sein. Zus&auml;tzlich muss noch der AVM Web Interface Port in der Sektion websrv von ar7.cfg auf eien anderen port gelegt werden, ansonsten kann der Port nicht forwarded werden." 
          en:"Please remember, that certbot opens temporary a web service on the same port as used in Apache or port 8081, to verify the created certificate.
              In order for that, you have to create a port forwarding using the AVM Forwarding admin page from 80 to below port! In addition you have to change the AVM web interface port in ar7.cfg file in section websrv, otherwise the forwarding can not use port 80.")<br>
<p> $(lang de:"HTTP Port" en:"HTTP port"): <input type="text" name="httpport" size="5" maxlength="5" value="$(html "$CERTBOT_HTTPPORT")"></p>
EOF
if [ "$FREETZ_PACKAGE_CERTBOT_CGI_WITH_DNS_CHALLENGE" = 'y' ]; then
cat << EOF
<p>$(lang de:"Wenn DNS als bevorzugte Challenge genommen wird, wird intern dnsmasq auf dem port 5353 gestartet, d.h. AVM-Forwardingvom port 53 auf den Port 5353 muss vorhanden sein." 
          en:"If DNS challenge is selected, then dnsmasq is started on port 15353, to verify the created certificate. 
              In order for that, you have to create a port forwarding using the AVM Forwarding admin page from port 53 to 15353!")<br>
<p> $(lang de:"DNS Port" en:"DNS port"): <input type="text" name="dnsport" size="5" maxlength="5" value="$(html "$CERTBOT_DNSPORT")"></p>
EOF
fi
cat << EOF
<p style="font-size:12px;">$(lang de:"Zum manuellen Update der SSL Zertifikate, kann folgender Knopf gedr&uuml;ckt werden." en:"To update manual please press following botton.")</p>
<input id="p1" type="radio" name="startonce" value="yes"$startonce_chk><label for="p1">$(lang de:"Aktualisiere einmal?" en:"Update once?")</label><br>
<input id="p2" type="radio" name="startonce" value="no"$renew_chk><label for="p2">$(lang de:"Aktualisiert!" en:"Updated!")</label>
<p style="font-size:10px;">
$(lang de:"Einmalig muss man manuell das Zertifikat mit obigen Knopf anlegen. F&uuml;r Versuche immer ein Testzertifikat benutzen!" 
       en:"Once you have to create manually the certificate using above botton. For trials you have to use a test certifcate!")</p>
<p><input type="hidden" name="test" value="no">
<input id="u1" type="checkbox" name="test" value="yes"$test_chk><label for="u1"> $(lang de:"Certbot mit Testzertifikate ausprobieren" en:"Try certbot using test certificates")</label>
</p>
EOF

sec_end
