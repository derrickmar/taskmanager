var existingTagsArray = [];

$(document).ready(function() {
    // $(".tag-search-desc").each(function() {
    //     console.log("IN THE THING");
    //     existingTagsArray.push($(this).text().trim());
    // });

filterSearch($('#search-tags'));
filterSearch2($('.labels_div_inp'));
filterClick($('.tag-search-desc'));
    // setting the checkbox based on user last action
    var no_tags_shown = $('.no-tags-checkbox').attr('data-sett');
    $('.no-tags-checkbox').prop('checked', true);

    tagCheckboxClicked($('.no-tags-checkbox'));
    extendSpecialDivTasks($('.specialdaydiv').height(), $('.tagdiv').height());

    // Contains selector that is case insensitve
    jQuery.expr[":"].Contains = jQuery.expr.createPseudo(function(arg) {
        return function(elem) {
            return jQuery(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
        };
    });

    tagSearchOnCreate($('.tag-search-desc2'));

});

function removeExtension(dom) {
    dom.children('.days').children().each(function() {
        $(this).css('width', '');
    });
}

// specialdiv vs tagdivheight

function extendSpecialDivTasks(sdheight, tdheight) {
    console.log("in extendSpecialDivTasks");
    console.log($('.specialdaydiv').height());
    if (sdheight > tdheight) {
        $('.specialdaydiv').children('.days').children().each(function() {
            var position = $(this).position();
            if (position.top > tdheight + 10) {
                // console.log($('.tagdiv').height());
                // console.log("position:" + position.top);
                $(this).css('width', '210%');
            } else {
                $(this).css('width', '');
            }
        });
    } else {
        console.log("specialdaydiv not larger");
        $('.specialdaydiv').children('.days').children().each(function() {
            $(this).css('width', '');
        });
    }
}


function tagSearchOnCreate(dom) {
    dom.click(function() {
        // console.log($(this).closest('.labels_div_inp'));
        $(this).closest('.tagform-create').siblings('.labels_div_inp').val($(this).text().trim());
        $(this).closest('.tagform-create').siblings('.tag-create-submit').click();
        $('.tag-search-desc2').addClass("hidden");
    });
}

// what does this do?
function filterSearch(dom) {
    dom.keyup(function() {
        var value = $(this).val().toLowerCase();
        console.log(value);
        $('#tag-search-holder > div:not(:Contains(' + value + '))').hide();
        $('#tag-search-holder > div:Contains(' + value + ')').show();
    });
}

// autocomplete an new tag form
function filterSearch2(dom) {
    dom.keyup(function() {
        console.log("in filterSearch2");
        var value = $(this).val().toLowerCase();
        console.log(value);
        // this one is working
        if (value != "") {
            $('.tag-search-holder2 > div:not(:Contains(' + value + '))').addClass("hidden");
            $('.tag-search-holder2 > div:Contains(' + value + ')').removeClass("hidden");
        } else {
            console.log(value);
            $('.tag-search-desc2').addClass("hidden");
        }
        // $(".tag-search-holder-create > div:not(:Contains(aval))").addClass("hidden");
        // $(".tag-search-holder-create > div:Contains(aval)").removeClass("hidden");
        // $(".tag-search-desc").each(function() { 
        //     $(this).removeClass("hidden");
        // })
});
}

// if the checkbox for no tags is clicked then toggle the class

function tagCheckboxClicked(dom) {
    dom.click(function() {
        console.log("tags checkbox clicked");
        $(this).toggleClass('clicked');
        if ($(this).hasClass('clicked')) {
            // tagsdiv with class hidden because hidden means it has no tags
            if ($("#show_completed:contains('Hide')").length > 0) {
                $('.tagsdiv.hidden').closest('.tasks').fadeIn();
            } else {
                $('.tagsdiv.hidden').closest('.tasks').each(function() {
                    if (!$(this).find('.circle-border').hasClass('complete')) {
                        $(this).fadeIn();
                    }
                });
            }
        } else {
            $('.tagsdiv.hidden').closest('.tasks').fadeOut();
        }
        $('.tasks').promise().done(function() {
            extendSpecialDivTasks($('.specialdaydiv').height(), $('.tagdiv').height());
        });

    });
}

function filterClick(dom) {
    dom.click(function() {
        console.log("in filterClick")
        var exceptThis = dom.not($(this));
        exceptThis.removeClass('tag-clicked');
        $(this).toggleClass('tag-clicked');
        var tagText = $(this).text();
        console.log("YAYYA");
        console.log(tagText);
        if ($(this).hasClass('tag-clicked')) {
            $('.tasks').each(function() {
                var currTask = $(this);
                // finding all the tags for a task
                var tags = currTask.find('.each_tag');
                // console.log(tags);
                $(tags).each(function() {
                    // if the tag for the task equals the filter tag
                    if (tagText.trim() == $(this).text().trim()) {
                        // if button has "Show"
                        if ($('#show_completed').text().indexOf("Show") == 0) {
                            console.log("in Show");
                            console.log(currTask.find('.circle-border'));
                            if (currTask.find('.circle-border').hasClass('complete')) {
                                console.log("ever in here");
                            } else {
                                currTask.fadeIn();
                            }
                        } else {
                            currTask.fadeIn();
                            return false;
                        }
                    } else {
                        currTask.fadeOut();
                    }
                });
            });
} else {
    console.log("I'M IN HERE");
    $('.tasks').each(function() {
        var taskid = $(this).attr('data-id');
        var tagsdiv = '.tagsdiv' + taskid;
        if ($('#show_completed').text().indexOf("Show") == 0 &&
            $(this).find('.circle-border').hasClass('complete')) {
            console.log("I'M IN HERE 2");
        return true;
                    // identification of tagsdiv used here
                } else if (!$('.no-tags-checkbox').hasClass('clicked') &&
                    $(tagsdiv).hasClass('hidden')) {
                    return true;
                } else {
                    console.log("I'M IN HERE 3");
                    $(this).fadeIn();
                }
            });
}

$('.tasks').promise().done(function() {
    extendSpecialDivTasks($('.specialdaydiv').height(), $('.tagdiv').height());
});

});
}