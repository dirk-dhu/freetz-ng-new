#!/bin/sh


. /usr/lib/libmodcgi.sh
[ -e /mod/etc/conf/certbot.cfg ] && . /mod/etc/conf/certbot.cfg

check "$APACHE2_ENABLED" yes:auto "*":man
check "$APACHE2_UNPRIV" yes:unpriv
check "$APACHE2_USECERTBOT" yes:usecertbot

sec_begin '$(lang de:"Starttyp" en:"Start type")'
cat << EOF
<p>
<input id="e1" type="radio" name="enabled" value="yes"$auto_chk><label for="e1"> $(lang de:"Automatisch" en:"Automatic")</label>
<input id="e2" type="radio" name="enabled" value="no"$man_chk><label for="e2"> $(lang de:"Manuell" en:"Manual")</label>
</p>
EOF
sec_end

sec_begin '$(lang de:"Zentrale Serverkonfiguration" en:"Core server configuration")'
cat << EOF
<p><input type="hidden" name="unpriv" value="no">
<input id="u1" type="checkbox" name="unpriv" value="yes"$unpriv_chk><label for="u1"> $(lang de:"Apache2 mit unpriviligierter Benutzer ID starten" en:"Start Apache2 with unprivileged user ID")</label></p>
<hr>
EOF
if [ "$CERTBOT_ENABLED" = 'yes' ]; then
cat << EOF
<p><input type="hidden" name="usecertbot" value="no">
<input id="u2" type="checkbox" name="usecertbot" value="yes"$usecertbot_chk><label for="u2"> $(lang de:"Benutze Certbot Zertifikate" en:"Use certbot certificate")</label></p>
<hr>
EOF
fi
cat << EOF
<p style="font-size:10px;">$(lang de:"Bitte gib hier den Speicherort f&uuml;r Apache2 Konfiguration an. Dieses Verzeichnis muss beschreibbar. Falls das Verzeichnis leer ist oder fehlt, wird automatisch die richtige Dateistruktur erstellt. Dieses Verzeichnis wird alle Konfigurationsdateien von Apache2 enthalten, welche manuell (oder via einem Webfrontend) bearbeitet werden m&uuml;ssen." en:"Please provide the storage location for Apache2 configuration. This directory must be writeable and exist. In case the directory is empty, the proper directory structure will be created. This directory will contain all configuration files for Apache2 which must be modified directly or via a web frontend.")</p>
<p> $(lang de:"Verzeichnis f&uuml;r Konfiguration" en:"Directory for configuration"): <input type="text" name="configlocation" size="30" maxlength="255" value="$(html "$APACHE2_CONFIGLOCATION")"></p>
<hr>
<p style="font-size:10px;">$(lang de:"Bitte gib hier den Speicherort f&uuml;r HTTP DOC ROOT an. Dieses Verzeichnis muss beschreibbar. Falls das Verzeichnis leer ist oder fehlt, wird automatisch die richtige Dateistruktur erstellt. Dieses Verzeichnis wird alle HTML Dokumente von Apache2 enthalten, welche manuell bearbeitet werden m&uuml;ssen." en:"Please provide the storage location for Apache2 http doc root. This directory must be writeable and exist. In case the directory is empty, the proper directory structure will be created. This directory will contain all http documents files for Apache2 which must be modified directly.")</p>
<p> $(lang de:"Verzeichnis f&uuml;r HTML Wurzel" en:"Directory for HTML root"): <input type="text" name="htdoclocation" size="30" maxlength="255" value="$(html "$APACHE2_HTDOCLOCATION")"></p>
<hr>
<p style="font-size:10px;">$(lang de:"Bitte gib hier den Speicherort f&uuml;r Log Dateien an. Dieses Verzeichnis muss beschreibbar sein und muss viel Speicherplatz f&uuml;r die Logs haben." en:"Please provide the storage location for log files. This directory must be writeable and must have enough space left for the logs.")</p>
<p> $(lang de:"Verzeichnis f&uuml;r Log Dateien" en:"Directory for log files"): <input type="text" name="loglocation" size="30" maxlength="255" value="$(html "$APACHE2_LOGLOCATION")"></p>
<hr>
<p style="font-size:10px;">$(lang de:"Bitte &auml;ndern Sie diese Werte nur wenn Sie wissen was Sie tun." en:"Please change these values only if you know what you are doing.")</p>
<p> $(lang de:"Startparameter" en:"Start parameters"): <input type="text" name="special" size="45" maxlength="255" value="$(html "$APACHE2_SPECIAL")"></p>
EOF
sec_end

sec_begin '$(lang de:"Angebotene Dienste" en:"Offered services")'
cat << EOF
<p style="font-size:10px;">$(lang de:"Bitte beachte: Wenn Apache2 mit einer unpriviligierten Benutzer-ID gestartet wird, m&uuml;ssen alle hier angegebenen Ports gr&ouml;sser oder gleich 1024 sein, da ansonsten der Dienst nicht startet. Um Dienste aus dem Internet zug&auml;nglich zu machen, musst du eine Port-Weiterleitung mit der Fritz!Box Firewall einrichten (z.B. von Port 80 auf der Internet-Seite zum Port 8080 auf der lokalen Seite)." en:"Please note: If Apache2 is started with an unprivileged user ID, all ports must be above or equal to 1024 as otherwise the service will not be started. To make services available from the Internet, please use the port forwarding with the Fritz!Box firewall (e.g. from port 80 on the Internet side to port 10080 on the local side.")</p>
<hr>
<p> $(lang de:"HTTP Port" en:"HTTP port"): <input type="text" name="port" size="5" maxlength="5" value="$(html "$APACHE2_PORT")"></p>
EOF
sec_end

sec_begin '$(lang de:"Hinzuf&uuml;gen/&auml;ndern eines Passwortes zu .htpasswd" en:"Add/change a password in .htpasswd")'
cat << EOF
<script type="text/javascript">
function checkAddUserPasswordClicked()
{
    if (document.getElementById("addUserPassword").value != "") {
       return true;
    }
    return false;
}
function createXMLObject() {
  var xmlhttp = null;
  try {
    if (window.XMLHttpRequest) {
      xmlhttp = new XMLHttpRequest();
    }
    // code for IE
    else if (window.ActiveXObject) {
      xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
  } catch (e) {}
  return xmlhttp;
}
function parseValuesOnClick()
{
    var field = {
      username: document.getElementById("apache2UserName").value,
      password: document.getElementById("apache2PassWord").value
    };
    var data = JSON.stringify(field);
    var request = createXMLObject();
    if(request!=null){
      var currentLocation = window.location;
      request.open('post', '/apache2/htpasswd.php', true);
      request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
      request.onreadystatechange = function(){
          if(this.readyState == 4){
              if(this.status == 200){
                  try {
                     document.write(this.responseText);
                  } catch(e) {
                     alert(this.responseText);
                  }
              }
              else{
                  alert("An error occurred! ("+this.statusText+")");
              }
              setTimeout(function(){
                  window.location.href=currentLocation;
              }, 7000);
          }
      }
      request.send('userNamePasswordData='+data);
   }
   else{
      alert("Your browser does not support Ajax!");
   }
}
</script>
<div id="toolbar">
<!--form name="AddUserPasswordForm" id="AddUserPasswordForm" action="/apache2/htpasswd.php" method="post" onsubmit="return checkAddUserPasswordClicked()" enctype="application/x-www-form-urlencoded"-->
<p style="font-size:10px;width:50px;">$(lang de:"Benutzername:" en:"Username:") <input type="text" size="15" id="apache2UserName" name="apache2UserName" class="apache2UserName"/></p>
<p style="font-size:10px;width:50px;">$(lang de:"Passwort:" en:":Password:") <input type="password" size="15" id="apache2PassWord" name="apache2PassWord" class="apache2PassWord"/></p>
<p style="font-size:10px;width:50px;"> <input type="button" name="addUserPassword" id="addUserPassword" value="$(lang de:"Hinzuf&uuml;gen" en:"Add")" onclick="parseValuesOnClick()"></p>
<!--/form-->
</div>
EOF
sec_end
