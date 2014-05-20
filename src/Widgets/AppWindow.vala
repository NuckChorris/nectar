class Nectar.Widget.AppWindow : Gtk.Window {
	private Gdk.Geometry _hints = Gdk.Geometry();
	private Gtk.Overlay _overlay = new Gtk.Overlay();
	private Gtk.Image _throbber = new Gtk.Image.from_resource("/com/PLejeck/Nectar/throbber.gif");
	public AppWindow () {
		this._hints.base_width = 300;
		this._hints.min_width = 300;
		this._hints.max_width = 300;
		this._hints.base_height = 400;
		this._hints.min_height = 300;
		this._hints.max_height = 600;

		this.title = C_("App Name", "Nectar");
		this.set_geometry_hints(this, this._hints, Gdk.WindowHints.MIN_SIZE | Gdk.WindowHints.MAX_SIZE | Gdk.WindowHints.BASE_SIZE);
		this.border_width = 0;
		this.set_default_size(300, 400);

		this.destroy.connect(Gtk.main_quit);

		var stack = new Gtk.Stack();
		stack.homogeneous = true;
		stack.transition_type = Gtk.StackTransitionType.SLIDE_DOWN;
		this._overlay.add(stack);
		this.add(_overlay);

		var login = new Nectar.Widget.LoginPage();
		stack.add_named(login, "login-page");
		stack.visible_child_name = "login-page";

		login.login.connect(() => {
			stdout.printf("Username: %s\nPassword: %s\n", login.username, login.password);
			stack.visible_child_name = "main-page";
		});

		var mainpage = new Nectar.Widget.MainPage();
		mainpage.border_width = 0;
		stack.add_named(mainpage, "main-page");
	}
}
