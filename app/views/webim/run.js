var _IMC = {
	production_name: 'rails',
	version: '5.1',
	path: '/webim/',
	is_login: true,
	user: {'id': '1', 'nick': 'user1'},
	setting: '',
	menu: '',
	enable_room: true,
	enable_noti: true,
	enable_chatlink: true,
	enable_shortcut: '',
	enable_menu: 'true',
	theme: 'base',
	local: 'zh-CN',
	min: window.location.href.indexOf("webim_debug") != -1 ? "" : ".min"
};

_IMC.script = window.webim ? '' : ('<link href="/static/webim.'+ _IMC.production_name + _IMC.min + '.css?' + _IMC.version + '" media="all" type="text/css" rel="stylesheet"/><link href="/static/themes/' + _IMC.theme + '/jquery.ui.theme.css?' + _IMC.version + '" media="all" type="text/css" rel="stylesheet"/><script src="/static/webim.' + _IMC.production_name + _IMC.min + '.js?' + _IMC.version + '" type="text/javascript"></script><script src="/static/i18n/webim-' + _IMC.local + '.js?' + _IMC.version + '" type="text/javascript"></script>');

_IMC.script += '<script src="/static/webim.js?' + _IMC.version + '" type="text/javascript"></script>';

document.write( _IMC.script );
