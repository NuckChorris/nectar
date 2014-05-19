[GtkTemplate (ui = "/com/PLejeck/Nectar/LoginPage.ui")]
public class Nectar.Widget.LoginPage : Gtk.Box {
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
j
	public LoginPage () {
		typing_paused.connect(() => {
			
		});
	}
	public LoginPage.with_username (string username) {
		username_entry.text = username;
		this();
	}

	[GtkCallback]
	private void on_username_changed () {
		login_button.sensitive = (username_entry.text_length != 0 && password_entry.text_length != 0);

		if (idle_timer != null) {
			Source.remove(idle_timer);
			idle_timer = null;
		}

		idle_timer = Timeout.add(200, () => {
			idle_timer = null;
			if (username_entry.text_length == 0)
				return false;
			typing_paused();
			return false;
		});
	}
	[GtkCallback]
	private bool on_username_unfocus () {
		if (username_entry.text.length != 0)
			typing_paused();
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
}
