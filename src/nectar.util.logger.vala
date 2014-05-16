class Nectar.Util.Logger {
	public static void error (string where, string what, string info) {
		stderr.printf(" ! [%s:%s] %s\n", where, what, info);
	}
}
