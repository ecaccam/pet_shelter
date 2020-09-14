$(document).ready(function(){
    $("body")
        .on("submit", "#manage_pet_form", submitManagePet )
});

function submitManagePet(e) {
    e.preventDefault();
    var form = $(this);
    let is_processing = parseInt(form.attr("data-is-processing"));

    form.find(".form-control").each(function(){
        var input = $(this);
        if(input.val() === ""){ 
            input.addClass("border_red");
        }
        else{
            input.removeClass("border_red");
        }
    });

    /* Success - No Errors */ 
    if(form.find(".border_red").length === 0 && is_processing === 0){
        form.attr("data-is-processing", 1);

        $.post(form.attr("action"), form.serialize(), function(response) {
            if(response.status === true){
                window.location.replace("/");
            }else{
                // do something
            }
            form.attr("data-is-processing", 0);
        });
    }
}