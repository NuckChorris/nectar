[GtkTemplate (ui = "/com/plejeck/nectar/MainPage.ui")]
class Nectar.Widget.MainPage : Gtk.Box {
	[GtkChild]
	public Nectar.Widget.NowPlaying nowplaying;
	[GtkChild]
	public Gtk.ScrolledWindow grid;
	[GtkChild]
	public Nectar.Widget.PrefsBar prefsbar;
	public MainPage () {
		var series = Nectar.Model.AnimeSeries();
		series.title = "Puella Magi Madoka Magica";
		series.episode_count = 17;
		series.cover_image = "http://static.hummingbird.me/anime/poster_images/000/005/853/large/5853.jpg?1383496800";

		nowplaying.set_anime_series(series);
	}
}
