package core;

import kha.Image;
import kha.graphics2.Graphics;

/**
 * Node that draws an image on the screen
 */
class Sprite extends Node2D {
    public var image: Image;
    
    public function new(x: Float=0, y: Float=0, image: Image) {
        super(x, y);
        this.image = image;
    }

    override public function render(g: Graphics) {
        g.drawImage(image, x, y);
        // TODO Current implementation is extremely barebones; implement rotation, scaling, etc.
        super.render(g);
    }
}