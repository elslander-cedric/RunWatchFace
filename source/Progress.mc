import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

class Progress extends WatchUi.Drawable {    
    private var _type;
    private var _radius;

    function initialize(params as Dictionary) {
        Drawable.initialize(params);

        _type = params[:type];
        _radius = params[:radius];
    }
    
    function draw(dc as Dc) as Void {
        var progress = 0;

        if(_type.equals("year")) {
            progress = ActivityTotals.yearDistance / ActivityTotals.yearGoal;
        } else if(_type.equals("month")) {
            progress = ActivityTotals.monthDistance / (ActivityTotals.yearGoal/12);
        } else if(_type.equals("week")) {
            progress = ActivityTotals.weekDistance / (ActivityTotals.yearGoal/52);
        }

        drawProgress(dc, progress);
    }

    function drawProgress(dc as Dc, progress) {
        if(progress == 0) {
            return;
        }
        if(progress >= 1) {
            progress = 0;
        }
        dc.setPenWidth(4);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(0.5 * dc.getWidth(), 0.5 * dc.getHeight(), _radius, Graphics.ARC_COUNTER_CLOCKWISE, 0, 360 * progress);        
    }
}