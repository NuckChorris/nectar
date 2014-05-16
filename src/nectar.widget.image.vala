class Nectar.Widget.Image : Gtk.Misc {
	private Cairo.Pattern _image;
	private int[] _imagesize;
	private Gtk.SizeRequestMode? _request_mode;
	private Cairo.Matrix _matrix {
		get {
			Cairo.Matrix matrix = Cairo.Matrix.identity();

			int width = get_allocated_width();
			int height = get_allocated_height();

			matrix.scale(1, 1);

			return matrix;
		}
	}
	public new Gtk.SizeRequestMode get_request_mode () {
		// Attempt the default first
		if (this._request_mode != null)
			return this._request_mode;

		if (this._imagesize[1] > this._imagesize[0]) {
			return Gtk.SizeRequestMode.WIDTH_FOR_HEIGHT;
		} else {
			return Gtk.SizeRequestMode.HEIGHT_FOR_WIDTH;
		}
	}
	public new void get_preferred_width (out int min, out int natural) {
		min = 0;
		natural = this._imagesize[0];
	}
	public new void get_preferred_height (out int min, out int natural) {
		min = 0;
		natural = this._imagesize[1];
	}
	public new void get_preferred_height_for_width (int width, out int min, out int height) {
		min = 0;
		height = width * (this._imagesize[0] / this._imagesize[1]);
	}
	public new void get_preferred_width_for_height (int height, out int min, out int width) {
		min = 0;
		width = height * (this._imagesize[1] / this._imagesize[0]);
	}
	public Image () {
	}
	public Image.from_file (File file) throws Error {
		this();
		this.set_from_file(file);
	}
	public Image.from_url (string url, Soup.Session? session) throws Error {
		this();
		this.set_from_url(url, session);
	}
	public void set_from_url (string url, Soup.Session? session) throws Error {
		session = session ?? new Soup.Session();
		Nectar.Util.FileCache cache = new Nectar.Util.FileCache("webimage");

		File file = cache.lookup(url);
		Soup.Message msg = new Soup.Message("GET", url);
		InputStream stream = session.send(msg);
		try {
			FileOutputStream outstream = file.create(FileCreateFlags.PRIVATE);
			outstream.splice_async.begin(stream, OutputStreamSpliceFlags.CLOSE_TARGET
			                            ^ OutputStreamSpliceFlags.CLOSE_SOURCE, 0, null,
			                            (obj, res) => {
				try {
					outstream.splice_async.end(res);
					this.set_from_file(file);
				} catch (Error e) {}
			});
		} catch (IOError e) {
			if (e is IOError.EXISTS) {
				this.set_from_file(file);
			} else {
				throw e;
			}
		}
	}
	public void set_from_file (File file) throws Error {
		// could use a stream instead but that's a lot of additional overhead
		// We don't load it directly in cairo because it only supports PNG
		// The pixbuf engine has far wider support for files like JPEG and shit
		var pixbuf = new Gdk.Pixbuf.from_file(file.get_path());
		this._image = new Cairo.Pattern.for_surface(Gdk.cairo_surface_create_from_pixbuf(pixbuf, 1, this.get_parent_window()));
		this._imagesize = {pixbuf.width, pixbuf.height};
	}
	public override bool draw (Cairo.Context cr) {
		int width = get_allocated_width();
		int height = get_allocated_height();

		cr.set_source(this._image);
		cr.rectangle(0, 0, width, height);
		cr.fill();
		return true;
	}
}
