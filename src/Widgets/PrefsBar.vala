[GtkTemplate (ui = "/com/plejeck/nectar/PrefsBar.ui")]
class Nectar.Widget.PrefsBar : Gtk.Box {
	[GtkChild]
	private Gtk.ToggleButton viewmode_list_btn;
	[GtkChild]
	private Gtk.ToggleButton viewmode_grid_btn;
	[GtkChild]
	private Gtk.ToggleButton scrobble_btn;
	[GtkChild]
	private Gtk.MenuButton prefs_btn;
}
