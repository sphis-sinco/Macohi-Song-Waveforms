import flixel.FlxG;
import flixel.text.FlxText;
import lime.utils.Assets;
import flixel.FlxState;

using StringTools;

class SongSelect extends FlxState
{
	public var songListFile:String = 'assets/songs.txt';

	public var songList:Array<String> = [];

	public var songText:FlxText;
	public var songSelect:Int = 0;

	override function create()
	{
		super.create();

		songList = Assets.getText(songListFile).split('\n');
		trace(songList);

		songText = new FlxText();
		songText.size = 24;
		add(songText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustReleased([A, LEFT]))
			songSelect--;
		if (FlxG.keys.anyJustReleased([D, RIGHT]))
			songSelect--;

		if (songSelect < 0)
			songSelect = songList.length - 1;
		if (songSelect > songList.length - 1)
			songSelect = 0;

		songText.text = songList[songSelect].trim();
		songText.screenCenter();

		if (FlxG.keys.justReleased.ENTER)
		{
			FlxG.switchState(() -> new PlayState(songList[songSelect].trim()));
		}
	}
}
