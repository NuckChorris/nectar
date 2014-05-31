class Nectar.Controller.LoginPage : Object {
	public Nectar.Util.Settings settings;
	public Nectar.Util.Session session;
	public Nectar.Backend.Backend backend;
	public Nectar.Widget.LoginPage login_page;
	public Gtk.Stack stack;

	public LoginPage (Nectar.Util.Settings settings, Nectar.Util.Session session, Nectar.Backend.Backend backend) {
		this.settings = settings;
		this.session = session;
		this.backend = backend;
	}
	public void attach () throws Error {
		string currently_displayed_user = "";
		login_page.typing_paused.connect(() => {
			if (currently_displayed_user != login_page.username) {
				login_page.show_throbber();
				backend.get_user.begin(login_page.username, (obj, res) => {
					try {
						Nectar.Model.User? user = backend.get_user.end(res);
						if (user != null) {
							currently_displayed_user = login_page.username;
							login_page.show_avatar(user.avatar.to_string(false));
						} else {
							login_page.show_logo();
						}
					} catch (Error e) {
						login_page.show_logo();
					}
				});
			}
		});
		login_page.typing_emptied.connect(() => {
			currently_displayed_user = "";
			login_page.show_logo();
		});
		login_page.activate.connect(() => {
			login_page.loading_text("Logging in...");
			backend.authenticate.begin(login_page.username, login_page.password, (obj, res) => {
				string? auth = backend.authenticate.end(res);
				if (auth == null) {
					login_page.loading_text(null);
					login_page.show_error("Bad username or password");
				}
				stack.visible_child_name = "main-page";
				stderr.printf("%s\n", auth);
			});
		});
	}
}
