[GtkTemplate (ui = "/com/plejeck/nectar/NowPlaying.ui")]
class Nectar.Widget.NowPlaying : Gtk.Box {
	[GtkChild]
	private Nectar.Widget.Image poster;
	[GtkChild]
	public Gtk.Label title;
	[GtkChild]
	public Gtk.Label subtitle;

	public NowPlaying.with_anime_series (Nectar.Model.AnimeSeries anime) {
		this.set_anime_series(anime);
	}
	public void set_anime_series (Nectar.Model.AnimeSeries anime) {
		poster.set_from_url(anime.cover_image);

		title.set_label(anime.title);
		subtitle.set_label("Watching: Ep 1 of " + anime.episode_count.to_string());
	}
}
