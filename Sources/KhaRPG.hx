package;

import kha.Window;
import kha.FastFloat;
import kha.Image;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class KhaRPG {
    public static inline var TITLE: String = "KhaRPG";
    public static inline var WIDTH: Int = 640;
    public static inline var HEIGHT: Int = 480;
    public static inline var GRID_WIDTH: Int = 32;
    public static inline var GRID_HEIGHT: Int = 32;

    public static inline var ASPECT_RATIO: Float = WIDTH / HEIGHT;
    static var windowWidthPrev: Int = WIDTH;
    static var windowHeightPrev: Int = HEIGHT;
    static var timePrev: Float = 0;

    public static var window(default, null): Window;
    public static var root(default, set): core.Node;

    static var backbuffer: Image;
    static var dx: FastFloat = 0;
    static var dy: FastFloat = 0;
    static var dw: FastFloat = WIDTH;
    static var dh: FastFloat = HEIGHT;

    static inline function set_root(x: core.Node) {
        if ((root = x) == null)
            backbuffer.g2.clear();
        return x;
    }

    static function init() {
        // root = new core.Node2D(100, 100);
        // root.addChild(new core.NineSlice(Assets.images.nineslice, 16, 35, 16, 16));
    }

	static function update(dt: Float): Void {
        if (window.width != windowWidthPrev
            || window.height != windowHeightPrev)
            resize(window.width, window.height);
        
        if (root != null)
            root.update(dt);
	}

	static function render(frame: Framebuffer): Void {
        if (root != null) {
            root.prerender();
            backbuffer.g2.color = kha.Color.White;
            backbuffer.g2.begin();
            root.render(backbuffer.g2);
            backbuffer.g2.end();
        }

        frame.g2.begin();
        frame.g2.drawScaledImage(backbuffer, dx, dy, dw, dh);
        frame.g2.end();
	}

    static function resize(w: Int, h: Int) {
        trace(w, h);
        var screenRatio: Float = w / h;
        if (screenRatio > ASPECT_RATIO) {
            dw = ASPECT_RATIO * h;
            dh = h;
            dx = (w - dw) / 2;
            dy = 0;
        } else if (screenRatio < ASPECT_RATIO) {
            dw = w;
            dh = w / ASPECT_RATIO;
            dx = 0;
            dy = (h - dh) / 2;
        } if (screenRatio == ASPECT_RATIO) {
            dw = w;
            dh = h;
            dx = 0;
            dy = 0;
        }
    }

	public static function main() {
		System.start({title: TITLE, width: WIDTH, height: HEIGHT}, function (_window) {
			Assets.loadEverything(function () {
                backbuffer = Image.createRenderTarget(WIDTH, HEIGHT);
                window = _window;
                init();
                Scheduler.addTimeTask(function () { var newTime = Scheduler.time(); update((newTime - timePrev) * 60); timePrev = newTime; }, 0, 1 / 60);
				System.notifyOnFrames(function (frames) { render(frames[0]); });
			});
		});
	}
}
