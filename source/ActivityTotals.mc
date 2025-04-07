import Toybox.Time;
import Toybox.UserProfile;
import Toybox.Lang;
import Toybox.System;

class ActivityTotals {
    static var weekDistance = 0.00;
    static var monthDistance = 0.00;
    static var yearDistance = 0.00;
    
    static const YEAR_GOAL = 1000.00;

    public static function update() {
        weekDistance = 0.00;
        monthDistance = 0.00;
        yearDistance = 0.00;

        // TEST DATA
        // weekDistance = 18.60;
        // monthDistance = 36.20;
        // yearDistance = 300.40;
        // return;
        
        // System.println(Lang.format("$1$:$2$: recalculating totals", [info.hour, info.min]));

        var now = new Time.Moment(Time.now().value());        
        var info = Gregorian.info(now, Time.FORMAT_SHORT);

        var currentWeekNumber = Utils.iso_week_number(info.year, info.month, info.day);
        var currentMonth = info.month;
        var currentYear = info.year;

        // Get run activities
        var userActivityIterator = UserProfile.getUserActivityHistory();
        var userActivity = userActivityIterator.next();
        while (userActivity != null) {
            if(userActivity.type == 1) {
                var activityInfo = Gregorian.info(userActivity.startTime, Time.FORMAT_SHORT);                
                var activityYear = activityInfo.year; 

                if(activityYear == currentYear) {
                    var distance = userActivity.distance / 1000.00;
                    yearDistance += distance;

                    var activityWeekNumber = Utils.iso_week_number(activityYear, activityInfo.month, activityInfo.day);

                    if(activityWeekNumber == currentWeekNumber) {
                        weekDistance += distance;
                    }

                    var activityMonth = activityInfo.month;
                    if(activityMonth == currentMonth) {
                        monthDistance += distance;
                    }
                }
            }

            userActivity = userActivityIterator.next();
        }
    }
}