cgi_begin 'uimods ...'
echo '<pre>Processing ...'

. /var/env.mod.daemon
#
echo "done."

echo '</pre>'
back_button mod system
cgi_end
