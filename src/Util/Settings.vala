class Nectar.Util.Settings : KeyFile {
	public Settings () {
		base();
	}
	public Settings.from_data_dirs () {
		this();

		try {
			this.load_from_data_dirs("nectar.ini", null, KeyFileFlags.NONE);
		} catch (FileError e) {
			Nectar.Util.Logger.error("Nectar.Settings", "File Error", e.message);
		} catch (KeyFileError e) {
			Nectar.Util.Logger.error("Nectar.Settings", "Parse Error", e.message);
		}
	}
}
