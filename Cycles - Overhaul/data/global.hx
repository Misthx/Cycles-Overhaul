import backend.Options;
import flixel.FlxG;

function new() {
    FlxG.save.data.botplay ??= false;
    FlxG.save.data.middlescroll ??= false;
}