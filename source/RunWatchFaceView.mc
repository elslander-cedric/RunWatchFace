import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class RunWatchFaceView extends WatchUi.WatchFace {

    enum {
        LAST_RUN,
        PROGRESS_DONE,
        PROGRESS_TODO
    }

    private var displayMode = PROGRESS_DONE;

    // Labels
    private var dateLabel, hourLabel, minLabel, leftLabel, middleLabel, rightLabel, distanceLabel;

    private static const TIME_FORMAT = "%02d";
    private static const INT_FORMAT = "%.0f";
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
        var timeY = centerY-40;
        var activityY = (height*2/3)-5;

        // Date
        dateLabel = View.findDrawableById("date") as Text;

        // Time
        hourLabel = View.findDrawableById("hour") as Text;
        hourLabel.setLocation(centerX-4, timeY);        
        minLabel = View.findDrawableById("min") as Text;
        minLabel.setLocation(centerX+4, timeY);

        // Activities
        leftLabel = View.findDrawableById("activity_left") as Text;
        leftLabel.setLocation((width/4)+7, activityY);
        middleLabel = View.findDrawableById("activity_middle") as Text;
        middleLabel.setLocation(centerX, activityY);
        rightLabel = View.findDrawableById("activity_right") as Text;
        rightLabel.setLocation((width*3/4)-7, activityY);

        distanceLabel = View.findDrawableById("distance_status") as Text;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // DATE & TIME
        displayDateTime();

        // ACTIVITIES
        displayActivities();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    function displayDateTime() {
        var now = new Time.Moment(Time.now().value());        
        var info = Gregorian.info(now, Time.FORMAT_MEDIUM);

        dateLabel.setText(Lang.format("$1$ $2$ $3$", [info.day_of_week.toString().toUpper(), info.day, info.month.toString().toUpper()]));
        hourLabel.setText(info.hour.format(TIME_FORMAT));
        minLabel.setText(info.min.format(TIME_FORMAT));
    }

    function displayActivities() {
        ActivityTotals.update();

        switch (displayMode) {
            case LAST_RUN:
                displayLastRun();
                break;
            case PROGRESS_DONE:
                displayProgressDone();
                break;
            case PROGRESS_TODO:
                displayProgressTodo();
                break;
            default:
                displayProgressDone();
                break;
        }

        switchDisplayMode();        
        displayDistance();
    }

    function displayProgressTodo() {
        var week = (ActivityTotals.yearGoal/52) - ActivityTotals.weekDistance;
        var month = (ActivityTotals.yearGoal/12) - ActivityTotals.monthDistance;
        var year = ActivityTotals.yearGoal - ActivityTotals.yearDistance;

        if(week < 0) { week = 0; }
        if(month < 0) { month = 0; }
        if(year < 0) { year = 0; }

        leftLabel.setText(week.format(DEC_FORMAT));
        middleLabel.setText(month.format(DEC_FORMAT));
        rightLabel.setText(year.format(INT_FORMAT));
        setColor([leftLabel, middleLabel, rightLabel], Graphics.COLOR_RED);
    }

    function displayProgressDone() {
        leftLabel.setText(ActivityTotals.weekDistance.format(DEC_FORMAT));
        middleLabel.setText(ActivityTotals.monthDistance.format(DEC_FORMAT));
        rightLabel.setText(ActivityTotals.yearDistance.format(INT_FORMAT));
        setColor([leftLabel, middleLabel, rightLabel], Graphics.COLOR_GREEN);
    }

    function displayLastRun() {
        var runTotalMinutes = ActivityTotals.lastRunDuration/60;
        var runHour = runTotalMinutes/60;
        var runMinutes = runTotalMinutes.toNumber() % 60;

        var speed = 0;

        if(ActivityTotals.lastRunDuration != null && ActivityTotals.lastRunDistance != null) {
            speed = ActivityTotals.lastRunDuration/ActivityTotals.lastRunDistance;
        }
        
        var speedMinutes = speed/60;
        var speedSeconds = speed.toNumber() % 60;

        leftLabel.setText(ActivityTotals.lastRunDistance.format(DEC_FORMAT));
        middleLabel.setText(speedMinutes.format(TIME_FORMAT) + ":" + speedSeconds.format(TIME_FORMAT));
        rightLabel.setText(runHour.format(TIME_FORMAT) + ":" + runMinutes.format(TIME_FORMAT));
        setColor([leftLabel, middleLabel, rightLabel], Graphics.COLOR_YELLOW);
    }

    function switchDisplayMode() {
        switch (displayMode) {
            case LAST_RUN:
                displayMode = PROGRESS_DONE;
                break;
            case PROGRESS_DONE:
                displayMode = PROGRESS_TODO;
                break;
            case PROGRESS_TODO:
                displayMode = LAST_RUN;
                break;
            default:
                displayMode = PROGRESS_DONE;
                break;
        }
    }

    function displayDistance() {
        var distance = ActivityTotals.getCurrentDistance();
        if(distance < 0) {
            distance *= -1;
            distanceLabel.setColor(Graphics.COLOR_RED);
        } else {
            distanceLabel.setColor(Graphics.COLOR_GREEN);
        }
        distanceLabel.setText(distance.format(DEC_FORMAT));
    }

    function setColor(labels as Array<Text>, color as Number) {
        for(var i = 0; i < labels.size(); i++) {
            labels[i].setColor(color);
        }
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
