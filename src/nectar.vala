int main (string[] args) {
	Gtk.init(ref args);

	var window = new Gtk.Window();
	window.title = C_("App Name", "Nectar");
	window.border_width = 10;
	window.window_position = Gtk.WindowPosition.CENTER;
	window.set_default_size (350, 70);
	window.destroy.connect (Gtk.main_quit);

	var session = new Soup.Session();
	session.max_conns = 10;
	session.max_conns_per_host = 6;
	session.user_agent = "Nectar/0.1.0 (+http://nuckchorris.github.io/nectar/)";

	var cache = new Soup.Cache(Path.build_filename(Environment.get_user_cache_dir(), "nectar", "_soup"), Soup.CacheType.SINGLE_USER);
	session.add_feature(cache);

	try {
		var series = new Nectar.Model.AnimeSeries();
		series.title = "Puella Magi Madoka Magica";
		series.episode_count = 17;
		series.cover_image = "http://static.hummingbird.me/anime/poster_images/000/005/853/large/5853.jpg?1383496800";

		var nowplaying = new Nectar.Widget.NowPlaying.with_anime_series(series);
		window.add (nowplaying);
	} catch (Error e) {
		stderr.printf("%s\n", e.message);
	}
	window.show_all ();

	Gtk.main ();
	return 0;
}
