import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class RunWatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        var centerX = width/2;
        var centerY = height/2;

        // DATE & TIME
        var now = new Time.Moment(Time.now().value());        
        var info = Gregorian.info(now, Time.FORMAT_MEDIUM);

        var date = View.findDrawableById("date") as Text;
        date.setText(Lang.format("$1$ $2$ $3$", [info.day_of_week.toString().toUpper(), info.day, info.month.toString().toUpper()]));

        var hour = View.findDrawableById("hour") as Text;
        hour.setText(info.hour.format("%02d"));
        hour.setLocation(centerX-4, centerY-(hour.height/2)-1);
        
        var min = View.findDrawableById("min") as Text;        
        min.setText(info.min.format("%02d"));
        min.setLocation(centerX+4, centerY-(min.height/2)-1);

        // ACTIVITIES
        ActivityTotals.update();

        var distanceLabel = View.findDrawableById("distance") as Text;
        var distance = ActivityTotals.getCurrentDistance();
        if(distance < 0) {
            distance *= -1;
            distanceLabel.setColor(Graphics.COLOR_RED);
        } else {
            distanceLabel.setColor(Graphics.COLOR_GREEN);
        }

        distanceLabel.setText(distance.format("%.1f"));

        var distanceLabelWeek = View.findDrawableById("distance_week") as Text;
        distanceLabelWeek.setLocation((width/4)+7, (height*2/3)-5);
        distanceLabelWeek.setText(ActivityTotals.weekDistance.format("%.0f"));

        var distanceLabelMonth = View.findDrawableById("distance_month") as Text;
        distanceLabelMonth.setLocation(centerX, (height*2/3)-5);
        distanceLabelMonth.setText(ActivityTotals.monthDistance.format("%.0f"));

        var distanceLabelYear = View.findDrawableById("distance_year") as Text;
        distanceLabelYear.setLocation((width*3/4)-7, (height*2/3)-5);
        distanceLabelYear.setText(ActivityTotals.yearDistance.format("%.0f"));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }
}
