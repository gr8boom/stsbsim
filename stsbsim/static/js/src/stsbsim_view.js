/* Javascript for StsbSimXBlock View. */
if (typeof as_check === 'undefined'){
    var as_check = function(id, answer){
        var embed = $('#'+id)[0];
        embed.getCheck(answer);
    }
    var as_getData = function(id){
        var embed = $('#'+id)[0];
        return {
            bgdURL: embed.getAttribute('bgdurl'),
            xml: embed.getAttribute('data'),
            currentAnswer: embed.getAttribute('currentAnswer'),
            finish: embed.getAttribute('finish'),
        }
    }

}

function stsbsimXBlockInitView(runtime, xblock) {

    var swf = $('.stsbsim_embed_swf', xblock)[0];

    swf.getCheck = function(answer){
        $.ajax({
            type: "POST",
            url: runtime.handlerUrl(xblock, 'get_check'),
            data: JSON.stringify({"answer": answer}),
            success: swf.onGetCheck
        });
    }    
    swf.onGetCheck = function(result){
        try{            
            $('.stsbsim_score', xblock)[0].innerHTML = result.score;
            $('.stsbsim_attempts', xblock)[0].innerHTML = result.attempts;
            swf.js_onGetCheck(result);
        }catch(err){
            
        }        
    }
}
/*$(document).ready(function() {
    alert('doc ready');
});*/