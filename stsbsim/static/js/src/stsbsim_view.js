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

function stsbsimXBlockInitView(runtime, element) {
    $('.count', element).bind('click', function(){
        var answ = $('.stsbsim_embed_swf', element)[0].js_getAnswer();
        alert('click '+ answ);
    });

    var embed = $('.stsbsim_embed_swf', element)[0];
    embed.getCheck = function(answer){
        $.ajax({
            type: "POST",
            url: runtime.handlerUrl(element, 'get_check'),
            data: JSON.stringify({"answer": answer}),
            success: embed.onGetCheck
        });
    }    
    embed.onGetCheck = function(result){
        try{
            $('.stsbsim_score', embed.parent)[0].innerHTML = result.score;
            embed.js_onGetCheck(result);
        }catch(err){
            
        }        
    }
}
$(document).ready(function() {
//    alert('doc ready');
});