#!/bin/sh
. /usr/lib/libmodcgi.sh
cgi --id=uimods


# for x in $(ctlmgr_ctl u | sed '1,2d'); do echo; ctlmgr_ctl u $x; done | tee uimods.txt
uimods_listing() {
cat << EOX
	avm_pa:enable					0|1					AVM Packet Accelerator
	box:allow_security_report_with_manufacturer	0|1					Ihre FRITZ!Box ist f&uuml;r AVM erreichbar, um ausgew&auml;hlte Diagnosedaten oder eine Diagnosezusammenfassung abzurufen.
	box:allow_background_comm_with_manufacturer	0|1					FRITZ!Box sucht periodisch nach Updates
	box:allow_cross_domain_comm			0|1					Bei Aufruf von www.avm.de darf AVM ger&auml;tespezifische Daten Ihrer FRITZ!Box auslesen
	box:button_events_disable			0|1					Tastensperre
	box:signed_firmware				0|1					Nagt mit Link zu hilfe_nichtsigniert.html in der Diagnose und macht sonstwas damit
	boxusers:twofactor_auth_enabled			0|1					Nervige Zwei-Faktor Authentifizierung
	emailnotify:crashreport_mode			to_support_only|disabled_by_user	Fehlerberichte automatisch an AVM senden
	eth_ports:eee_off_for_all_ports			0|1					Energy Efficient Ethernet DEAKTIVIEREN
	meshd:loop_prevention_state			0|1					Netzwerkschleifenverhinderung
	sar:gpon_ploam_password				|					GPON ONT-Installationskennung
	sar:gpon_reg_id					|					GPON Registrierungs-ID
	sar:gpon_serial					|					GPON Seriennummer
	sar:Annex					A|B
	sar:vlan_id					0|7|8					PPPoE Vlan-ID
	sar:MaxDownstreamRate
	sar:MaxUpstreamRate
	sar:DownstreamMarginOffset			-4|-3|-2|-1|0|1|2|3|4
	sar:UpstreamMarginOffset			-4|-3|-2|-1|0|1|2|3|4
	sipextra:gui_readonly				0|1					Neue Rufnummer SPERREN
	tr369:enable					0|1					Fernadministration des LAN durch den Provider
	tr069:LabSupportEnable				0|1
	tr069:LabUploadReqEnable			0|1
	tr069:ACSInitiation_enable			0|1
	tr069:suppress_autoFWUpdate_notify		0|1
	tr069:fwupdate_available			0|1|2
	tr069:upload_enable				0|1
	tr069:FWdownload_enable				0|1
	updatecheck:auto_update_all_enabled		0|1
	updatecheck:auto_update_enabled			0|1
	updatecheck:auto_update_check_enabled		0|1
	updatecheck:auto_update_mode			update_all|update_important|check	neue FRITZ!OS-Versionen automatisch installieren
	webui:expertmode				0|1
	webui:ata_hidden				0|1
	webui:lanbridges_gui_hidden			0|1
	webui:voip_2ndPVC_hidden			0|1
	webui:country_gui_hidden			0|1
	webui:sid_timeout_minutes			20					$(lang de:"Akzeptiert keine &Auml;nderungen" en:"Does not accept changes")
	wlan:ap_enabled					0|1					Wlan AP 1 (2,4 Ghz)
	wlan:ap_enabled_scnd				0|1					Wlan AP 2 (5 GHz)
	wlan:ap_enabled_thrd				0|1					Wlan AP 3
	wlan:wps_enable					0|1					Wi-Fi Protected Setup
	wlan:guest_ap_enabled				0|1					Wlan Guest
EOX
}

uimods_request() {
	uimods_listing | while read -r a b; do
		modul="${a%%:*}"
		uikey="${a#$modul:}"
		[ "$uikey" == "${uikey//\//\ }" ] && uikey="settings/$uikey"
		echo -n "$modul $uikey "
	done
}

uimods_table() {
	local oldhr=""
	uimods_result="$(ctlmgr_ctl r -v $(uimods_request))"
	uimods_listing | sort | while read -r a vals desc; do
		modul="${a%%:*}"
		uikey="${a#$modul:}"
		[ "$uikey" == "${uikey//\//}" ] && uikey="settings/$uikey"
		[ "$oldhr" != "$modul" ] && table_head "$modul" "$oldhr" && oldhr="$modul"
		saved="$(echo "$uimods_result" | sed -n "s,^${modul}:${uikey} = ,,p")"
		table_line "$modul" "$uikey" "$saved" "${vals#|}" "$desc"
	done
	table_end
}


table_begin() {
	local modul="$1"
	sec_begin "$modul"
	echo "<table>"
#	echo "<th align='left'>Key</th>"
#	echo "<th align='left'>Value</th>"
#	echo "<th align='left'>Change</th>"
}

table_head() {
	local modul="$1"
	local oldhr="$2"
	[ -n "$oldhr" ] && table_end
	table_begin "$modul"
}

table_line() {
	local modul="$1"
	local uikey="$2"
	local saved="$3"
	local vals="$4"
	local desc="$5"
	local short="${uikey##*/}"
	local htmlid="uimod_${modul}__${short}"
	local listid="dlist_${modul}__${short}"
	local disabled=""
	[ "${uikey%%/*}" != "settings" ] && disabled="disabled"
	[ -n "$saved" -a -n "$vals" ] && items="$saved|$vals" || items="$saved$vals"

	echo "<tr>"
	echo "<form action='/cgi-bin/exec.cgi/uimods' method='post'>"

	echo "<td width='400'><b>$short</b></td>"

	echo "<td width='150'><input type='text' list='$listid' name='val' id='$htmlid' value='$saved' /> <datalist id='$listid'>"
	for x in $(echo "$items" | sed 's/|/\n/g' | sort -u); do echo "<option value='$x'>"; done
	echo "</datalist></td>";

	echo "<input type='hidden' name='mod' value='$modul'>"
	echo "<input type='hidden' name='key' value='$short'>"

	echo "<td width='100'><center> <input type='submit' name='cmd' value='&nbsp;$(lang de:"&auml;ndern" en:"change")&nbsp;' $disabled> </center></td>"

	echo "</form>"
	echo "</tr>"

	echo "<tr><td colspan='2'><font size=-2><i>${desc:+&num; $desc}</i></font></td></tr>"
}

table_end() {
	echo "</table>"
	sec_end
}


cgi_begin "$(lang de:"FOS UI-Module" en:"FOS UI-Modules")"
uimods_table
cgi_end

