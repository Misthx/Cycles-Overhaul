import flixel.util.FlxColor;
import StringTools;
import Shadow;
import haxe.ds.StringMap;

var activeShadows:StringMap<Dynamic> = new StringMap();

var exactBlacklist:Array<String> = [
    "neighbor"
];

var prefixBlacklist:Array<String> = [
    "somerandomguy"
];

function postCreate() {
    refreshAllShadows();
}

function onChangeCharacter(charType:String) {
    refreshAllShadows();
}

function deservesShadow(charName:String):Bool {
    if (charName == null) return false;
    if (exactBlacklist.contains(charName)) return false;

    for (prefix in prefixBlacklist) {
        if (StringTools.startsWith(charName, prefix)) {
            return false;
        }
    }
    return true;
}

function safeKillShadow(id:String, charObj:Dynamic) {
    if (activeShadows.exists(id)) {
        var sh:Dynamic = activeShadows.get(id);
        if (sh != null) {
            sh.destroy();
        }
        activeShadows.remove(id);
    }
}

function processCharacterShadow(charObj:Dynamic, id:String) {
    if (charObj == null) return;

    var charName:String = charObj.curCharacter;

    if (!deservesShadow(charName)) {
        safeKillShadow(id, charObj);
        return;
    }

    var sh:Dynamic = null;
    if (activeShadows.exists(id)) {
        sh = activeShadows.get(id);
        if (charObj.onDraw == null) {
            sh.changeSprite(charObj); 
        }
    } else {
        sh = new Shadow(charObj);
        activeShadows.set(id, sh);
    }

    sh.visible = true;
    sh.color = FlxColor.BLACK;
    sh.alpha = 0.2;
    sh.offset.set(0, 0);
    sh.angle = 0;
    sh.shader = null;
    sh.blend = null;
    if (sh.skew != null) sh.skew.set(0, 0);
    if (sh.scale != null) sh.scale.set(1, 1);

    switch (charName) {
        case "bf":
            sh.offset.set(175, 100);
            if (sh.skew != null) sh.skew.x = 14;
            //if (sh.scale != null) sh.scale.x = 1.1;
            
        case "lordx":
            sh.offset.set(425, 970);
            if (sh.skew != null) sh.skew.x = 14;
            //if (sh.scale != null) sh.scale.x = 1.1;
    }
}

function refreshAllShadows() {
    if (dad != null) processCharacterShadow(dad, "dad");
    if (boyfriend != null) processCharacterShadow(boyfriend, "bf");
    if (gf != null) processCharacterShadow(gf, "gf");
}

function update(elapsed:Float) {
    refreshAllShadows();
}
