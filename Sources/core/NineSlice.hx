package core;

import kha.Image;
import kha.graphics2.Graphics;

/**
 * Node that draws a nineslice rectangle on the screen
 */
class NineSlice extends Node2D {
    public var source(default, set): Image;
    private var dest: Image;

    private var invalidated: Bool = false;

    public var leftWidth(default, set): Int = 10;
    public var topWidth(default, set): Int = 10;
    public var rightWidth(default, set): Int = 10;
    public var bottomWidth(default, set): Int = 10;
    public var width(default, set): Float = 100;
    public var height(default, set): Float = 100;

    function set_source(source: Image) {
        invalidated = true;
        return this.source = source;
    }

    function set_leftWidth(x: Int) {
        invalidated = true;
        return leftWidth = x;
    }

    function set_topWidth(x: Int) {
        invalidated = true;
        return topWidth = x;
    }
    
    function set_rightWidth(x: Int) {
        invalidated = true;
        return rightWidth = x;
    }

    function set_bottomWidth(x: Int) {
        invalidated = true;
        return bottomWidth = x;
    }

    function set_width(width: Float) {
        if (width > dest.width)
            dest = Image.createRenderTarget(Math.ceil(width), Math.ceil(height));
        invalidated = true;
        return this.width = width;
    }

    function set_height(height: Float) {
        if (height > dest.height)
            dest = Image.createRenderTarget(Math.ceil(width), Math.ceil(height));
        invalidated = true;
        return this.height = height;
    }
    
    public function new(x: Float=0, y: Float=0, source: Image, leftWidth: Int=10, topWidth: Int=10, rightWidth: Int=10, bottomWidth: Int=10, width: Float=100, height: Float=100) {
        super(x, y);
        this.source = source;
        dest = Image.createRenderTarget(Math.ceil(width), Math.ceil(height));

        this.leftWidth = leftWidth;
        this.topWidth = topWidth;
        this.rightWidth = rightWidth;
        this.bottomWidth = bottomWidth;
        this.width = width;
        this.height = height;
    }

    function redraw(g: Graphics) {
        var _leftWidth: Float, _topWidth: Float, _rightWidth: Float, _bottomWidth: Float;
        
        if (leftWidth + rightWidth < width) {
            _leftWidth = leftWidth;
            _rightWidth = rightWidth;
        } else if (leftWidth != rightWidth && width > Math.min(leftWidth, rightWidth) * 2) {
            if (leftWidth < rightWidth) {
                _leftWidth = leftWidth;
                _rightWidth = width - leftWidth;
            } else {
                _leftWidth = width - rightWidth;
                _rightWidth = rightWidth;
            }
        } else {
            _leftWidth = Math.min(width / 2, leftWidth);
            _rightWidth = width - _leftWidth;
        }

        if (topWidth + bottomWidth < height) {
            _topWidth = topWidth;
            _bottomWidth = bottomWidth;
        } else if (topWidth != bottomWidth && height > Math.min(topWidth, bottomWidth) * 2) {
            if (topWidth < bottomWidth) {
                _topWidth = topWidth;
                _bottomWidth = height - topWidth;
            } else {
                _topWidth = height - bottomWidth;
                _bottomWidth = bottomWidth;
            }
        } else {
            _topWidth = Math.min(height / 2, topWidth);
            _bottomWidth = height - _topWidth;
        }

        g.begin(kha.Color.Transparent);

        g.drawSubImage(source, 0, 0, 0, 0, _rightWidth, _topWidth);
        g.drawSubImage(source, width - _rightWidth, 0, source.width - _rightWidth, 0, _rightWidth, _topWidth);
        g.drawSubImage(source, 0, height - _bottomWidth, 0, source.height - _bottomWidth, _leftWidth, _bottomWidth);
        g.drawSubImage(source, width - _rightWidth, height - _bottomWidth, source.width - _rightWidth, source.height - _bottomWidth, _rightWidth, _bottomWidth);

        if (leftWidth + rightWidth < width) {
            g.drawScaledSubImage(source, leftWidth, 0, source.width - leftWidth - rightWidth, _topWidth, leftWidth, 0, width - leftWidth - rightWidth, _topWidth);
            g.drawScaledSubImage(source, leftWidth, source.height - _bottomWidth, source.width - leftWidth - rightWidth, _bottomWidth, leftWidth, height - _bottomWidth, width - leftWidth - rightWidth, _bottomWidth);
        }

        if (topWidth + bottomWidth < height) {
            g.drawScaledSubImage(source, 0, topWidth, _leftWidth, source.height - topWidth - bottomWidth, 0, topWidth, _leftWidth, height - topWidth - bottomWidth);
            g.drawScaledSubImage(source, source.width - _rightWidth, topWidth, _rightWidth, source.height - topWidth - bottomWidth, width - _rightWidth, topWidth, _rightWidth, height - topWidth - bottomWidth);
        }

        if (leftWidth + rightWidth < width && topWidth + bottomWidth < height) {
            g.drawScaledSubImage(source, leftWidth, topWidth, source.width - leftWidth - rightWidth, source.height - topWidth - bottomWidth, leftWidth, topWidth, width - leftWidth - rightWidth, height - topWidth - bottomWidth);
        }

        g.end();
    }

    override public function prerender() {
        if (invalidated) {
            redraw(dest.g2);
            invalidated = false;
        }
    }

    override public function render(g: Graphics) {
        g.drawImage(dest, x, y);
        super.render(g);
    }
}