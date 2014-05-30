struct Nectar.Model.ImageSize {
	public int w;
	public int h;
}
public class Nectar.Widget.Image : Gtk.Misc {
	// Literally just cheat for now
	public int max_height { get; set; default = int.MAX; }
	public int max_width { get; set; default = int.MAX; }
	private Cairo.Pattern _image;
	private Nectar.Model.ImageSize _imgsize;
	public Gtk.SizeRequestMode? request_mode;
	private Cairo.Matrix _matrix {
		get {
			Cairo.Matrix matrix = Cairo.Matrix.identity();

			double width_container = get_allocated_width();
			double height_container = get_allocated_height();
			double width_outer = Math.fmin(width_container, this.max_width);
			double height_outer = Math.fmin(height_container, this.max_height);

			//
			// Scale
			//
			double fatness_outer = width_outer / height_outer;
			double fatness_inner = (double)this._imgsize.w / (double)this._imgsize.h;
			double scale, x = 0, y = 0;

			if (fatness_inner >= fatness_outer) {
				scale = (double)this._imgsize.w / width_outer;
			} else {
				scale = (double)this._imgsize.h / height_outer;
			}
			x = ((double)this._imgsize.w / scale / 2) - ((double)width_container / 2);
			y = ((double)this._imgsize.h / scale / 2) - ((double)height_container / 2);
			if (!(x.is_nan() || y.is_nan() || scale.is_nan())) {
				matrix.scale(scale, scale);
				matrix.translate((int)(x), (int)(y));
			}

			return matrix;
		}
	}
	public override Gtk.SizeRequestMode get_request_mode () {
		if (this.request_mode != null)
			return this.request_mode;
		return Gtk.SizeRequestMode.WIDTH_FOR_HEIGHT;
	}
	public override void get_preferred_width (out int min, out int natural) {
		min = 1;
		natural = (this._imgsize.w > 0) ? this._imgsize.w : 1;
		if (this.max_width < natural)
			natural = this.max_width;
	}
	public override void get_preferred_height (out int min, out int natural) {
		min = 1;
		natural = (this._imgsize.h > 0) ? this._imgsize.h : 1;
		if (this.max_height < natural)
			natural = this.max_height;
	}
	public override void get_preferred_height_for_width (int width, out int min, out int height) {
		min = 1;
		if (this._imgsize.h == 0 || this._imgsize.w == 0) {
			height = 1;
		} else {
			height = (int)((double)width * ((double)this._imgsize.h / (double)this._imgsize.w));
		}
	}
	public override void get_preferred_width_for_height (int height, out int min, out int width) {
		min = 1;
		if (this._imgsize.h == 0 || this._imgsize.w == 0) {
			width = 1;
		} else {
			width = (int)((double)height * ((double)this._imgsize.w / (double)this._imgsize.h));
		}
	}
	public Image () {
		this.expand = false;
	}
	public Image.from_file (File file) throws Error {
		this();
		this.set_from_file(file);
	}
	public Image.from_url (string url, Soup.Session session = new Soup.Session()) throws Error {
		this();
		this.set_from_url(url, session);
	}
	public void set_from_url (string url, Soup.Session session = new Soup.Session()) throws Error {
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
		this._imgsize = {pixbuf.width, pixbuf.height};
		stderr.printf("File: %s\n", file.get_path());
		stderr.printf("Size: %dx%d\n", pixbuf.width, pixbuf.height);
	}
	public override bool draw (Cairo.Context cr) {
		if (this._image != null) {
			int width = get_allocated_width();
			int height = get_allocated_height();

			this._image.set_matrix(this._matrix);
			cr.set_source(this._image);
			cr.rectangle(0, 0, width, height);
			cr.fill();
			return true;
		} else {
			return false;
		}
	}
}
