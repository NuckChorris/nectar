// modules: gtk+-3.0 glib-2.0 json-glib-1.0 libsoup-2.4 gmodule-2.0 cairo posix
class Nectar.Util.Session : Soup.Session {
	public Session () {
		max_conns = 10;
		max_conns_per_host = 6;
		user_agent = "Nectar/0.1.0 (+http://nuckchorris.github.io/nectar/)";
		var cache = new Soup.Cache(Path.build_filename(Environment.get_user_cache_dir(), "nectar", "_soup"), Soup.CacheType.SINGLE_USER);
		add_feature(cache);
	}
}
class Nectar.Application : Gtk.Application {
	public Application () {
		Object(application_id: "com.plejeck.nectar", flags: ApplicationFlags.FLAGS_NONE);
	}
	protected override void activate () {
		var settings = new Nectar.Util.Settings.from_data_dirs();
		var session = new Nectar.Util.Session();
		var backend = new Nectar.Backend.Hummingbird(Config.HUMMINGBIRD_KEY);

		var window = new Nectar.Widget.AppWindow();

		/*** LOGIN CONTROLLER ***/
		var login_controller = new Nectar.Controller.LoginPage(settings, session, backend);
		login_controller.login_page = window.login_page;
		login_controller.attach();

		/*** PREFSBAR CONTROLLER ***/
//		var prefsbar_controller = new Nectar.Controller.PrefsBar();
//		prefsbar_controller.prefsbar = window.main_page.prefsbar;
//		prefsbar_controller.stack = window.stack;
//		prefsbar_controller.attach();

		File cssfile = File.new_for_uri("resource:///com/plejeck/nectar/style.css");
		Gtk.CssProvider css = new Gtk.CssProvider();
		css.load_from_file(cssfile);
		Gtk.StyleContext.add_provider_for_screen(window.screen, css, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

		window.show_all();
		this.add_window(window);
	}
	public static int main (string[] args) {
		Nectar.Application app = new Nectar.Application();
		return app.run(args);
	}
}
