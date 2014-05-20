public errordomain Nectar.Backend.HummingbirdError {
	USER_NOT_FOUND,
	HTTP_ERROR
}
public class Nectar.Backend.Hummingbird {
	private Soup.URI server = new Soup.URI("https://hbrd-v1.p.mashape.com/");
	public string api_key { get; set; }
	public Soup.Session session { get; set; default = new Soup.Session(); }

	public Hummingbird (string api_key) {
		this.api_key = api_key;
		session.prefetch_dns(server.host, null, null);
	}
	public Hummingbird.with_session (string api_key, Soup.Session session) {
		this.session = session;
		this(api_key);
	}

	public async Json.Node? api_call (string method, string path) throws Error {
		Soup.URI req = new Soup.URI.with_base(server, path);
		Soup.Message msg = new Soup.Message.from_uri(method, req);
		Soup.MessageHeaders headers = msg.request_headers;
		headers.append("X-Mashape-Authorization", api_key);


		Json.Parser parser = new Json.Parser();
		InputStream stream = yield session.send_async(msg);
		if (msg.status_code == Soup.Status.NOT_FOUND)
			return null;
		yield parser.load_from_stream_async(stream);
		return parser.get_root();
	}
	public async Nectar.Model.User? get_user (string username) throws Error {
		Json.Node? root = yield api_call("GET", "/users/%s".printf(username));
		if (root == null) return null;
		Json.Object obj = root.get_object();

		string? avatar = obj.get_string_member("avatar");
		string? cover_image = obj.get_string_member("cover_image");
		Nectar.Model.User model = Nectar.Model.User () {
			name = obj.get_string_member("name"),
			location = obj.get_string_member("location"),
			bio = obj.get_string_member("bio"),
			avatar = new Soup.URI(avatar),
			cover_image = new Soup.URI(cover_image)
		};
		return model;
	}
}
