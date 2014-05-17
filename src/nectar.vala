int main (string[] args) {
	Gtk.init(ref args);


	var session = new Soup.Session();
	session.max_conns = 10;
	session.max_conns_per_host = 6;
	session.user_agent = "Nectar/0.1.0 (+http://nuckchorris.github.io/nectar/)";

	var cache = new Soup.Cache(Path.build_filename(Environment.get_user_cache_dir(), "nectar", "_soup"), Soup.CacheType.SINGLE_USER);
	session.add_feature(cache);

	var window = new Nectar.Widget.AppWindow();

	window.show_all ();

	Gtk.main ();
	return 0;
}
