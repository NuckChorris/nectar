[GtkTemplate (ui = "/com/plejeck/nectar/AppWindow.ui")]
class Nectar.Widget.AppWindow : Gtk.Window {
	[GtkChild]
	public Gtk.Stack stack;
	[GtkChild]
	public Nectar.Widget.LoginPage login_page;
	[GtkChild]
	public Nectar.Widget.MainPage main_page;

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

	}
}
