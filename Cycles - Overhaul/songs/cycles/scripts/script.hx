import flixel.FlxCamera;

var blackScreen:FlxSprite;
var blackScreen2:FlxSprite;
var CyclesText:FlxSprite;
var CyclesCircle:FlxSprite;
var faded:Bool = false;

var intro:Bool = false;
var tween:Bool = false;
var coolevent:Bool = false;
var coolevent2:Bool = false;
var end:Bool = false;

function postCreate() {
    camOther = new FlxCamera();
    camOther.bgColor = 0x00000000;
    FlxG.cameras.add(camOther, false);
    
    camAA = new FlxCamera();
    camAA.bgColor = 0x00000000;
    FlxG.cameras.add(camAA, false);
    
    camIntro = new FlxCamera();
    camIntro.bgColor = 0x00000000;
    FlxG.cameras.add(camIntro, false);
    
    blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
    blackScreen.scrollFactor.set();
    blackScreen.scale.set(1.1, 1.1);
    blackScreen.cameras = [camOther];
    add(blackScreen);
    
    blackScreen2 = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
    blackScreen2.scrollFactor.set();
    blackScreen2.scale.set(1.1, 1.1);
    blackScreen2.cameras = [camAA];
    add(blackScreen2);
    
    CyclesCircle = new FlxSprite();
    CyclesCircle.loadGraphic(Paths.image("CircleCycles"));
    CyclesCircle.cameras = [camIntro];
    CyclesCircle.screenCenter();
    add(CyclesCircle);
    
    CyclesText = new FlxSprite();
    CyclesText.loadGraphic(Paths.image("TextCycles"));
    CyclesText.cameras = [camIntro];
    CyclesText.screenCenter();
    add(CyclesText);
    
    camAA.alpha = 0;
    
    CyclesText.x += 1000;
    CyclesCircle.x += -1000;
}

function update(elapsed:Float) {
    if (PlayState.difficulty == "encore") {
        if (!tween && Conductor.songPosition >= 1000) {
            tween = true;
            FlxTween.tween(CyclesCircle, {x: 0}, 4, {ease: FlxEase.expoOut});
            FlxTween.tween(CyclesText, {x: 0}, 4, {ease: FlxEase.expoOut});
        }
        
        if (!intro && tween && Conductor.songPosition >= 4000) {
            intro = true;
            tween = false;
            FlxTween.tween(camOther, {alpha: 0}, 7);
            FlxTween.tween(CyclesCircle, {alpha: 0}, 5, {ease: FlxEase.expoOut});
            FlxTween.tween(CyclesText, {alpha: 0}, 5, {ease: FlxEase.expoOut});
        }

        if (!coolevent && Conductor.songPosition >= 101400) {
            coolevent = true;
            camHUD.alpha = 0;
            camOther.alpha = 1;
        }

        if (!coolevent2 && Conductor.songPosition >= 103079) {
            coolevent2 = true;
            camHUD.alpha = 1;
            camOther.alpha = 0;
        }

        if (Conductor.songPosition >= 103079) {
            camHUD.angle = Math.sin(Conductor.songPosition / 1000) * 2;
        }

        if (!end && Conductor.songPosition >= 152325) {
            end = true;
            FlxG.cameras.remove(camHUD, false); 
            FlxG.cameras.add(camHUD, false);
            FlxG.cameras.remove(camAA, false); 
            FlxG.cameras.add(camAA, false);
            camAA.alpha = 0;
            FlxTween.tween(camOther, {alpha: 1}, 1);
        }
        
        if (Conductor.songPosition >= 154000) {
            FlxTween.tween(camAA, {alpha: 1}, 1);
        }
    }
    
    else if (PlayState.difficulty == "normal") {
        
        if (!tween && Conductor.songPosition >= 1000) {
            tween = true;
            FlxTween.tween(CyclesCircle, {x: 0}, 4, {ease: FlxEase.expoOut});
            FlxTween.tween(CyclesText, {x: 0}, 4, {ease: FlxEase.expoOut});
        }
        
        if (!intro && tween && Conductor.songPosition >= 4000) {
            intro = true;
            tween = false;
            FlxTween.tween(camOther, {alpha: 0}, 7);
            FlxTween.tween(CyclesCircle, {alpha: 0}, 5, {ease: FlxEase.expoOut});
            FlxTween.tween(CyclesText, {alpha: 0}, 5, {ease: FlxEase.expoOut});
        }

        if (!coolevent && Conductor.songPosition >= 104625) {
            coolevent = true;
            camHUD.alpha = 0;
            camOther.alpha = 1;
        }

        if (!coolevent2 && Conductor.songPosition >= 106250) {
            coolevent2 = true;
            camHUD.alpha = 1;
            camOther.alpha = 0;
        }

        if (Conductor.songPosition >= 106250) {
            camHUD.angle = Math.sin(Conductor.songPosition / 1000) * 2;
        }

        if (!end && Conductor.songPosition >= 142950) {
            end = true;
            FlxG.cameras.remove(camHUD, false); 
            FlxG.cameras.add(camHUD, false);
            FlxG.cameras.remove(camAA, false); 
            FlxG.cameras.add(camAA, false);
            camAA.alpha = 0;
            FlxTween.tween(camOther, {alpha: 1}, 1);
        }
        
        if (Conductor.songPosition >= 144000) {
            FlxTween.tween(camAA, {alpha: 1}, 1);
        }
    }
}

function onDadHit(event) {
    if (health > 0.25)
        health -= 0.01;
}