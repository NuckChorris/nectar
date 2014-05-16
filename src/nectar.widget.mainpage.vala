class Nectar.Widget.MainPage : Gtk.Box {
	private Nectar.Widget.NowPlaying _nowplaying = new Nectar.Widget.NowPlaying();
	private Gtk.ScrolledWindow _buttfuck = new Gtk.ScrolledWindow(null, null);
	private Nectar.Widget.PrefsBar _prefs_bar = new Nectar.Widget.PrefsBar();
	public MainPage () {
		this.orientation = Gtk.Orientation.VERTICAL;
		this.pack_start(this._nowplaying, false);
		this.pack_start(this._buttfuck, true);
		this.pack_end(this._prefs_bar, false);

		var series = Nectar.Model.AnimeSeries();
		series.title = "Puella Magi Madoka Magica";
		series.episode_count = 17;
		series.cover_image = "http://static.hummingbird.me/anime/poster_images/000/005/853/large/5853.jpg?1383496800";

		this._nowplaying.set_anime_series(series);
	}
}
