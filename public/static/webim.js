//custom
(function (webim) {
	var path = _IMC.path;
	webim.extend(webim.setting.defaults.data, _IMC.setting);

    //Set link target.
    
    webim.ui.chat.defaults.target = "_blank";
    webim.ui.notification.defaults.target = "_blank";

	webim.route({
		online: path + "online",
		offline: path + "offline",
		message: path + "message",
		presence: path + "presence",
		deactivate: path + "refresh",
		status: path + "status",
		setting: path + "setting",
		history: path + "history",
		clear: path + "clear_history",
		download: path + "download_history",
		members: path + "members",
		join: path + "join",
		leave: path + "leave",
		buddies: path + "buddies",
		notifications: path + "notifications"
	});
	webim.ui.emot.init({ "dir": "/static/images/emot/default" });
	var soundUrls = {
		lib:  "/static/assets/sound.swf",
		msg:  "/static/assets/sound/msg.mp3"
	};
	var ui = new webim.ui(document.body, {
		imOptions: {
			jsonp: _IMC.jsonp
		},
        soundUrls: soundUrls,
        buddyChatOptions: {
          simple: !_IMC['is_login']
        }
	}), im = ui.im;

	if( _IMC.user ) im.setUser( _IMC.user );
	if( _IMC.menu ) ui.addApp("menu", { "data": _IMC.menu } );
	if( _IMC.enable_shortcut ) ui.layout.addShortcut( _IMC.menu );

	ui.addApp("buddy", {
		showUnavailable: _IMC.showUnavailable,
		is_login: _IMC['is_login'],
		disable_login: true,
        simple: !_IMC['is_login'],
        loginOptions: _IMC['login_options']
	});
	if( _IMC.enable_room )ui.addApp("room", { discussion: false });
	if( _IMC.enable_noti )ui.addApp("notification");
	ui.addApp("setting", { "data": webim.setting.defaults.data });
    if (_IMC.enable_chatlink) ui.addApp("chatlink2");
    ui.render();
	_IMC['is_login'] && im.autoOnline() && im.online();
})(webim);
