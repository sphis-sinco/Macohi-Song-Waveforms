class Version
{
	public static var album:Int = 1;

	public static var songCount:Int = 1;
	public static var patchCount:Int = 0;

	public static function get()
	{
		return '${album}.${songCount}_${patchCount}';
	}
}
