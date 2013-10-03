$ ->
    #-----------------------------------------------------------------------------------
    #	GOOGLE CALENDAR
    #-----------------------------------------------------------------------------------

    days_of_the_week = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    Timestamp =
        time: (date) ->
            date = date ? date : new Date()
            offset = date.getTimezoneOffset()
            return (
                @pad(date.getFullYear(), 4) +
                "-" + @pad(date.getMonth() + 1, 2) +
                "-" + @pad(date.getDate(), 2) +
                "T" + @pad(date.getHours(), 2) +
                ":" + @pad(date.getMinutes(), 2) +
                ":" + @pad(date.getSeconds(), 2) +
                "." + @pad(date.getMilliseconds(), 3) +
                (if (offset > 0) then "-" else "+") +
                @pad(Math.floor(Math.abs(offset) / 60), 2) +
                ":" + @pad(Math.abs(offset) % 60, 2)
            )
        pad: (amount, width ) ->
            padding = ""
            while (padding.length < width - 1 && amount < Math.pow(10, width - padding.length - 1))
                padding += "0"
            padding + amount.toString()
        convert: (stamp) ->
            [date, time] = stamp.split("T")
            [year, month, day] = date.split("-")
            [hour, minute, rest] = time.split(":")
            month = month[1] if month[0] is "0"
            day = day[1] if day[0] is "0"
            hour = hour[1] if hour[0] is "0"
            hourInt = parseInt(hour)
            suffix = if hourInt >= 12 then "PM" else "AM"
            hour = if hourInt > 12 then (hourInt - 12).toString() else hourInt.toString()
            dayInt = parseInt(day)
            monthInt = parseInt(month)
            yearInt = parseInt(year)            
            dateObj = new Date(yearInt,monthInt-1,dayInt)
            weekday = days_of_the_week[dateObj.getDay()]
            year: year
            month: month
            day: day
            hour: hour
            minute: minute
            weekday: weekday
            suffix: suffix
            

    api_key1 = "AIzaSyDmXKXVBjhMKo"
    api_key2 = "hK1v9MPaTmIZKKCF4wVb8"
    api_key = api_key1 + api_key2
    calendar = "5tapdg5f8g71aub46a66a5snd0@group.calendar.google.com"
    base_url = "https://www.googleapis.com/calendar/v3/calendars/"

    today = new Date
    nextWeek = new Date
    today.setHours 0, 0, 0, 0
    nextWeek.setDate(today.getDate()+7)
    $.get base_url + calendar + "/events", {
        orderBy: "startTime"
        key: api_key
        maxResults: 5
        timeMin: Timestamp.time(today)
        timeMax: Timestamp.time(nextWeek)
        singleEvents: true
    }, (data) ->
        items = data.items
        itemLength = items.length
        
        for item, i in items
            do (item, i) ->
                lastItemFlag = i % 2
                startTime = Timestamp.convert(item.start.dateTime)
                className = if lastItemFlag is 1 then "one-half last" else "one-half"
                $(".upcoming-events").append (
                    "<div class=\"" + className + " event\">" +
                    "<h4 class=\"center event-date\">" + startTime.month + "/" + startTime.day + "</h4>" +
                    "<ul class=\"event-time\">" +
                    "<li>" + startTime.weekday + "</li>" +
                    "<li>" + startTime.hour + ":" + startTime.minute + startTime.suffix + "</li>" +
                    "</ul>" +
                    "<ul class=\"event-text\">" +
                    "<li>" + item.summary[1..item.summary.length] + "</li>" +
                    "<li>" + item.location + "</li>" +
                    "</ul>" +
                    "<div class=\"clear\"></div>" +
                    "</div>"
                )
        $(".upcoming-events").append "<div class=\"clear\"></div>"
