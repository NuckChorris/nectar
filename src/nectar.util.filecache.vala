using Nectar;

class Nectar.Util.FileCache : GObject {
	private static string filename_for_key (string key, string? suffix) {
		string cache_base = GLib.Environment.get_user_cache_dir();
		string hash = GLib.Checksum.compute_for_string(GLib.ChecksumType.MD5, key);

		return GLib.Path.build_filename(cache_base, "nectar", hash + (suffix ? suffix : ""));
	}
	public static void setup () {
		string path = GLib.Path.build_filename(GLib.Environment.get_user_cache_dir(), "nectar");
		GLib.File file = new GLib.File.new_for_path(path);
		file.make_directory_with_parents();
	}
	public static GLib.File lookup (string key, string? suffix) {
		return GLib.File.new_for_path(filename_for_key(key, suffix));
	}
	public static string[] clean (GLib.DateTime older_than) {
		// to be implemented
		return {""};
	}
}
