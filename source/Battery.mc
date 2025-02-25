import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

class Battery extends WatchUi.Drawable {    

    private const x1=92, y1=30, w1=24, h1=14; // outer rectangle
    private const x2=x1+w1, y2=y1 + (h1*3/8), w2=w1/10, h2=(h1/4)+3; // little rectangle on the right side
    private const x3=x1+2, y3=y1+2, w3=w1-4, h3=h1-4; // fill rectangle

    function initialize(params as Dictionary) {
        Drawable.initialize(params);
    }
    
    function draw(dc as Dc) as Void {
        var batteryLevel = System.getSystemStats().battery / 100;
        // FOR TESTING
        // batteryLevel = 0.1;

        var borderColor, fillColor;
        if (batteryLevel <= 0.1) {
            borderColor = Graphics.COLOR_RED;
            fillColor = Graphics.COLOR_RED;
        } else {
            borderColor = Graphics.COLOR_WHITE;
            fillColor = Graphics.COLOR_GREEN;
        }

        dc.setPenWidth(1);
        dc.setColor(borderColor, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x1, y1, w1, h1);

        dc.setPenWidth(2);
        dc.setColor(borderColor, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x2, y2, w2, h2);

        dc.setColor(fillColor, fillColor);
        dc.fillRectangle(x3, y3, w3 * batteryLevel, h3);
    }
}