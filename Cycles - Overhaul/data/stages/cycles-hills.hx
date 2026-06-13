var overlay:FlxSprite;

function create() {
    overlay = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/lord x/overlay'));
    overlay.scale.set(1.1, 1.1);
    overlay.cameras = [camHUD];
    add(overlay);
}