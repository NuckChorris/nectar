[GtkTemplate (ui = "/com/plejeck/nectar/AppWindow.ui")]
class Nectar.Widget.AppWindow : Gtk.Window {
	[GtkChild]
	private Gtk.Stack stack;
	[GtkChild]
	private Nectar.Widget.LoginPage login_page;
	[GtkChild]
	private Nectar.Widget.MainPage main_page;

	public AppWindow () {
		var hints = Gdk.Geometry();
		hints.base_width = 300;
		hints.min_width = 300;
		hints.max_width = 300;
		hints.base_height = 400;
		hints.min_height = 300;
		hints.max_height = 600;

		set_geometry_hints(this, hints, Gdk.WindowHints.MIN_SIZE | Gdk.WindowHints.MAX_SIZE | Gdk.WindowHints.BASE_SIZE);

		destroy.connect(Gtk.main_quit);

		login_page.login.connect(() => {
			stdout.printf("Username: %s\nPassword: %s\n", login_page.username, login_page.password);
			stack.visible_child_name = "main-page";
		});
	}
}
