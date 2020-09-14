$(document).ready(function() {
    $("body")
      .on("click", ".show_pet_details_btn", showPetDetails)

      .on("click", "#adopt_pet_btn", removePet);
});

function removePet(){
  let form = $("#remove_pet_form");
  let is_processing = parseInt(form.attr("data-is-processing"));

  if (is_processing === 0) {
      form.attr("data-is-processing", 1);

      $.post(form.attr("action"), form.serialize(), function(response) {
          if (response.status === true) {
              $("#pet_details_modal").modal("hide");
              $("#pets_table tr[data-pet-id='"+ response.pet_id +"']").fadeOut();	
          }
          form.attr("data-is-processing", 0);
      });
  }	
}

function showPetDetails(){
  let form = $("#fetch_pet_form");
  let is_processing = parseInt(form.attr("data-is-processing"));
  let pet_id = parseInt($(this).closest("tr").attr("data-pet-id"));
  
  if (is_processing === 0) {
      form.find("input[name=pet_id]").val(pet_id);
      form.attr("data-is-processing", 1);

      $.post(form.attr("action"), form.serialize(), function(response) {
          if (response.status === true) {
              $("#pet_details_modal").modal("show");
              $("#pet_details_modal .modal-content").html(response.html);
          }
          form.attr("data-is-processing", 0);
      });
  }
}
