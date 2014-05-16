class Nectar.Widget.LoginPage : Gtk.Box {
	private Gtk.Entry _username_entry;
	private Gtk.Entry _password_entry;
	private Gtk.Button _login_button;
	private Gtk.Label _register_link;
	public LoginPage () {
		this.halign = Gtk.Align.CENTER;
		this.valign = Gtk.Align.CENTER;
		this.set_orientation(Gtk.Orientation.VERTICAL);

		this._username_entry = new Gtk.Entry();
		this._username_entry.placeholder_text = "Username";
		this.add(this._username_entry);

		this._password_entry = new Gtk.Entry();
		this._password_entry.placeholder_text = "Password";
		this._password_entry.visibility = false;
		this.add(this._password_entry);

		this._login_button = new Gtk.Button.with_label("Login");
		this.add(this._login_button);

		this._register_link = new Gtk.Label("Or <a href=\"http://hummingbird.me/\">Register</a>");
		this._register_link.use_markup = true;
		this.add(this._register_link);
	}
	public LoginPage.with_username (string username) {
		this();
		this._username_entry.text = username;
	}
}
