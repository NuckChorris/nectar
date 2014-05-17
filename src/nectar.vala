int main (string[] args) {
	Gtk.init(ref args);


	var settings = new Nectar.Util.Settings.from_data_dirs();

	var session = new Soup.Session();
	session.max_conns = 10;
	session.max_conns_per_host = 6;
	session.user_agent = "Nectar/0.1.0 (+http://nuckchorris.github.io/nectar/)";

	var cache = new Soup.Cache(Path.build_filename(Environment.get_user_cache_dir(), "nectar", "_soup"), Soup.CacheType.SINGLE_USER);
	session.add_feature(cache);

	var window = new Nectar.Widget.AppWindow();

	File cssfile = File.new_for_uri("resource:///com/PLejeck/Nectar/style.css");
	Gtk.CssProvider css = new Gtk.CssProvider();
	css.load_from_file(cssfile);
	Gtk.StyleContext.add_provider_for_screen(window.screen, css, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

	window.show_all ();

	Gtk.main ();
	return 0;
}
