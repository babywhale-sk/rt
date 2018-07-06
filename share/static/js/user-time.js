function LoadUserTimeWorked () {
    jQuery('#user-time-worked-content').empty();
    var start_date = jQuery('#user-time-startdate').val();
    var end_date = jQuery('#user-time-enddate').val();
    var user_req = jQuery('#user-time-user-selected').val();

    var data = {'user_req': user_req, 'start_date' : start_date, 'end_date' : end_date};

    jQuery.ajax({
        type: 'POST',
        url: "/Helpers/UserTime",
        dataType: "json",
        data: data,
        success: function( ARGS ) {
            var data = ARGS['Data'];
            var keysArr = Object.keys(data).sort();
            var Content = jQuery('#user-time-worked-content');
            var Results = jQuery('#user-time-worked-results');
            var Results_container = jQuery('#user-time-worked-results-container');

            Results.html("");
            for (var i=0; i < ARGS['Results'].length; i++) {
                Results.append('<li>' + ARGS['Results'][i] + '</li>');
            }

            if ( ARGS['Results'].length > 0 ) {
                Results_container.show();
            }

            keysArr.forEach(function(key){
                var days = data[key];
                var daysTime = 0;

                Content.append('<h3>' + key + '</h3>');
                var table = ('<div id="user-time-worked-content">\
                        <table id="user-timeworked-table" class="ticket-list collection-as-table">\
                            <tr class="collection-as-table">\
                                <th class="collection-as-table">id</th>\
                                <th class="collection-as-table">Subject</th>\
                                <th class="collection-as-table">Queue</th>\
                                <th class="collection-as-table">Status</th>\
                                <th class="collection-as-table">Owner</th>\
                                <th class="collection-as-table">Time Worked</th>\
                            </tr>\
                ');

                // Iterate over each day we have tickets for
                for (var i=0; i < days.length; i++) {
                    var args = days[i];
                    var evenOdd = (i % 2 == 0 ) ? 'even' : 'odd';
                    var ticketLink = '<a href=/Ticket/Display.html?id=' + args['Id'] + '>';

                    table = table.concat('<tr class="' + evenOdd + 'line"><td>' + ticketLink + args['Id'] + '</a></td><td>'
                        + ticketLink + args['Subject'] + '</a></td><td>' + args['Queue']
                        + '</td><td>' + args['Status'] + '</td><td>' + args['Owner'] + '</td><td>' + args['Time'] + '</td></tr>');

                        daysTime = daysTime + parseInt(args['TimeMin']);
                }
                daysTime = daysTime > 60 ? (daysTime / 60).toFixed(2) + ' hours (' + parseInt(daysTime, 10) + ' minutes)' : parseInt(daysTime, 10) + ' minutes';
                Content.append(table);
                Content.append('<span class="label">Time for ' + key + ':</span><span class="value">' + daysTime + '</span>');
            });
            var TotalTime =  ARGS['TotalTime'] / 60 > 1 ? (ARGS['TotalTime'] / 60).toFixed(2) + ' hours (' + ARGS['TotalTime'] + ' minutes)' : ARGS['TotalTime'] + ' minutes';
            Content.append('<hr><span class="label">Total Time Worked: </span><span class="value">' + TotalTime + '</span>');
        },
    });
}
