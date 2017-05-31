$(document).on "page:change", ->

  $('#zip_code_id').change ->
    $('form[name="sort_by"]').submit()

  $('.restaurant-edit-profile').click ->
    $('#RestaurantFormModal').modal 'show'


