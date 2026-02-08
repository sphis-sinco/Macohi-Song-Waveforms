import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.waveform.FlxWaveform;

class PlayState extends FlxState
{
	public var waveforms:Array<FlxWaveform>;

	public var song:String;
	public var audioFiles:Array<String> = [];

	public final VIEW_AHEAD_SECONDS:Float = 5;

	override public function new()
	{
		super();

		this.song = 'its-fine';
		this.audioFiles = ['main'];
	}

	/** Convert `s` seconds to milliseconds **/
	function seconds(s:Float):Float
		return s * 1000;

	override public function create()
	{
		super.create();

		FlxG.autoPause = false;

		for (audioFile in audioFiles)
		{
			var audio = FlxG.sound.load('assets/$song/$audioFile.wav', 1.0, true);

			// NOTE: Due to a limitation, on HTML5 you have to play the audio source
			// before trying to make a waveform from it.
			// See: https://github.com/ACrazyTown/flixel-waveform/issues/8
			audio.play(true);

			var waveform:FlxWaveform;
			waveform = new FlxWaveform(0, 50, FlxG.width, FlxG.height - 50);
			waveform.loadDataFromFlxSound(audio);
			waveform.waveformTime = seconds(0);
			waveform.waveformDuration = seconds(VIEW_AHEAD_SECONDS);
			waveform.waveformDrawMode = COMBINED;

			waveform.waveformColor = 0xFFE37B9B;
			waveform.waveformBgColor = 0xFF984E97;

			waveform.waveformDrawRMS = true;
			waveform.waveformRMSColor = 0xFFFFBAF0;

			waveform.waveformDrawBaseline = true;

			waveform.waveformBarSize = 1;
			waveform.waveformBarPadding = 0;
			// waveform.waveformChannelPadding = 2;

			add(waveform);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
