/* Javascript for stsbsimXBlock Edit. */
function stsbsimXBlockInitEdit(runtime, element) {

    $(element).find('.action-cancel').bind('click', function() {
        runtime.notify('cancel', {});
    });

    $(element).find('.action-save').bind('click', function() {
        var data = {
            'question': $('#stsbsim_question').val(),
            'data': $('#stsbsim_data').val(),
            'answer': $('#stsbsim_answer').val(),
            'bgd_url': $('#stsbsim_bgd_url').val(),
            'title': $('#stsbsim_title').val(),
            'min_percent': $('#stsbsim_min_percent').val(),
            'max_attempts': $('#stsbsim_max_attempts').val(),
        };
        
        try { //there is no function notify in workbench, thats why we use "try"
            runtime.notify('save', {state: 'start'});
        }catch(err){}
        var handlerUrl = runtime.handlerUrl(element, 'save_data');
        $.post(handlerUrl, JSON.stringify(data)).done(function(response) {
            if (response.result === 'success') {
                try {
                    runtime.notify('save', {state: 'end'});
                }catch(err){}
                // Reload the whole page :
                // window.location.reload(false);
            } else {
                try {
                    runtime.notify('error', {msg: response.message})
                }catch(err){}
            }
        });
    });
}