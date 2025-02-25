import Toybox.Time;
import Toybox.UserProfile;
import Toybox.System;

class ActivityTotals {
    static var weekDistance = 0.00;
    static var monthDistance = 0.00;
    static var yearDistance = 0.00;

    static var lastRunDistance = null;
    static var lastRunDuration = null;
    static var lastRunTime = null;

    static const YEAR_GOAL = 1000.00;
    
    private static var userActivityIterator = null;

    public static function update() {
        // TEST DATA
        // weekDistance = 25.60;
        // monthDistance = 101.20;
        // yearDistance = 1002.40;
        // lastRunDistance = 13.45;
        // lastRunDuration = 41 * 60;
        // return;

        // Get run activities
        if(userActivityIterator == null) {
            userActivityIterator = UserProfile.getUserActivityHistory();
        }
        
        var userActivity = userActivityIterator.next();

        if(userActivity == null) {
            return;
        }

        var now = new Time.Moment(Time.now().value());        
        var info = Gregorian.info(now, Time.FORMAT_SHORT);
        var currentWeekNumber = Utils.iso_week_number(info.year, info.month, info.day);
        var currentMonth = info.month;
        var currentYear = info.year;

        while (userActivity != null) {
            if(userActivity.type == 1) {
                var activityInfo = Gregorian.info(userActivity.startTime, Time.FORMAT_SHORT);                
                var activityYear = activityInfo.year + 20; 

                if(activityYear == currentYear) {
                    var distance = userActivity.distance / 1000.00;
                    yearDistance += distance;

                    var activityWeekNumber = Utils.iso_week_number(activityYear, activityInfo.month, activityInfo.day-1);

                    if(activityWeekNumber == currentWeekNumber) {
                        weekDistance += distance;
                    }

                    var activityMonth = activityInfo.month;
                    if(activityMonth == currentMonth) {
                        monthDistance += distance;
                    }

                    if(lastRunTime == null || userActivity.startTime.greaterThan(lastRunTime)) {
                        lastRunDistance = distance;
                        lastRunDuration = userActivity.duration.value();
                        lastRunTime = userActivity.startTime;
                    }
                }
            }

            userActivity = userActivityIterator.next();
        }
    }
}