class Nectar.Widget.PrefsBar : Gtk.HeaderBar {
	private Gtk.ToggleButton _list_btn = new Gtk.ToggleButton.with_label(C_("View Mode", "List"));
	private Gtk.ToggleButton _grid_btn = new Gtk.ToggleButton.with_label(C_("View Mode", "Grid"));
	private Gtk.ToggleButton _scrobble_btn = new Gtk.ToggleButton.with_label(C_("View Mode", "Scrobble"));
	private Gtk.MenuButton _prefs_btn = new Gtk.MenuButton();
	public PrefsBar () {
		this.pack_start(this._list_btn);
		this.pack_start(this._grid_btn);
		this.pack_end(this._scrobble_btn);

		var menu = new Nectar.Widget.PrefsMenu();
		this._prefs_btn.popup = menu;
		this.pack_end(this._prefs_btn);
	}
}
