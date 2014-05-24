[GtkTemplate (ui = "/com/plejeck/nectar/LoginPage.ui")]
public class Nectar.Widget.LoginPage : Gtk.Box {
	public string password {
		get { return password_entry.text; }
		set { password_entry.text = value; }
	}
	public string username {
		get { return username_entry.text; }
		set { username_entry.text = value; }
	}
	public Nectar.Backend.Hummingbird backend;
	private uint? idle_timer = null;
	private string? currently_displayed_user = null;

	[GtkChild]
	private Gtk.Entry username_entry;
	[GtkChild]
	private Gtk.Entry password_entry;
	[GtkChild]
	private Gtk.Button login_button;
	[GtkChild]
	private Gtk.Stack logo_stack;
	[GtkChild]
	private Nectar.Widget.Image avatar;

	public LoginPage.with_username (string username) {
		username_entry.text = username;
		this();
	}

	public void set_avatar (string url) {
		avatar.set_from_url(url);
	}

	[GtkCallback]
	public void on_realize () {
		backend = new Nectar.Backend.Hummingbird(Config.HUMMINGBIRD_KEY);
		typing_paused.connect(() => {
			if (currently_displayed_user != username_entry.text) {
				logo_stack.visible_child_name = "throbber";
				backend.get_user.begin(username_entry.text, (obj, res) => {
					Nectar.Model.User? user = backend.get_user.end(res);
					if (user != null) {
						currently_displayed_user = username_entry.text;
						set_avatar(user.avatar.to_string(false));
						logo_stack.visible_child_name = "avatar";
					} else {
						logo_stack.visible_child_name = "logo";
					}
				});
			}
		});
		typing_emptied.connect(() => {
			logo_stack.visible_child_name = "logo";
		});
	}
	[GtkCallback]
	private void on_username_changed () {
		login_button.sensitive = (username_entry.text_length != 0 && password_entry.text_length != 0);

		if (idle_timer != null) {
			Source.remove(idle_timer);
			idle_timer = null;
		}

		idle_timer = Timeout.add(300, () => {
			idle_timer = null;
			if (username_entry.text_length != 0) {
				typing_paused();
			} else {
				typing_emptied();
			}
			return false;
		});
	}
	[GtkCallback]
	private bool on_username_unfocus () {
		if (username_entry.text.length != 0) {
			typing_paused();
		} else {
			typing_emptied();
		}
		return false;
	}
	[GtkCallback]
	private void on_password_changed () {
		login_button.sensitive = (username_entry.text_length != 0 && password_entry.text_length != 0);
	}
	[GtkCallback]
	private void on_login_clicked () {
		login();
	}
	public signal void login();
	public signal void typing_paused();
	public signal void typing_emptied();
}
