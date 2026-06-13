// Original code by Jloor, Expanded by sossy baka769 (added matrix distorting and some extra variables) //
// Revamped by Misthx && ChanceXML //
import flixel.addons.effects.FlxSkewedSprite;
import funkin.backend.shaders.CustomShader;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.display.BlendMode;

class Shadow {
    public var visible:Bool = true;
    public var alpha:Float = 0.35;
    public var color:FlxColor = 0xFF000000;
    
    // Position and Distortion
    public var offset:FlxPoint = FlxPoint.get(0, 0);
    public var skew:FlxPoint = FlxPoint.get(0, 0);
    public var scale:FlxPoint = FlxPoint.get(1, 1); // Controls width (x) and height (y)
    public var angle:Float = 0; // Rotation offset
    
    // Advanced Rendering
    public var transformMatrix:FlxMatrix = new FlxMatrix(1, 0, 0, 1, 0, 0);
    public var matrixExposed:Bool = false;
    public var flipX:Bool = false;
    public var flipY:Bool = true;
    public var blend:BlendMode = null;
    public var shader:CustomShader = null;

    private var curSprite:FlxSkewedSprite;

    public function new(sprite:FlxSkewedSprite) {
        curSprite = sprite;
        curSprite.onDraw = drawFunction;
    }   

    private function drawFunction(sprite:FlxSkewedSprite) {
        if (!visible) {
            sprite.onDraw = null;
            sprite.draw();
            sprite.onDraw = drawFunction;
            return;
        }

        // Save original sprite state
        var previousVars = {
            x: sprite.x,
            y: sprite.y,
            scaleX: sprite.scale.x,
            scaleY: sprite.scale.y,
            skewX: sprite.skew.x,
            skewY: sprite.skew.y,
            matrix: sprite.transformMatrix,
            exposed: sprite.matrixExposed,
            angle: sprite.angle,
            flipX: sprite.flipX,
            flipY: sprite.flipY,
            frameOffsetX: sprite.frameOffset.x,
            frameOffsetY: sprite.frameOffset.y,
            forceIsOnScreen: sprite.forceIsOnScreen,
            alpha: sprite.alpha,
            color: sprite.color,
            shader: sprite.shader,
            blend: sprite.blend
        };

        // Apply shadow transformations
        sprite.flipX = flipX;
        sprite.flipY = flipY;
        sprite.frameOffset.x = (sprite.flipX ? (sprite.frameWidth - sprite.frameOffset.x) : sprite.frameOffset.x);
        sprite.frameOffset.y = (sprite.flipY ? (sprite.frameHeight - sprite.frameOffset.y) : sprite.frameOffset.y);
        
        sprite.x += offset.x;
        sprite.y += sprite.height * 2 + offset.y;
        
        sprite.scale.x *= scale.x; 
        sprite.scale.y *= scale.y; 
        sprite.skew.x = skew.x;
        sprite.skew.y = skew.y;
        sprite.transformMatrix = transformMatrix;
        sprite.matrixExposed = matrixExposed;
        sprite.angle += angle; 
        
        sprite.alpha *= alpha;
        sprite.color = color;
        sprite.blend = blend;
        if (shader != null) sprite.shader = shader;
        sprite.forceIsOnScreen = true;

        // Draw shadow (detach onDraw to avoid loop crashes)
        sprite.onDraw = null;
        sprite.draw();

        // Restore original properties
        sprite.x = previousVars.x;
        sprite.y = previousVars.y;
        sprite.scale.x = previousVars.scaleX;
        sprite.scale.y = previousVars.scaleY;
        sprite.skew.x = previousVars.skewX;
        sprite.skew.y = previousVars.skewY;
        sprite.transformMatrix = previousVars.matrix;
        sprite.matrixExposed = previousVars.exposed;
        sprite.angle = previousVars.angle;
        sprite.flipX = previousVars.flipX;
        sprite.flipY = previousVars.flipY;
        sprite.frameOffset.x = previousVars.frameOffsetX;
        sprite.frameOffset.y = previousVars.frameOffsetY;
        sprite.forceIsOnScreen = previousVars.forceIsOnScreen;
        sprite.alpha = previousVars.alpha;
        sprite.color = previousVars.color;
        sprite.shader = previousVars.shader;
        sprite.blend = previousVars.blend;
        
        // Draw original sprite and reattach
        sprite.draw();
        sprite.onDraw = drawFunction;
    }

    public function changeSprite(sprite:FlxSkewedSprite) {
        if (curSprite != null) curSprite.onDraw = null;
        sprite.onDraw = drawFunction;
        curSprite = sprite;
    }
    
    public function destroy() {
        if (curSprite != null) curSprite.onDraw = null;
        curSprite = null;
        shader = null;
    }
}
