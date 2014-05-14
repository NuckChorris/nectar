class Nectar.Util.FileCache : Object {
	private string _bucket;
	private string _dir;
	private string filename_for_key (string key) {
		string hash = Checksum.compute_for_string(ChecksumType.MD5, key);
		return Path.build_filename(this._dir, hash);
	}

	public FileCache (string? bucket) {
		this._bucket = bucket ?? "default";
		this._dir = Path.build_filename(Environment.get_user_cache_dir(), "nectar", this._bucket);
		DirUtils.create_with_parents(this._dir, 0700);
	}

	public File lookup (string key) {
		return File.new_for_path(filename_for_key(key));
	}
	public string[] clean (DateTime older_than) {
		// to be implemented
		return {""};
	}
}
