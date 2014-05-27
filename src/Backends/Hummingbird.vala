public errordomain Nectar.Backend.HTTPError {
	UNAUTHORIZED,
	FORBIDDEN,
	NOT_FOUND,
	SERVER_ERROR,
	BAD_GATEWAY,
	GATEWAY_TIMEOUT,
	OTHER
}
public class Nectar.Backend.Hummingbird : Object, Nectar.Backend.Backend {
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

	public async Json.Node? api_call (string method, string path, string payload = "") throws Error {
		Soup.URI req = new Soup.URI.with_base(server, path);
		Soup.Message msg = new Soup.Message.from_uri(method, req);
		Soup.MessageHeaders headers = msg.request_headers;
		Soup.MessageBody body = msg.request_body;

		headers.append("X-Mashape-Authorization", api_key);
		body.append_take(payload.data);

		Json.Parser parser = new Json.Parser();
		InputStream stream = yield session.send_async(msg);
		switch (msg.status_code) {
			case Soup.Status.UNAUTHORIZED:
				throw new Nectar.Backend.HTTPError.UNAUTHORIZED("401");
			case Soup.Status.FORBIDDEN:
				throw new Nectar.Backend.HTTPError.FORBIDDEN("403");
			case Soup.Status.NOT_FOUND:
				throw new Nectar.Backend.HTTPError.NOT_FOUND("404");
			case Soup.Status.INTERNAL_SERVER_ERROR:
				throw new Nectar.Backend.HTTPError.SERVER_ERROR("500");
			case Soup.Status.BAD_GATEWAY:
				throw new Nectar.Backend.HTTPError.BAD_GATEWAY("502");
			case Soup.Status.GATEWAY_TIMEOUT:
				throw new Nectar.Backend.HTTPError.GATEWAY_TIMEOUT("504");
			default:
				if (msg.status_code % 400 < 100)
					throw new Nectar.Backend.HTTPError.OTHER("%u Client Error".printf(msg.status_code));
				if (msg.status_code % 500 < 100)
					throw new Nectar.Backend.HTTPError.OTHER("%u Server Error".printf(msg.status_code));
				break;
		}
		yield parser.load_from_stream_async(stream);
		return parser.get_root();
	}
	public async Nectar.Model.User? get_user (string username) throws Error {
		Json.Node? root;
		try {
			root = yield api_call("GET", "/users/%s".printf(username));
		} catch (Nectar.Backend.HTTPError e) {
			if (e is Nectar.Backend.HTTPError.NOT_FOUND) {
				return null;
			} else {
				throw e;
			}
		}
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
	public async string? authenticate (string username, string password) throws Error {
		Json.Builder builder = new Json.Builder();
		builder.begin_object();
		builder.set_member_name(username.contains("@") ? "email" : "username");
		builder.add_string_value(username);
		builder.set_member_name("password");
		builder.add_string_value(password);
		builder.end_object();
		Json.Generator generator = new Json.Generator();
		generator.set_root(builder.get_root());

		// catch this and shovel it back into my asshole
		Json.Node? root = yield api_call("POST", "/users/authenticate", generator.to_data(null));
		if (root == null) return null;
		return "";
	}
}
