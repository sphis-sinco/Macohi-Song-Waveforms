import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.waveform.FlxWaveform;

class PlayState extends FlxState
{
	public var waveforms:Array<FlxWaveform>;
	public var tracks:Array<FlxSound>;

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

		waveforms = [];
		tracks = [];

		var i = 0;
		for (audioFile in audioFiles)
		{
			var audio = new FlxSound().loadEmbedded('assets/$song/$audioFile.ogg', true);

			// NOTE: Due to a limitation, on HTML5 you have to play the audio source
			// before trying to make a waveform from it.
			// See: https://github.com/ACrazyTown/flixel-waveform/issues/8
			audio.ID = i;
			audio.play(true);
			tracks.push(audio);

			var waveform:FlxWaveform;
			var waveformOffset:Float = ((i + 1) / audioFiles.length) * 50;
			waveform = new FlxWaveform(0, 0, FlxG.width, Math.round(FlxG.height - waveformOffset));
			waveform.loadDataFromFlxSound(audio);
			waveform.waveformTime = seconds(0);
			waveform.waveformDuration = seconds(VIEW_AHEAD_SECONDS);
			waveform.waveformDrawMode = COMBINED;

			waveform.waveformColor = 0xFFE37B9B;
			waveform.waveformBgColor = 0x00984E97;

			waveform.waveformDrawRMS = true;
			waveform.waveformRMSColor = 0xFFFFBAF0;

			waveform.waveformDrawBaseline = true;

			waveform.waveformBarSize = 1;
			waveform.waveformBarPadding = 0;
			// waveform.waveformChannelPadding = 2;

			waveforms.push(waveform);

			i++;
		}

		for (track in tracks)
			track.play(true);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		for (track in tracks)
		{
			var waveform:FlxWaveform = waveforms[track.ID];
			if (track.playing && waveform != null)
				waveform.waveformTime = track.time + getLatency();
		}
	}

	function getLatency():Float
	{
		#if js
		var ctx = lime.media.AudioManager.context.web;
		if (ctx != null)
		{
			var baseLatency:Float = untyped ctx.baseLatency != null ? untyped ctx.baseLatency : 0;
			var outputLatency:Float = untyped ctx.outputLatency != null ? untyped ctx.outputLatency : 0;

			return (baseLatency + outputLatency) * 1000;
		}

		return 0;
		#else
		return 0;
		#end
	}
}
