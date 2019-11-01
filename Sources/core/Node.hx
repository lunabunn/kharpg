package core;

import kha.graphics2.Graphics;

/**
 * Base node class
 */
class Node {
    public var parent: Node = null;
    public var children: Array<Node> = new Array<Node>();
    
    inline public function new() {}

    public function addChild(node: Node) {
        node.parent = this;
        children.push(node);
    }

    public function removeChild(node: Node) {
        node.parent = null;
        children.remove(node);
    }

    public function removeChildAt(index: Int) {
        children.splice(index, 1)[0].parent = null;
    }

    public function render(g: Graphics) {
        for (child in children) {
            child.render(g);
        }
    }
}