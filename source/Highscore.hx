package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	#end
	public static var mod:String = 'normal';


	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff, true);


		#if !switch
		NGio.postScore(score, song);
		#end


		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{

		#if !switch
		NGio.postScore(score, "Week " + week);
		#end


		var daWeek:String = formatSong('week' + week, diff, true);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int, addmod:Bool = false):String
	{
		var daSong:String = song;

		if (diff == 0 || diff == 4)
			daSong += '-easy';
		else if (diff == 2 || diff == 6)
			daSong += '-hard';
		else if (diff == 3 || diff == 7)
			daSong += '-hardplus';

		if (addmod) {
		refreshmod();

		daSong += '-' + mod;
		}

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff, true)))
			setScore(formatSong(song, diff, true), 0);

		return songScores.get(formatSong(song, diff, true));
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff, true)))
			setScore(formatSong('week' + week, diff, true), 0);

		return songScores.get(formatSong('week' + week, diff, true));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
	}

	public static function refreshmod():Void
	{
		trace(OG.BSIDE);
		if (OG.BSIDE)
			mod = 'bside';
		else
			mod = 'normal';
	}
}
