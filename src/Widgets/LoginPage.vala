[GtkTemplate (ui = "/com/plejeck/nectar/LoginPage.ui")]
public class Nectar.Widget.LoginPage : Gtk.Stack {
	public string password {
		get { return password_entry.text; }
		set { password_entry.text = value; }
	}
	public string username {
		get { return username_entry.text; }
		set { username_entry.text = value; }
	}
	private uint? idle_timer = null;

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

	public void loading_text (string? text) {
		if (text == null)
			stderr.printf("Stopped loading\n");
		stderr.printf("Loading: %s\n", text);
	}
	public void show_error (string? text) {
		if (text == null)
			stderr.printf("Login Error: Unknown\n");
		stderr.printf("Login Error: %s\n", text);
	}
	public void show_throbber () {
		logo_stack.visible_child_name = "throbber";
	}
	public void show_avatar (string url) throws Error {
		logo_stack.visible_child_name = "avatar";
		avatar.set_from_url(url);
	}
	public void show_logo () {
		logo_stack.visible_child_name = "logo";
	}

	[GtkCallback]
	public void on_realize () {}
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
		activate();
	}
	public signal void activate();
	public signal void typing_paused();
	public signal void typing_emptied();
}
