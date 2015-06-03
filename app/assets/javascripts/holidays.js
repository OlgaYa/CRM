 $(document).ready(function() {
  var
    data_for_events = JSON.parse('<%= raw @hash_holidays[:holidays].to_json %>');
  $('#calendar_holiday').fullCalendar({
    firstDay: 1,
    events: data_for_events,
    eventClick: function (calEvent, jsEvent, view) {
      var myEvent = {
        title:"Holiday",
        allDay: true,
        start: calEvent._start.format()
      };
      $( "#list-month" ).load( "holidays/update_list_events",
        {
          date: myEvent.start,
          title: myEvent.title,
          status: "destroy"
        }
      );
      $('#calendar_holiday').fullCalendar('removeEvents', calEvent._id);
    },
    dayClick: function(date, allDay, jsEvent, view) {
      var myEvent = {
        title:"Holiday",
        allDay: true,
        start: date.format()
      };
      $('#calendar_holiday').fullCalendar( 'renderEvent', myEvent );
      $( "#list-month" ).load( "holidays/update_list_events",
        {
          date: myEvent.start,
          title: myEvent.title,
          status: "add"
        }
      );
    },
  })
});