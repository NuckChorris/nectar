public enum Nectar.Model.AnimeWatchingStatus {
	CURRENTLY_WATCHING,
	PLAN_TO_WATCH,
	COMPLETED,
	ON_HOLD,
	DROPPED
}
public struct Nectar.Model.AnimeStatus {
	public int episodes_watched;
	public bool rewatching;
	public int? rewatched_times;
	public Nectar.Model.AnimeWatchingStatus status;
	public DateTime? last_watched;
	public Nectar.Model.AnimeSeries anime;
}
