var is_next_seven;

$(document).ready(function() {
    resizeVid($('.intro-video').width());

    if ($('#today_btn').text().indexOf("Today") != -1) {
        is_next_seven = true;
    } else {
        is_next_seven = false;
    }

    // change stuff when window is resize
    $(window).bind("resize", checkPosition);

    checkPosition();

    var view = $('.attributes').attr('data-view');
    var comp_hidden = $('.attributes').attr('data-comp');
    if (view == "today") {
        $('.not_today').hide();
        $('.tomorrow').hide();
        $('.third_day').hide();
        $('.today').show();
        $('.today').removeClass('col-lg-3 col-sm-4 col-md-4').addClass('col-md-8 col-sm-8');
        $('.tagdiv').removeClass('col-lg-3 col-md-4');
        $('#today_btn').text("Next Seven Days View");
        is_next_seven = false;
    }

    if (comp_hidden == "true") {
        $('.toggle_completed').text("Show Completed Tasks");
        $(".tasks").each(function() {
            //console.log("hey");
            // console.log($(this).find(".circle-border"));
            if ($(this).find(".circle-border").hasClass("complete")) {
                $(this).hide();
            }
        });
    }

    // hides and shows completed tasks by clicking button
    $('.toggle_completed').click(function() {
        var text = $(this).text();
        console.log(text.indexOf("Hide"));
        if (text.indexOf("Hide") != -1) {
            $(this).text("Show Completed Tasks");
            //console.log($(".tasks"));
            $(".tasks").each(function() {
                //console.log("hey");
                // console.log($(this).find(".circle-border"));
                if ($(this).find(".circle-border").hasClass("complete")) {
                    $(this).fadeOut(400);
                }
            });
            console.log("in completed_hidden true");
            url = "/users/" + $(this).attr('data-user') + "/update_settings"
            ajaxCall(url, {
                completed_hidden: "true"
            }, 'PATCH');
        } else {
            $(this).text("Hide Completed Tasks");
            $(".tasks").each(function() {
                //console.log("hey");
                // console.log($(this).find(".circle-border"));
                if ($(this).find(".circle-border").hasClass("complete")) {
                    $(this).fadeIn(400);
                }
            });
            console.log("in complete_hidden: false");
            url = "/users/" + $(this).attr('data-user') + "/update_settings"
            ajaxCall(url, {
                completed_hidden: "false"
            }, 'PATCH');
        }
        $('.tasks').promise().done(function() {
            extendSpecialDivTasks($('.specialdaydiv').height(), $('.tagdiv').height());
        });
    });

    $('#today_btn').click(function() {
        var text = $(this).text();
        var btn = $(this);
        console.log(text.indexOf("Today"));
        if (text.indexOf("Today") != -1) {
            console.log("clicked");
            window.setTimeout(function() {
                btn.text("Next Seven Days View");
            }, 300);
            todayClick($(this));
        } else {
            window.setTimeout(function() {
                btn.text("Today View");
            }, 300);
            sevenDaysClick($(this));
        }
    });

    toggleTagDivClick();

});

function resizeVid(w) {
    $('.intro-video').height(w * 0.5625);
    console.log("resizing vid");
}


// repositions the toggleTagDiv if it's not in xs breakpoint

function repositiontoggleTagDiv() {
    if ($('.holder-tagdiv-xs').has($('.tagdiv')).length > 0) {
        console.log('repositiontoggleTagDiv!');
        $('.holder-tagdiv').append($('.tagdiv'));
        $('.tagdiv').show();
    }
}

function toggleTagDivClick() {
    $('#toggleTagDiv').click(function() {
        console.log('toggleTagDiv Button clicked');
        if ($('.tagdiv').css('display') == 'none') {
            console.log('showing toggletagdiv form')
            $('#toggleTagDiv').text("Hide Tag Filter Form");
            if ($('.holder-tagdiv-xs').has($('.tagdiv')).length == 0) {
                console.log('appending toggletagdiv form')
                $('.holder-tagdiv-xs').append($('.tagdiv'));
            }
            $('.tagdiv').show();
        } else {
            console.log('hiding toggletagdiv form')
            $('#toggleTagDiv').text("Show Tag Filter Form");
            $('.tagdiv').hide();
        }
    });
}

function repositionToggleTagDivOnXS() {
    if ($('.holder-tagdiv-xs').has($('.tagdiv')).length == 0) {
        console.log('appending toggletagdiv form')
        $('.holder-tagdiv-xs').append($('.tagdiv'));
        $('.tagdiv').hide();
    }
}

function todayClick(dom) {
    console.log("hello");
    if (is_next_seven) {
        changeViewToToday();
        url = "/users/" + dom.attr('data-user') + "/update_settings"
        console.log(url);
        ajaxCall(url, {
            view: "today"
        }, 'PATCH');
    }
}

function sevenDaysClick(dom) {
    if (!is_next_seven) {
        console.log("next_seven")
        $('.today').fadeOut(200);
        $('.today').fadeIn(600);
        $('.tagdiv').fadeOut(200);
        $('.tagdiv').fadeIn(600);
        setTimeout(function() {
            $('.not_today').fadeIn(600);
            $('.third_day').fadeIn(600);
            $('.tomorrow').fadeIn(600);
            $('.today').removeClass('col-md-8 col-sm-8').addClass('col-lg-3 col-sm-4 col-md-4');
            $(".tagdiv").addClass('col-lg-3 col-md-4');
            // $('.holder1').removeClass('col-xs-8').addClass('col-xs-10');
        }, 200);
        is_next_seven = true;
        url = "/users/" + dom.attr('data-user') + "/update_settings";
        console.log(url);
        ajaxCall(url, {
            view: "seven"
        }, 'PATCH');
    }
}

function changeViewToToday() {
    console.log("not next_seven")
    $('.not_today').fadeOut(200);
    $('.tomorrow').fadeOut(200);
    $('.third_day').fadeOut(200);
    $('.today').fadeOut(200);
    $('.today').fadeIn(600);
    $('.tagdiv').fadeOut(200);
    $('.tagdiv').fadeIn(600);
    setTimeout(function() {
        $('.today').removeClass('col-lg-3 col-sm-4 col-md-4').addClass('col-sm-8 col-md-8');
        $('.tagdiv').removeClass('col-lg-3 col-md-4');
        //$('.holder1').removeClass('col-xs-8').addClass('col-xs-10');

        // $('.today').addClass('col-xs-12');
        // $('.today').addClass('col-xs-offset-1');
        // $(".tagdiv").removeClass('col-xs-2').addClass('col-xs-4');
    }, 200);

    // $('#task-header').fadeOut(200, function() {
    //     $(this).text("Today").fadeIn(600);
    // });
    is_next_seven = false;
}

function checkPosition() {
    if ($('#desktopTest3').is(':hidden')) {
        resizeVid($('.intro-video').width());
        repositionToggleTagDivOnXS();
        console.log("xs breakpoint");
        removeExtension($('.specialdaydiv'));
        $('.dayNameHeader').removeClass('smallerDayName');
        $('#toggleTagDiv').removeClass('hidden');
        console.log("removing more-padding-left from home-features");
        $('#home-features').removeClass('more-padding-left');
    } else if ($('#desktopTest').is(':hidden') || $('#desktopTest2').is(':hidden')) {
        resizeVid($('.intro-video').width());
        console.log("adding more-padding-left from home-features");
        $('#home-features').addClass('more-padding-left');
        console.log("md or sm breakpoint");
        $('#toggleTagDiv').addClass('hidden');
        $('.tagdiv').show();
        // console.log(is_next_seven);
        if (is_next_seven) {
            console.log("break3");
            // move tomorrow in special daydiv
            if ($('#desktopTest2').is(':hidden')) {
                $('.dayNameHeader').addClass('smallerDayName');
            } else {
                $('.dayNameHeader').removeClass('smallerDayName');
            }
            $('.tagdiv').show();
            $('.third_day').hide();
            $('.holder2').prepend($('.third_day'));
            $('.third_day').show();
            $('.third_day').removeClass('specialdaydiv');
            removeExtension($('.third_day'));
            $('.tomorrow').addClass('specialdaydiv');
            extendSpecialDivTasks($('.specialdaydiv').height(), $('.tagdiv').height());
        }
        repositiontoggleTagDiv();
    } else {
        resizeVid($('.intro-video').width());
        console.log("lg breakpoint");
        $('#home-features').addClass('more-padding-left');
        $('#toggleTagDiv').addClass('hidden');
        $('.tagdiv').show();
        if (!$('.third_day').hasClass('specialdaydiv')) {
            console.log("thirday does not have specialdaydiv");
            $('.third_day').hide();
            $('.holder1').append($('.third_day'));
            $('.third_day').show();
            $('.third_day').addClass('specialdaydiv');
            $('.tomorrow').removeClass('specialdaydiv');
            removeExtension($('.tomorrow'));
            extendSpecialDivTasks($('.specialdaydiv').height(), $('.tagdiv').height());
        }
        repositiontoggleTagDiv();
    }
}