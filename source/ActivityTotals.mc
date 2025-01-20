import Toybox.Time;
import Toybox.UserProfile;

class ActivityTotals {

    static var weekDistance = 0.00;
    static var monthDistance = 0.00;
    static var yearDistance = 0.00;

    static var yearGoal = 1000.00;

    public static function getCurrentDistance() {
        var now = new Time.Moment(Time.now().value());        
        var info = Gregorian.info(now, Time.FORMAT_SHORT);

        var beginOfYear = Gregorian.moment({
            :year   => info.year,
            :month  => 1,
            :day    => 1,
            :hour   => 0,
            :minute => 0
        });

        return yearDistance - ((((now.value() - beginOfYear.value()) / 3600) / (365.00 * 24)) * yearGoal);
    }

    public static function update() {
        // reset totals 
        weekDistance = 14.00;
        monthDistance = 46.00;
        yearDistance = 282.00;

        var now = new Time.Moment(Time.now().value());        
        var info = Gregorian.info(now, Time.FORMAT_SHORT);
        var currentWeekNumber = iso_week_number(info.year, info.month, info.day);
        var currentMonth = info.month;
        var currentYear = info.year;

        // Get run activities
        var userActivityIterator = UserProfile.getUserActivityHistory();
        var userActivity = userActivityIterator.next();
        while (userActivity != null) {
            if(userActivity.type == 1) {
                var activityInfo = Gregorian.info(userActivity.startTime, Time.FORMAT_SHORT);                
                var activityYear = activityInfo.year + 20; 

                if(activityYear == currentYear) {
                    var distance = userActivity.distance / 1000.00;
                    yearDistance += distance;

                    var activityWeekNumber = iso_week_number(activityYear, activityInfo.month, activityInfo.day);
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

        // TEST DATA
        // weekDistance = 18.00;
        // monthDistance = 88.00;
        // yearDistance = 188.00;
    }

    private static function julian_day(year, month, day)
    {
        var a = (14 - month) / 12;
        var y = (year + 4800 - a);
        var m = (month + 12 * a - 3);
        return day + ((153 * m + 2) / 5) + (365 * y) + (y / 4) - (y / 100) + (y / 400) - 32045;
    }

    private static function is_leap_year(year) {
        if (year % 4 != 0) {
            return false;
        } else if (year % 100 != 0) {
            return true;
        } else if (year % 400 == 0) {
            return true;
        }

        return false;
    }

    private static function iso_week_number(year, month, day) {
        var first_day_of_year = julian_day(year, 1, 1);
        var given_day_of_year = julian_day(year, month, day);

        var day_of_week = (first_day_of_year + 3) % 7; // days past thursday
        var week_of_year = (given_day_of_year - first_day_of_year + day_of_week + 4) / 7;

        // week is at end of this year or the beginning of next year
        if (week_of_year == 53) {
            if (day_of_week == 6) {
                return week_of_year;
            } else if (day_of_week == 5 && is_leap_year(year)) {
                return week_of_year;
            } else {
                return 1;
            }
        } else if (week_of_year == 0) { // week is in previous year, try again under that year
            first_day_of_year = julian_day(year - 1, 1, 1);
            day_of_week = (first_day_of_year + 3) % 7;
            return (given_day_of_year - first_day_of_year + day_of_week + 4) / 7;
        } else { // any old week of the year
            return week_of_year;
        }
    }
    
}