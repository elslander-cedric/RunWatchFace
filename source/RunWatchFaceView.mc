import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class RunWatchFaceView extends WatchUi.WatchFace {

    // Labels
    private var
        dateLabel,
        hourLabel, minLabel,
        distanceLabel;

    private static const TIME_FORMAT = "%02d";
    private static const DEC_FORMAT = "%.1f";

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

        var width = dc.getWidth();
        var height = dc.getHeight();

        var centerX = width/2;
        var centerY = height/2;
        
        dateLabel = View.findDrawableById("date") as Text;
        dateLabel.setLocation(centerX+4, 137);

        hourLabel = View.findDrawableById("hour") as Text;
        hourLabel.setLocation(centerX-4, centerY);        
        minLabel = View.findDrawableById("min") as Text;
        minLabel.setLocation(centerX+4, 95);        
        distanceLabel = View.findDrawableById("distance_status") as Text;       
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        ActivityTotals.update();
        
        var now = new Time.Moment(Time.now().value());        
        var info = Gregorian.info(now, Time.FORMAT_MEDIUM);

        dateLabel.setText(Lang.format("$1$ $2$", [info.day_of_week.toUpper(), info.day]));

        hourLabel.setText(info.hour.format(TIME_FORMAT));
        minLabel.setText(info.min.format(TIME_FORMAT));

        var beginOfYear = Gregorian.moment({
            :year   => info.year,
            :month  => 1,
            :day    => 1,
            :hour   => 0,
            :minute => 0
        });

        var distance = ActivityTotals.yearDistance - ((((now.value() - beginOfYear.value()) / 3600) / (365.00 * 24)) * ActivityTotals.YEAR_GOAL);

        if(distance < 0) {
            distance *= -1;
            distanceLabel.setColor(Graphics.COLOR_RED);
        } else {
            distanceLabel.setColor(Graphics.COLOR_GREEN);
        }
        distanceLabel.setText(distance.format(DEC_FORMAT));

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
