public errordomain Nectar.Backend.HTTPError {
	SERVER_ERROR,
	BAD_GATEWAY,
	GATEWAY_TIMEOUT,
	WE_FUCKED_UP,
	THEY_FUCKED_UP,
	OTHER
}
public struct Nectar.Backend.HTTPReply {
	uint status;
	Json.Node? json;
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

	public async Nectar.Backend.HTTPReply api_call (string method, string path, string payload = "",
	                                                string content_type = "text/plain") throws Error {
		Soup.URI req = new Soup.URI.with_base(server, path);
		Soup.Message msg = new Soup.Message.from_uri(method, req);
		Soup.MessageHeaders headers = msg.request_headers;
		Soup.MessageBody body = msg.request_body;

		headers.append("X-Mashape-Authorization", api_key);
		headers.append("Accept", "application/json,*/*;q=0.8");
		headers.append("Content-Type", content_type);
		body.append_take(payload.data);

		Json.Parser parser = new Json.Parser();
		InputStream stream = yield session.send_async(msg);
		try {
			yield parser.load_from_stream_async(stream);
			return Nectar.Backend.HTTPReply () {
				status = msg.status_code,
				json = parser.get_root()
			};
		} catch (Error e) {
			return Nectar.Backend.HTTPReply () {
				status = msg.status_code,
				json = null
			};
		}
	}
	public async Nectar.Model.User? get_user (string username) throws Error {
		Nectar.Backend.HTTPReply reply = yield api_call("GET", "/users/%s".printf(username));

		if (reply.status == Soup.Status.NOT_FOUND)
			return null;
		if (reply.status != Soup.Status.OK && reply.status % 500 < 100)
			throw new Nectar.Backend.HTTPError.THEY_FUCKED_UP(reply.status.to_string());
		if (reply.status != Soup.Status.OK && reply.status % 400 < 100)
			throw new Nectar.Backend.HTTPError.WE_FUCKED_UP(reply.status.to_string());

		Json.Object obj = reply.json.get_object();

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
		Json.Node? root;
		Json.Builder builder = new Json.Builder();
		builder.begin_object();
		builder.set_member_name(username.contains("@") ? "email" : "username");
		builder.add_string_value(username);
		builder.set_member_name("password");
		builder.add_string_value(password);
		builder.end_object();
		Json.Generator generator = new Json.Generator();
		generator.set_root(builder.get_root());

		Nectar.Backend.HTTPReply reply = yield api_call("POST", "/users/authenticate",
		                                                generator.to_data(null), "application/json");

		if (reply.status == Soup.Status.UNAUTHORIZED)
			return null;
		if (reply.status != Soup.Status.CREATED && reply.status % 500 < 100)
			throw new Nectar.Backend.HTTPError.THEY_FUCKED_UP(reply.status.to_string());
		if (reply.status != Soup.Status.CREATED && reply.status % 400 < 100)
			throw new Nectar.Backend.HTTPError.WE_FUCKED_UP(reply.status.to_string());

		return reply.json.get_string();
	}
}
