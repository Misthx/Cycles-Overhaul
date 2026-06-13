import funkin.options.Options;
var opponentNoteAlpha:Float = 0.35;

function update(elapsed:Float) {
    if (FlxG.save.data.middlescroll) {
        for (strumLine in strumLines.members)
        {
            if (!strumLine.opponentSide) continue;

            strumLine.notes.forEach(function(note)
            {
                note.alpha = opponentNoteAlpha;
            });
        }
    }
}

function postUpdate(elapsed:Float) {
    if (FlxG.save.data.middlescroll) {
        var oppStrums = strumLines.members[0];
        if (oppStrums != null) {
            for (i in 0...oppStrums.members.length) {
                var strum = oppStrums.members[i];
                strum.alpha = 0.35;
                
                if (i < 2) {
                    strum.x = 92 + (112 * i);
                } else {
                    strum.x = FlxG.width - 316 + (112 * (i - 2));
                }
            }
        }

        var playerStrums = strumLines.members[1];
        if (playerStrums != null) {
            for (i in 0...playerStrums.members.length) {
                var strum = playerStrums.members[i];
                strum.x = 416 + (112 * i);
            }
        }
    }
}

function onSongStart() {
    if (FlxG.save.data.botplay) {
        player.cpu = true;
    }
}

