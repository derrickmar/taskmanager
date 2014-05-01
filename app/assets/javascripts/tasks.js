var url;
var counter = 0;


$(document).ready(function() {


     0.5625


    $('.tasks').hover(function() {
        $('.tasks').removeAttr('title');
    });

    // remove tooltips after shown once
    $('.tasks').on('hidden.bs.tooltip', function() {
        $('.tasks').tooltip('disable');
    });

    $('.imageclock').tooltip({
        'title': "Set a time to get a reminder"
    });

    // calling this on initial on create (text area) for tasks to resize dynamically
    resizeCreateTaskTextAreaInit($('.initial-input'));

    xbuttontagdelete($('.x-button-tag'))

    completeClicked($(".circle-border"));

    addLabelsDivToggle($(".add_labels_plus"));

    // noteClicked($('.noteInitial'));

    moreDOMFunctionality($('.more'));
    editTask($('.tasks'));

    noDueAt($('.no-dueat'), true);
    noDueAt($('.dueat-launch'), false);

    // .timepickerBefore is the timepickers before task is created
    $('.timepickerBefore').timepicker({
        minuteStep: 10,
        defaultTime: false,
    });

    // add times to timepicker according to due_at value in task
    addTimeOnTimepickerAfter($('.timepickerAfter'));

    //$('.timepicker').click(function() {
    //console.log(this);

    // THIS is to change the hidden value of the form to match the time chosen on form before
    // task is created
    $('.timepickerBefore').timepicker().on('changeTime.timepicker', function(e) {
        console.log(this);
        var dayid = $(this).attr('data-dayid');
        console.log(dayid);
        $('#due_at_hd' + dayid).val(e.time.value);
    });

    // update due_at attribute on task that is already created (through ajax)
    updateDueAt($('.timepickerAfter'));


    toggleOpacity($(".exclamation-exist"));
    toggleOpacity($(".mailOpacity"));
    toggleOpacity($(".exclamation-Before"));

    // remove sms notice when click x-button
    $('.x-button').click(function() {
        $('.notice').hide();
    })

    draggableFunctionality();
    overdueClick();

});

function overdueClick() {
    $('.overdue-x').click(function() {
        console.log('in overdueClick');
        // console.log($(this).siblings('.overdue-submit'));
        $(this).siblings('.overdue-submit').trigger( "click" );
    });
}

function resetZIndexforTasks(dom) {
    console.log("resetZIndexforTasks called");
    dom.each(function() {
        $(this).css("zIndex", "");
    });
}

function draggableFunctionality() {
    $("#Monday, #Tuesday, #Wednesday, #Thursday, #Friday, #Saturday, #Sunday").sortable({
        // console.log("DRAGGABLE"),
        connectWith: ".days",
        cursor: "move",
        distance: 4,
        zIndex: 100,
        // appendTo: 'body',
        // cursorAt: {
        //     top: 50,
        //     left: 150
        // },
        receive: function(event, ui) {
            // this refers to the div that the task is being dragged to
            console.log("BEFORE THIS");
            // console.log(this);
            // console.log($(this).children());
            resetZIndexforTasks($(this).children());

            // this is for extending the special div
            if (!$(this).parent().hasClass('specialdaydiv')) {
                removeExtension($(this).parent());
            } else {
                extendSpecialDivTasks($('.specialdaydiv').height(), $('.tagdiv').height());
            }

            var data = $(this).sortable('serialize');
            url = ui.item.attr('data-url');
            urlOrdering = ui.item.attr('data-ordering');
            console.log("in recieve function before update ordering: " + data);
            console.log("in recieve function urlOrdering: " + urlOrdering);

            updateOrdering(data, urlOrdering);

            var new_day_id = $(this).attr('data-dayid');
            //console.log(new_day_id);
            data += "&new_day_id[]=" + new_day_id;
            console.log("in recieve function: " + data);

            $.ajax({
                url: url,
                data: data,
                type: 'PATCH',
                datatype: "JSON",
            });
            //console.log("recieve data: " + data);
        },
        // stop call happens on the list where the task is picked up
        // this updates the ordering
        stop: function(event, ui) {
            var data = $(this).sortable('serialize');
            //console.log("stop data: " + data);
            urlOrdering = ui.item.attr('data-ordering');
            // console.log(urlOrdering);
            console.log("in stop function: " + data);
            console.log(this);
            resetZIndexforTasks($(this).children());

            // don't update order if there is no data
            if (data.replace(/\s/g, '').length || (data.length != 0)) {
             updateOrdering(data, urlOrdering);
         }

         if (!$(this).parent().hasClass('specialdaydiv')) {
            removeExtension($(this).parent());
        } else {
            extendSpecialDivTasks($('.specialdaydiv').height(), $('.tagdiv').height());
        }
    }
}).disableSelection();
}


function addLabelsDivToggle(dom) {
    dom.click(function() {
        console.log("in addLabelsDivToggle");
        // console.log($(this));
        // console.log($(this).siblings('.add_labels_div, .hidden'));
        //console.log($(this).siblings);
        $(this).siblings('.add_labels_div').toggleClass('hidden');
        hideOnMouseUpOutsideDom($(this).siblings('.add_labels_div'));
    });
}


function ajaxCall(the_url, the_data, the_type) {
    console.log("in ajax Call: " + the_url);
    $.ajax({
        url: the_url,
        data: the_data,
        type: the_type,
        datatype: "JSON",
    });
}

function hideOnMouseUpOutsideDom(dom) {
    $(document).mouseup(function(e) {
        if (!dom.is(e.target) && dom.has(e.target).length === 0) {
            console.log("hiding and unbinding mouseup");
            dom.fadeOut(250, function() {
                $(this).addClass('hidden');
                $(this).css("display", "");
            });
        }
    });
}

// complete_day_task PATCH  /days/:day_id/tasks/:id/complete(.:format)    tasks#complete

function completeClicked(dom) {
    dom.click(function() {
        if ($(this).hasClass("complete")) {
            console.log($(this));
            $(this).removeClass("complete");
            $(this).siblings(".task_text").removeClass('line-through');
            var url = $(this).closest(".tasks").attr('data-url') + "/complete"
            console.log(url);
            //console.log($(this).closest(".tasks").attr('data-url'));
            ajaxCall(url, {
                "complete": false
            }, 'PATCH');
        } else {
            $(this).addClass("complete");
            $(this).siblings(".task_text").addClass('line-through')
            console.log($(this).closest(".tasks").attr('data-url'));
            var url = $(this).closest(".tasks").attr('data-url') + "/complete"
            console.log(url);
            ajaxCall(url, {
                "complete": true
            }, 'PATCH');
            var text = $('.toggle_completed').text();
            if (text.indexOf("Show") == 0) {
                console.log("hey");
                $(this).closest(".tasks").delay(500).slideUp(500);
            }
            //console.log(text);
        }
        $('.tasks').promise().done(function() {
            extendSpecialDivTasks($('.specialdaydiv').height(), $('.tagdiv').height());
        });
    });

dom.each(function() {
    console.log($(this));
    $(this).mouseenter(function() {
        $(this).addClass("complete_hover");
    });
    $(this).mouseleave(function() {
        $(this).removeClass("complete_hover");
    });
});
}

// DELETE /tags/:id(.:format)                           tags#destroy
// when clicked will allow you to delete the tag
// also if the seven day tasks have no more of this tag we delete it from the tagfilter div

function xbuttontagdelete(dom) {
    console.log("xbuttontagdelete was called");
    dom.click(function() {
        var name = $(this).siblings('.each_tag').text().trim();
        console.log(name);
        console.log('in x buttontagdelete');
        var tagid = $(this).attr('data-tagid');
        taskid = $(this).closest('.tasks').attr('data-id');
        var container = ".each_tag_container" + tagid + "_" + taskid;
        $(container).hide();
        console.log($(this).parent().nextUntil('.add_labels_div'));
        url = "/tags/" + tagid;
        console.log(taskid);
        console.log(url);
        ajaxCall(url, {
            "assoc_task": taskid
        }, 'DELETE');


        // this has to do something with tag-search-desc
        var hasMoreTag = false;
        $('.each_tag').each(function() {
            console.log(this);
            console.log($(this).parent().css('display'));
            // if there are more tags with the same name and not hidden it means we shouldn't
            // hide the tag-search-desc
            if ($(this).parent().css('display') != 'none' && $(this).text().trim() == name) {
                hasMoreTag = true;
                return false;
            }
        });

        // I think this is hiding tag-search-desc if ther is no more tags on the tasks
        // that are not hidden
        if (!hasMoreTag) {
            $('.tag-search-desc').each(function() {
                if ($(this).text().trim() == name) {
                    $(this).hide();
                    return false;
                }
            });
        }

        // hide the tagsdiv
        var tagsdiv = ".tagsdiv" + taskid;
        var hasMoreTagOnTask = false;
        // seeing if children are all display: none. If so then we hide the specifc tagsdiv
        $(tagsdiv).children().each(function() {
            if ($(this).css('display') != 'none') {
                hasMoreTagOnTask = true;
                return false;
            }
        });

        // if you have no more tags on task
        if (!hasMoreTagOnTask) {
            $(tagsdiv).addClass('hidden');
        }
    });
}

function onClickToggleHidden(clickedDom, toggledDom) {
    clickedDom.click(function() {
        console.log('in here');
        toggledDom.toggleClass('hidden');
    });
}

// function noteClicked(dom) {
//     dom.click(function() {
//         $(this).siblings('.popover').children('.popover-content').click(divClicked);
//         $(this).siblings('.popover').children('.arrow').remove();
//     });
// }

// /weeks/1/tasks/updateordering

function updateOrdering(data, url) {
    console.log("in updateOrdering: " + data);
    console.log(data.length);
    console.log("THERE MIGHT BE AN ERROR AFTER THIS");
    $.ajax({
        url: url,
        data: data,
        type: 'POST',
        datatype: "JSON",
    });
}

function toggleOpacity(dom) {
    dom.click(function() {
        console.log("in here");
        $(this).toggleClass('opacity_full');
    });
}

var textarea;

function spanToTextArea(text) {
    var textarea = $("<textarea onkeyup='textAreaAdjust(this)' style='overflow:hidden'>" + text + "</textarea>");
    return textarea;
}

// resize textArea based on text initially

function resizeCreateTaskTextAreaInit(dom) {
    console.log(dom);
    dom.each(function() {
        console.log("in resizeTextAreaInit");
        // console.log(this.cols);
        // console.log(cols);
        var cols = this.cols;
        resizeIt($(this), cols);
        $(this).keyup(function(e) {
            // if (e.keyCode == 13 && e.shiftKey) {
            //     $(this).siblings('.new_task_create').click();
            // }
            textAreaAdjust(this);
        });
        $(this).keydown(function(e) {
            if (e.keyCode == 13 && e.shiftKey) {
                console.log("shift + enter pressed");
            } else if (e.keyCode == 13) {
                $(this).siblings('.new_task_create').click();
            }
        });
    });
}


// function resizeTextAreaInit(dom) {
//     console.log(dom);
//     dom.each(function() {
//         console.log("in resizeTextAreaInit");
//         // console.log(this.cols);
//         // console.log(cols);
//         var cols = this.cols;
//         resizeIt($(this), cols);
//         $(this).keyup(function(e) {
//             if (e.keyCode == 13 && e.shiftKey) {
//                 $(this).siblings('.new_task_create').click();
//             }
//             textAreaAdjust(this);
//         });
//     });
// }

// resizes text area dynamically while typing

function textAreaAdjust(o) {
    console.log("in textAreaAdjust");
    o.style.height = "1px";
    o.style.height = (o.scrollHeight + 2) + "px";
    console.log(o.style.height);
}

// resize text area to expand to content

function resizeIt(textarea, cols) {
    console.log("in resizeit");
    var str = textarea.val();
    console.log("str: " + str);
    console.log(cols);
    var linecount = 0;

    str.split("\n").forEach(function(l) {
        // console.log(l);
        console.log("length: " + l.length);
        // console.log(cols);
        if (length != 0) {
            linecount += Math.ceil(l.length / (cols * 2.2));
            console.log(linecount);
        } else {
            linecount = 1;
        }
    });
    textarea.get(0).rows = linecount;
    return textarea;
};

var editTaskClicked = false;

// editTask and back

function propagationStop(dom) {
    dom.dblclick(function(e) {
        e.stopPropagation();
    });
}

function editTask(dom) {
    // disable double click to edit task on holder (timepicker, ect...)
    propagationStop($('.holder'));
    propagationStop($('.add_labels_div'));
    propagationStop($('.add_labels_plus'));

    // var container;
    dom.dblclick(function() {
        editTaskClicked = true;
        var task_text = $(this).find('.task_text');
        spanInitial = $(task_text);
        console.log("DOUBLE CLICKED");
        console.log(spanInitial);

        // not neccessary $(this).html().trim().replace(/<br\s*[\/]?>/gi, "\n")
        replacement = spanToTextArea($(task_text).html().trim());
        console.log(replacement.get(0).cols);
        replacement = resizeIt(replacement, replacement.get(0).cols);
        var v = replacement.val();

        // change it to text area
        $(task_text).replaceWith(replacement); // returns what was removed
        // THIS HAS TO BE AFTER replacewith because the it is actually loaded
        v = replacement.val();
        $(replacement).focus().val("").val(v);
        //if (editTaskClicked) {
            $(document).mouseup(function(e) {
                if (editTaskClicked) {
                    console.log("here in mouseup!")
                    console.log(e.target);
                    if (!replacement.is(e.target) && replacement.has(e.target).length === 0) {
                    // change it back to a span
                    // not neccessary: replacement.val().replace(/\n/g, '<br/>')
                    replacement.replaceWith(spanInitial.html(replacement.val()));
                    editTaskClicked = false;
                    editTask(spanInitial);
                    $(document).unbind('mouseup');
                    console.log(spanInitial.closest('.tasks'));
                    url = spanInitial.closest('.tasks').attr('data-url') + '/edit_text'
                    $.ajax({
                        url: url,
                        data: {
                            "new_description": replacement.val()
                        },
                        type: 'PATCH',
                        datatype: "JSON",
                    });
                }
            }
        });

replacement.keydown(function(e) {
    if (e.keyCode == 13 && e.shiftKey) {
        console.log("in replacement shift + enter pressed")
    } else if (e.keyCode == 13) {
        if (editTaskClicked) {
            console.log("SHIFT ENTER HAPPENED");
                    //console.log(e.target);
                    replacement.replaceWith(spanInitial.html(replacement.val()));
                    editTaskClicked = false;
                    editTask(spanInitial);
                    $(document).unbind('mouseup');
                    console.log(spanInitial.closest('.tasks'));
                    url = spanInitial.closest('.tasks').attr('data-url') + '/edit_text'
                    $.ajax({
                        url: url,
                        data: {
                            "new_description": replacement.val()
                        },
                        type: 'PATCH',
                        datatype: "JSON",
                    });
                }
            }
        });
});
}

// This sets up the timepicker with the default time

function addTimeOnTimepickerAfter(dom) {
    console.log("in addTimeOnTimepickerAfter")
    dom.each(function() {
        var time = $(this).attr('data-due-at');
        console.log(time);
        if (time == "NONE") {
            $(this).timepicker({
                minuteStep: 10,
                defaultTime: false
            });
        } else {
            $(this).timepicker({
                minuteStep: 10,
                defaultTime: time
            });
        }
    });
}

// updates dueat on timepickers on tasks that exist

function updateDueAt(dom) {
    dom.timepicker().on('changeTime.timepicker', function(e) {
        var url = $(this).attr('data-url');
        console.log("update " + url);
        console.log(this);
        //console.log('The time is ' + e.time.value);
        //console.log($(this).closest(".holder").next('.inline-reminder'));
        $(this).closest(".holder").next('.inline-reminder').html(e.time.value);
        if (!justClickedRemove) {
            ajaxCall(url, {
                "due_at": e.time.value
            }, 'PATCH');
        }
        justClickedRemove = false;
    });
}

// hides the more widget on mouseup

function moreDOMFunctionality(dom) {
    dom.click(function() {
        console.log("in moreDOMFunctionality");
        var specificMore = this;
        $(specificMore).next('.more-popup').toggleClass('hidden');
        var dataId = $(this).attr('data-id');
        $(document).mouseup(function(e) {
            var container = $(specificMore).next('.more-popup');
            if (!container.is(e.target) && container.has(e.target).length === 0 && $(e.target).is('#more' + dataId) == false) {
                container.fadeOut(250, function() {
                    $(this).addClass('hidden');
                    $(this).css("display", "");
                });
            }
        });
    })
}

// creates the remove button for timepicker

function removeButton() {
    return $("<button type='button' class='btn btn-default remove'>Remove</button>");
}

var justClickedRemove = false;

// when removed is clicked it will hide the timepicker widget.
// Also set due_at to nil and rerender the gcallink

function removeClick(dom, callAjax) {
    dom.click(function() {
        console.log("in remove click");
        var inp = $(this).parent().siblings('input');
        if (callAjax) {
            $(this).closest('.bootstrap-timepicker-widget').hide();
            //$(this).closest('.bootstrap-timepicker-widget').removeAttr("style");
            url = inp.attr('data-url');
            //console.log(url);
            ajaxCall(url, {
                "due_at": null
            }, 'PATCH');
            inp.addClass('hidden');
            console.log("in remove click end");
            justClickedRemove = true;
            console.log(justClickedRemove);
        } else {
            $(this).closest('.bootstrap-timepicker-widget').hide();
            inp.val("");
            clearOnNextClick(inp);
        }
    });
}

function clearOnNextClick(dom) {
    $(document).mousedown(function(e) {
        dom.val("");
        $(document).unbind('mousedown');
    });
}

// removes hidden input field (when the clock is clicked) if a created task has no due_at 

function noDueAt(dom, callAjax) {
    dom.click(function() {
        //console.log($(this).prev('input'));
        $(this).prev('input').removeClass('hidden');
        console.log("in noDueAt");
        console.log($(this).prev('.bootstrap-timepicker-widget'));
        var thisRemoveButton = removeButton();
        // removing display none  inline-style set by removeclick
        $(this).siblings('.bootstrap-timepicker-widget').removeAttr("style");
        if ($(this).siblings('.bootstrap-timepicker-widget').has('button').length == 0) {
            $(this).siblings('.bootstrap-timepicker-widget').append(thisRemoveButton);
        }
        removeClick(thisRemoveButton, callAjax);
        var number = $(this).attr('data-number');
        if (number == false) {
            // $('.notice').append(smsNeeded);
            console.log("in notice!");
            // this might take some time so might need to put it into html instead
            // $('.notice').delay(5000).load("sms_empty");
            $('.notice').fadeIn();
            console.log("HEYYYYYYY");
        }
    });
}

function fixTaskHoverIssues(dom) {
    dom.each(function() {
        $(this).hover(
            function() {$(this).css("z-index", 1); console.log("BOO");},
            function() {$(this).css("z-index", 1);}
            )
    });
}