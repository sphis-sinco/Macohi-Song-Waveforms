import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.waveform.FlxWaveform;

class PlayState extends FlxState
{
	public var waveforms:FlxTypedGroup<FlxWaveform>;
	public var tracks:Array<FlxSound>;

	public var song:String;
	public var audioFiles:Array<String> = [];

	public final VIEW_AHEAD_SECONDS:Float = 5;
	public final waveWidth:Float = 64;

	public var startTime:Float = 0;

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

		waveforms = new FlxTypedGroup<FlxWaveform>();
		add(waveforms);

		tracks = [];

		var i = 0;
		for (audioFile in audioFiles)
		{
			var audio = new FlxSound().loadEmbedded('assets/$song/$audioFile.ogg', true, false, () ->
			{
				startTime = Date.now().getTime();
				trace('Restarting $song channel: $audioFile');
			});

			// NOTE: Due to a limitation, on HTML5 you have to play the audio source
			// before trying to make a waveform from it.
			// See: https://github.com/ACrazyTown/flixel-waveform/issues/8
			audio.ID = i;
			audio.play(true);
			tracks.push(audio);

			var waveform:FlxWaveform;
			waveform = new FlxWaveform(0, waveWidth * i, FlxG.width, Math.round(waveWidth));

			waveform.loadDataFromFlxSound(audio);
			waveform.ID = i;

			waveform.waveformTime = seconds(0);
			waveform.waveformDuration = seconds(VIEW_AHEAD_SECONDS);
			// waveform.waveformDuration = seconds(audio.length / 1000);
			waveform.waveformDrawMode = COMBINED;

			waveform.waveformColor = 0xFFE37B9B;
			waveform.waveformBgColor = 0x00984E97;

			waveform.waveformRMSColor = 0xFFFFBAF0;

			waveform.waveformDrawBaseline = false;

			waveform.waveformBarSize = 1;
			waveform.waveformBarPadding = 0;

			// waveform.waveformChannelPadding = 2;

			waveform.waveformGainMultiplier = 6;

			// waveform.autoUpdateBitmap = false;

			waveforms.add(waveform);

			i++;
		}

		startTime = Date.now().getTime();

		for (track in tracks)
			track.play(true);
	}

	public var DRAW_RMS:Bool = true;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.R) DRAW_RMS = !DRAW_RMS;

		for (waveform in waveforms.members)
		{
			waveform.waveformTime = (Date.now().getTime() - startTime) + getLatency();
			waveform.waveformDrawRMS = DRAW_RMS;
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
