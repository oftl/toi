var TOI = (function() {

    var data;
    var data_version = -1;
    var oth = 30;
    var data_uri = '/data/load';
    var request_running = false;

    var load = function() {

        // DateTimePicker calls load() three times.
        if (request_running) {
            return;
        }
        request_running = true;

        $('#refresh_data').button('option', 'label', 'Loading ...');

        var oth = $('#oth').val();
        var from = $('#from_date').datepicker('getDate');
        var to = $('#to_date').datepicker('getDate');
        var obfuscate_names = $('input[name=obfuscate_names]:checked').val();
        var display_type = $('#display_type').val();

        var tlists = '';
        $('input[name=tlist]:checked').each ( function (tlist) {
            // tlists.push($(this).val());
            tlists = tlists +  $(this).val() + ',';
        });

        var params = {
            oth: oth,
            from: $.datepicker.formatDate('@', from) / 1000 || 1,
            to: $.datepicker.formatDate('@', to) / 1000 || 2147483647,
            obfuscate_names: obfuscate_names || 1,
            tlists: tlists
        };

        $.getJSON (data_uri, params, function (response) {
            data_version = response.version;
            data = JSON.parse(response.data);
        })
        .done ( function() {
            //console.log ('success 2');
        })
        .fail ( function() {
            // console.log ('failed');
        })
        .always ( function() {
            request_running = false;
            $('#refresh_data').button('option', 'label', 'Refetch data');
            $('#debug').html ('<pre> Params of last refresh: oth: ' + oth + '; from: ' + from + '; to:  ' + to + '; obfuscate_names: ' + obfuscate_names + '</pre>');
            draw(display_type);
        })
    };

    var draw_list = function() {

        var next_position = function () {
        };

        $('#data').empty();

        var start_left = 20;
        var step_left = 150;
        var step_top = 50;
        var pos_top = 20;
        var pos_left = start_left - step_left; // initialiase
        var width = step_left * 5;

        for (var i = 0; i < data.length; i++) {
            var tag = data[i].text;
            var global_count = data[i].count;
            // console.log('tag: ' + tag);

            if (pos_left > width) {
                pos_left = start_left;
                pos_top += step_top
            }
            else {
                pos_left += step_left;
            }

            $('#data').append (
                $('<div>', {
                    id: 'hashtag_' + tag,
                    'class': 'fixed_bubble',
                    css: {
                        'top': pos_top + 'px',
                        'left': pos_left + 'px'
                    }
                })

               .append (
                   $('<a>', {
                       text: '#' + tag + ' (g: ' + global_count + ')',
                       target: '_blank',
                       href: 'https://twitter.com/search?q=%23' + tag + '&src=hash'
                   })
               )

               .append (
                   $('<div>', {
                       id: 'users_by_tag_' + tag,
                       class: 'info_bubble yellow_bubble'
                   })
               )
            );

            for (var j = 0; j < data[i].users.length; j++) {

                var name = data[i].users[j].name;
                var name_obfuscated = data[i].users[j].name_obfuscated;
                var twitter_id = data[i].users[j].twitter_id;
                var user_element;
                var count = data[i].users[j].count

                if (name_obfuscated) {
                    user_element = $('<div>', { text: '@' + name + ' (' + count + ')' });
                }
                else {
                    user_element = $('<div>')
                        .append (
                            $('<a>', {
                                text: '@' + name,
                                target: '_blank',
                                href: 'https://twitter.com/' + twitter_id
                            })
                        )
                        .append (' (' + count + ')');
               }

               $('#users_by_tag_' + tag)
                   .append (user_element)
           }
        }

        // events for hashtags
        $('.fixed_bubble').on ({
            mouseover: function (event) {
                event.preventDefault();
                var target = this.id.replace(/.*_/, '');
                $('#users_by_tag_' + target).show();
            },
            mouseout: function (event) {
                event.preventDefault();
                var target = this.id.replace(/.*_/, '');
                $('#users_by_tag_' + target).hide();
            }
        })
    };

    var draw_pie_chart = function() {

        $('#data')
            .empty()
            .append(
                $('<div>', {
                    id: 'pie_chart',
                    css: {
                        top: '0px',
                        left: '0px',
                        position: 'absolute'
                    }
                })
        );

        var rows = [];
        var data_table = new google.visualization.DataTable();
        data_table.addColumn('string', 'Hashtag');
        data_table.addColumn('number', 'Count');

        for (var i = 0; i < data.length; i++) {
            var tag = data[i].text;
            var global_count = data[i].count;
            data_table.addRow ([tag, global_count]);
        }

        var options = {
            width: 800,
            height: 800,
            backgroundColor: '#dddddd',
            // chartArea: {left:20,top:0,width:"50%",height:"75%"},
            legend: 'top'
        };

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.PieChart(document.getElementById('pie_chart'));
        chart.draw(data_table, options);
    };

    var draw_bar_chart = function() {

        $('#data')
            .empty()
            .append(
                $('<div>', {
                    id: 'chart',
                    css: {
                        top: '0px',
                        left: '0px',
                        position: 'absolute'
                    }
                })
        );

        var rows = [];
        var data_table = new google.visualization.DataTable();
        data_table.addColumn('string', 'Hashtag');
        data_table.addColumn('number', 'Count');

        for (var i = 0; i < data.length; i++) {
            var tag = data[i].text;
            var global_count = data[i].count;
            data_table.addRow ([tag, global_count]);
        }

        var options = {
            width: 1024,
            height: 600,
            backgroundColor: '#dddddd',
            // chartArea: {left:20,top:0,width:"50%",height:"75%"},
            legend: 'none'
        };

        var chart = new google.visualization.BarChart(document.getElementById('chart'));
        chart.draw(data_table, options);
    };

    var draw = function(display_type) {
        if (display_type === 'pie_chart') {
            draw_pie_chart();
        }
        else if (display_type === 'list') {
            draw_list();
        }
        else if (display_type === 'bar_chart') {
            draw_bar_chart();
        }
    }

    var display = function() {
        load();
    };

    var setup_page = function() {

        $('#from_date').datetimepicker({
            // DatePicker
            altFormat: 'yy-mm-dd',
            dateFormat: 'yy-mm-dd',
            defaultDate: 0,

            // TimePicker
            altTimeFormat: 'HH:mm',
            timeFormat: 'HH:mm',
            defaultValue: '00:00',

            addSliderAccess: true,
            sliderAccessArgs: { touchonly: false },
        });

        $('#to_date').datetimepicker({
            // DatePicker
            altFormat: 'yy-mm-dd',
            dateFormat: 'yy-mm-dd',
            defaultDate: 0,

            // TimePicker
            altTimeFormat: 'HH:mm',
            timeFormat: 'HH:mm',
            defaultValue: '23:59',

            addSliderAccess: true,
            sliderAccessArgs: { touchonly: false },
        });

        $('#reset_options')
            .button ({ label: "Reset options" })
            .on ({
                click: function (event) {
                    event.preventDefault();
                    alert('Not yet implemented');
                }
            })
        ;

        $('#refresh_data')
            .button ({ label: "Refresh data" })
            .on ({
                click: function (event) {
                    event.preventDefault();
                    load();
                }
            })
        ;

        $('#obfuscate_names').buttonset();
        $('#tlist').buttonset();

        $('#display_type')
            .on ({
                change: function (event) {
                    draw($(this).val());
                }
            })
        ;

        $('#last_24_hours')
            .button ({ label: "Last 24 hours" })
            .on ({
                click: function (event) {
                    event.preventDefault();
                    var end = Date.now();
                    var start = end - 86400000;
                    $('#from_date').datepicker('setDate', new Date(start));
                    $('#to_date').datepicker('setDate', new Date(end));
                }
            })
        ;

        $('#last_48_hours')
            .button ({ label: "Last 48 hours" })
            .on ({
                click: function (event) {
                    event.preventDefault();
                    var end = Date.now();
                    var start = end - (2 * 86400000);
                    $('#from_date').datepicker('setDate', new Date(start));
                    $('#to_date').datepicker('setDate', new Date(end));
                }
            })
        ;

        $('#last_72_hours')
            .button ({ label: "Last 72 hours" })
            .on ({
                click: function (event) {
                    event.preventDefault();
                    var end = Date.now();
                    var start = end - (3 * 86400000);
                    $('#from_date').datepicker('setDate', new Date(start));
                    $('#to_date').datepicker('setDate', new Date(end));
                }
            })
        ;

        $('.query_params')
            .on ({
                change: function (event) {
                    load();
                }
            })
        ;

        $('#settings-button')
            .button ({ label: "Settings" })
            .on ('click', function () { $('#settings-controls').toggle() })
        ;

        $('#profiles-button')
            .button ({ label: "Profiles" })
            .on ('click', function () { $('#profiles-controls').toggle() })
        ;

        $('#info-button')
            .button ({ label: "Info" })
            .on ('click', function () { $('#info-controls').toggle() })
        ;

        $('#top_n-button')
            .button ({ label: "Top 10" })
            .on ('click', function () { $('#top_n-controls').toggle() })
        ;

        $('.controls-container').draggable({ opacity: 0.75 });

        // hide stuff initially
        $('#settings-controls').hide();
        $('#profiles-controls').hide();
        // $('#top_n-controls').hide();
        $('#info-controls').hide();

        // toggle
        $('.toggle_control').on ({
            'click': function (event) {
                // only toggle when the outer node is clicked
                // but not when in an inner (a link) was
                if ($(event.target).attr ('class') !== 'twitter_link') {
                    $(this).children('.toggle_area').toggle();
                }
            }
        });

        // hide detailed data
        $('.meta_container, .total_container, .per_list_container').trigger ('click');
    };

    return {
        display:    display,
        setup_page: setup_page
    }
}());

$(document).ready (function() {
    TOI.setup_page();
    TOI.display();
});
