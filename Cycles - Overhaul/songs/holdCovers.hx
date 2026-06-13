import flixel.FlxObject;
import flixel.FlxObject.FlxCameraFollowStyle;
import funkin.game.PlayState;
import funkin.game.Stage;
import flixel.math.FlxMath;

var holdCovers:Array<FlxSprite> = [];
var spr:FlxSprite;

function create()
{
    for (i in 0...4)
    {
        spr = new FlxSprite();
        spr.frames = Paths.getSparrowAtlas("game/holdStuff");
        spr.cameras = [camHUD];

        switch(i)
        {
            case 0:
                spr.animation.addByPrefix("start", "holdCoverStartPurple", 24, false);
                spr.animation.addByPrefix("hold", "holdCoverPurple", 24, true);
                spr.animation.addByPrefix("end", "holdCoverEndPurple", 24, false);

            case 1:
                spr.animation.addByPrefix("start", "holdCoverStartBlue", 24, false);
                spr.animation.addByPrefix("hold", "holdCoverBlue", 24, true);
                spr.animation.addByPrefix("end", "holdCoverEndBlue", 24, false);

            case 2:
                spr.animation.addByPrefix("start", "holdCoverStartGreen", 24, false);
                spr.animation.addByPrefix("hold", "holdCoverGreen", 24, true);
                spr.animation.addByPrefix("end", "holdCoverEndGreen", 24, false);

            case 3:
                spr.animation.addByPrefix("start", "holdCoverStartRed", 24, false);
                spr.animation.addByPrefix("hold", "holdCoverRed", 24, true);
                spr.animation.addByPrefix("end", "holdCoverEndRed", 24, false);
        }

        spr.visible = false;
        add(spr);
        holdCovers.push(spr);
    }

    holdCovers[0].x = 640;
    holdCovers[0].y = -170;
    holdCovers[0].scale.set(0.8, 0.8);

    holdCovers[1].x = 740;
    holdCovers[1].y = -170;
    holdCovers[1].scale.set(0.8, 0.8);

    holdCovers[2].x = 860;
    holdCovers[2].y = -170;
    holdCovers[2].scale.set(0.8, 0.8);

    holdCovers[3].x = 990;
    holdCovers[3].y = -170;
    holdCovers[3].scale.set(0.8, 0.8);
    // where middlecroll
    if (!Options.downscroll) {
        holdCovers[0].y += 75;
        holdCovers[1].y += 75;
        holdCovers[2].y += 75;
        holdCovers[3].y += 75;
    }
    
    if (FlxG.save.data.middlescroll) {
        holdCovers[0].x -= 315;
        holdCovers[1].x -= 315;
        holdCovers[2].x -= 315;
        holdCovers[3].x -= 315;
    }
}

function update() {
    for (spr in holdCovers)
{
    if (spr.animation.curAnim == null)
        continue;

    if (spr.animation.curAnim.name == "start"
        && spr.animation.curAnim.finished)
    {
        spr.animation.play("hold");
    }

    if (spr.animation.curAnim.name == "end"
        && spr.animation.curAnim.finished)
        {
        spr.visible = false;
        }
    }
}

function onPlayerHit(event)
{
    var spr = holdCovers[event.direction];

    if (event.note.isSustainNote)
    {
        if (!spr.visible)
        {
            spr.visible = true;
            spr.animation.play("start", true);
        }

        if (event.note.nextSustain == null)
        {
            spr.animation.play("end", true);
        }
    }
}