public interface Nectar.Backend.Backend : Object {
	// Public stuff
	public abstract async Nectar.Model.User? get_user (string username) throws Error;
//	public abstract async Nectar.Model.AnimeSeries? get_anime (string id) throws Error;
//	public abstract async Nectar.Model.AnimeSeries[] search_anime (string query) throws Error;
//	public abstract async Nectar.Model.AnimeStatus[] get_anime_list (string query) throws Error;
	// Authenticated stuff
	public abstract async string? authenticate (string username, string password) throws Error;
//	public abstract async bool update_anime_status (string anime_id, string status, string auth) throws Error;
//	public abstract async int increment_anime_episode (string anime_id, string auth) throws Error;
}
