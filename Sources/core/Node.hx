package core;

import kha.graphics2.Graphics;

/**
 * Base node class
 */
class Node {
    public var parent: Node = null;
    public var children: Array<Node> = new Array<Node>();
    
    inline public function new() {}

    public inline function addChild(node: Node) {
        node.parent = this;
        children.push(node);
    }

    public inline function removeChild(node: Node) {
        node.parent = null;
        children.remove(node);
    }

    public inline function removeChildAt(index: Int) {
        children.splice(index, 1)[0].parent = null;
    }

    public inline function getChildAt(index: Int) {
        return children[index];
    }

    public function update(dt: Float) {
        for (child in children) {
            child.update(dt);
        }
    }

    public function prerender() {
        for (child in children) {
            child.prerender();
        }
    }

    public function render(g: Graphics) {
        for (child in children) {
            child.render(g);
        }
    }
}