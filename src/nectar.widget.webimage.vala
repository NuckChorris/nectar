class Nectar.Widget.WebImage : Gtk.Image {
	public WebImage (string url, Soup.Session? session) throws Error {
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
					this.set_from_file(file.get_path());
				} catch (Error e) {}
			});
		} catch (IOError e) {
			if (e is IOError.EXISTS) {
				this.set_from_file(file.get_path());
			} else {
				throw e;
			}
		}
	}
}
