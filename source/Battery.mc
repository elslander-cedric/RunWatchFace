import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

class Battery extends WatchUi.Drawable {    

    function initialize(params as Dictionary) {
        Drawable.initialize(params);
    }
    
    function draw(dc as Dc) as Void {
        var x = 92;
        var y = 30;
        var w = 24;
        var h = 14;

        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x, y, w, h);

        dc.setPenWidth(2);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x + w, y + (h * 3/8), w / 10, (h / 4) + 3);

        var batteryLevel = System.getSystemStats().battery / 100;
        // FOR TESTING
        // batteryLevel = 0.1;

        var color;
        if (batteryLevel <= 0.1) {
            color = Graphics.COLOR_RED;
        }
        else {
            color = Graphics.COLOR_GREEN;
        }

        dc.setColor(color, color);
        dc.fillRectangle(x + 2, y + 2, (w - 4) * batteryLevel, h - 4);
    }
}