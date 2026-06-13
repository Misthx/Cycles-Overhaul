import flixel.FlxObject;
import flixel.FlxObject.FlxCameraFollowStyle;
import funkin.game.PlayState;
import funkin.game.Stage;
import funkin.game.Note;
import flixel.math.FlxMath;

var intensity:Float = 25;
var smoothSpeed:Float = 18;

var camOffsetX:Float = 0;
var camOffsetY:Float = 0;
var camBetterFollow:FlxObject;
var camBetterFollowLerp:Float = 0.1;
var preventCameraMovement:Bool = false;

var staticShader:CustomShader;
var spr:FlxSprite;

var eventIndex:Int = 0;
var displayedHealth:Float = 1;

introLength = 1;


var tottalTime:Float = 0;

var eventQueue:Array<Dynamic> = [];

function onCountdown(event) event.cancel();

function postCreate() {
    defaultHoldTime = boyfriend.holdTime;
    camBetterFollow = new FlxObject(camFollow.x, camFollow.y, 2, 2);
    FlxG.camera.follow(camBetterFollow, FlxCameraFollowStyle.LOCKON, 0.04);
    // nvm. it does worok
    staticShader = new CustomShader("tvstatic");
	staticShader.time = 0; staticShader.strength = 0.1;
	staticShader.speed = 20;
	FlxG.camera.addShader(staticShader);
	
	healthBar.y += 20;
	accuracyTxt.y += 20;
	accuracyTxt.x -= 65;
	healthBarBG.y += 20;
    scoreTxt.y += 20;
    scoreTxt.x += 55;
    comboRatings.y += 20;
    missesTxt.y += 20;
    iconP1.y += 10;
    iconP2.y += 10;
}

function postUpdate(elapsed:Float) {
    var targetX:Float = 0;
    var targetY:Float = 0;
    
    while (
        eventIndex < eventQueue.length &&
        Conductor.songPosition >= eventQueue[eventIndex].t
    ) {
        var currentBatch = eventQueue[eventIndex++];

        for (ev in currentBatch.e) {
            runHardcodedEvent(ev[0], ev[1], ev[2]);
        }
    }
    displayedHealth = FlxMath.lerp(displayedHealth, health, elapsed * 5);
    healthBar.percent = displayedHealth * 50;
    // this looks cool ok?
    camHUD.zoom = 0.95;
    
    if (boyfriend != null
        && boyfriend.animation.curAnim != null
        && boyfriend.animation.curAnim.name == "idle")
    {
        boyfriend.holdTime = defaultHoldTime;
    }
    
    var char = dad;
    if (PlayState.instance.curCameraTarget == 1) {
        char = boyfriend;
    }

    if (char != null && char.animation.curAnim != null) {
        var animName = char.animation.curAnim.name;
        
        if (animName.indexOf("singLEFT") != -1) {
            targetX = -intensity;
        } else if (animName.indexOf("singRIGHT") != -1) {
            targetX = intensity;
        }
        
        if (animName.indexOf("singUP") != -1) {
            targetY = -intensity;
        } else if (animName.indexOf("singDOWN") != -1) {
            targetY = intensity;
        }
    }
    
    camOffsetX += (targetX - camOffsetX) * elapsed * smoothSpeed;
    camOffsetY += (targetY - camOffsetY) * elapsed * smoothSpeed;
    
    FlxG.camera.targetOffset.set(camOffsetX, camOffsetY);
    
    iconP2.angle = Math.sin(Conductor.songPosition / 500) * 2;
    
    iconP1.scale.set(1, 1);
    iconP2.scale.set(1, 1);

    //iconP1.updateHitbox();
    //iconP2.updateHitbox();

    iconP1.centerOrigin();
    iconP2.centerOrigin();
    
    PlayState.instance.doIconBop = false;
    
    tottalTime += elapsed/1000;
    staticShader.time = tottalTime*1000;
}
function onPostStrumCreation(e) {
    e.strum.antialiasing = false;

    e.strum.x += 10;
    if (e.strumID > 0) {
        e.strum.x -= 4.7 * e.strumID;
    }
    e.strum.alpha = 1;
}

function onPostNoteCreation(event)
{
    if (event.note.isSustainNote)
        event.note.alpha = 1;
}

public var cameraDisplacement:Float = 20;
public function getDisplacement(char:Character, ?amount:Float = null) {
    var d = [0, 0];
    var amt = amount == null ? cameraDisplacement : amount;

    switch char.getAnimName() {
        case "singLEFT" | "singLEFT-alt": d[0] -= amt;
        case "singDOWN" | "singDOWN-alt": d[1] += amt;
        case "singUP" | "singUP-alt": d[1] -= amt;
        case "singRIGHT" | "singRIGHT-alt": d[0] += amt;
    }

    return d;
}

function onCameraMove(e) {
    if (preventCameraMovement) {
        e.cancel();
        return;
    }

    var displacement = getDisplacement(strumLines.members[curCameraTarget].characters[0]);
    e.position.x += displacement[0];
    e.position.y += displacement[1];

    camBetterFollow.x = FlxMath.lerp(camBetterFollow.x, camFollow.x, camBetterFollowLerp);
    camBetterFollow.y = FlxMath.lerp(camBetterFollow.y, camFollow.y, camBetterFollowLerp);
}

function update(elapsed:Float) {
    var targetZoom:Float = (curCameraTarget == 1) ? 0.7 : 0.5;
    defaultCamZoom = FlxMath.lerp(defaultCamZoom, targetZoom, elapsed * 3);
}

function onNoteCreation(event) {
    if (event.strumLineID == 0) 
        event.noteSprite = "game/notes/opponentnotes";
   else 
        event.noteSprite = "game/notes/default";
}
function onStrumCreation(event) {
    event.strum.y -= 40;
    if (event.player == 0)  // opponent side
        event.sprite = "game/notes/opponentnotes";
    else  // player side
        event.sprite = "game/notes/default";
}

function onPlayerHit(event) {
    if (event.note != null && event.note.isSustainNote)
    {
        event.cancelAnim();

        var char = event.character;
        char.holdTime = 9999;

        if (event.note.nextSustain == null)
        {
            new FlxTimer().start(0.45, function(tmr)
            {
                char.holdTime = 4;
            });
        }
    }
}