class Nectar.Widget.NowPlaying : Gtk.Box {
	public Nectar.Widget.Image image;
	private Gtk.Box _databox;
	public Gtk.Label title;
	public Gtk.Label subtitle;

	public NowPlaying () {
		this.image = new Nectar.Widget.Image();
		this.image.max_height = 60;
		this.pack_start(this.image);

		this._databox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		this.pack_end(this._databox);

		this.title = new Gtk.Label(null);
		this.subtitle = new Gtk.Label(null);
		this._databox.pack_start(this.title);
		this._databox.pack_end(this.subtitle);

		this.set_orientation(Gtk.Orientation.HORIZONTAL);
		this.height_request = 50;
		this.vexpand = false;
		this.vexpand_set = true;
	}
	public NowPlaying.with_anime_series (Nectar.Model.AnimeSeries anime) {
		this();
		this.set_anime_series(anime);
	}
	public void set_anime_series (Nectar.Model.AnimeSeries anime) {
		this.remove(this.image);
		this.image = new Nectar.Widget.Image.from_url(anime.cover_image);
		this.image.request_mode = Gtk.SizeRequestMode.WIDTH_FOR_HEIGHT;
		this.image.height_request = 80;
		this.pack_start(this.image);

		this.title.set_label(anime.title);
		this.subtitle.set_label("Watching: Ep 1 of " + anime.episode_count.to_string());
	}
}