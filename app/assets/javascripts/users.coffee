$(document).on "page:change", ->
  $('.user-edit-profile').click ->
    $('#UserFormModal').modal 'show'
  $('form').validate()  
  

