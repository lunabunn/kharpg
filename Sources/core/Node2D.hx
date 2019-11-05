package core;

import kha.graphics2.Graphics;

/**
 * Base 2D node class
 */
class Node2D extends Node {
    public var x: Float;
    public var y: Float;
    
    public function new(x: Float=0, y: Float=0) {
        super();
        this.x = x;
        this.y = y;
    }

    override public function render(g: Graphics) {
        g.translate(x, y);
        super.render(g);
        g.translate(-x, -y);
    }
}