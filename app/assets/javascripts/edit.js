$(document).ready(function() {
	dailyEmailCheckboxToggle($('#recieve_email'));
	if ($('.email-holder').attr('data-dailyemail') == "true") {
		$('#recieve_email').prop('checked', true);
	} else { 
		console.log("in false e-mail checkbox");
		$('#recieve_email').prop('checked', false);
	}
});


function dailyEmailCheckboxToggle(dom) {
	console.log($('#recieve_email').closest('.email-holder').attr('data-dailyemail'));
    dom.click(function() {
        var url = "/users/" + $(this).closest('.email-holder').attr('data-userid') + "/update_settings";
        console.log(url);
        if ($(this).prop('checked') == true) {
        	console.log("should be checked");
            ajaxCall(url, {
                daily_email: "true"
            }, 'PATCH');
        } else {
        	console.log("should be unchecked");
            ajaxCall(url, {
                daily_email: "false"
            }, 'PATCH');
        }
    });
}