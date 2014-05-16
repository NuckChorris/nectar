class Nectar.Widget.LoginPage : Gtk.Box {
	private Gtk.Entry _username_entry = new Gtk.Entry();
	private Gtk.Entry _password_entry = new Gtk.Entry();
	private Gtk.Button _login_button = new Gtk.Button.with_label(_("Login"));
	private Gtk.Label _register_link = new Gtk.Label(_("Or <a href=\"http://hummingbird.me/\">Register</a>"));
	public LoginPage () {
		this.halign = Gtk.Align.CENTER;
		this.valign = Gtk.Align.CENTER;
		this.set_orientation(Gtk.Orientation.VERTICAL);

		this.add(this._username_entry);
		this.add(this._password_entry);
		this.add(this._login_button);
		this.add(this._register_link);

		this._register_link.use_markup = true;
		this._username_entry.placeholder_text = C_("Login", "Username");
		this._password_entry.placeholder_text = C_("Login", "Password");
		this._password_entry.visibility = false;
	}
	public LoginPage.with_username (string username) {
		this();
		this._username_entry.text = username;
	}
}
