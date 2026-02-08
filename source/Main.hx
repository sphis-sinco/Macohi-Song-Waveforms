import flixel.FlxGame;
import openfl.display.Sprite;
import koya.backend.CrashHandler;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, InitState, 60, 60, true, false));
		
		#if CRASH_HANDLER
		openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(openfl.events.UncaughtErrorEvent.UNCAUGHT_ERROR, CrashHandler.onCrash);
		#end
	}
}
