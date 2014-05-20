class Nectar.Widget.PrefsMenu : Gtk.Menu {
	private MenuItem _about_item = new MenuItem(_("About Nectar"), null);
	private MenuItem _help_item = new MenuItem(_("Help with Nectar"), null);
	private MenuItem _logout_item = new MenuItem(_("Logout"), null);
	private MenuItem _bugreport_item = new MenuItem(_("Report Bug"), null);
	private MenuItem _featurereq_item = new MenuItem(_("Request Feature"), null);
	private MenuItem _feedback_item = new MenuItem(_("Give Feedback"), null);
	public PrefsMenu () {
		var help = new Menu();
		help.append_item(this._about_item);
		help.append_item(this._help_item);

		var feedback = new Menu();
		feedback.append_item(this._bugreport_item);
		feedback.append_item(this._featurereq_item);
		feedback.append_item(this._feedback_item);

		var user = new Menu();
		user.append_item(this._logout_item);

		var help_item = new MenuItem.section(null, help);
		var feedback_item = new MenuItem.section(null, feedback);
		var user_item = new MenuItem.section(null, user);

		var menu = new Menu();
		menu.append_item(help_item);
		menu.append_item(feedback_item);
		menu.append_item(user_item);

		this.bind_model(menu, null, true);
	}
}
