# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on "page:change", ->

  $('#oder_by').change ->
    $('form[name="order_by"]').submit()


  $('.datetimepicker').datetimepicker
    timepicker: false
    format: 'Y-m-d'

  $('.timepicker').datetimepicker
    datepicker: false
    

  $(document).on 'click', '.status_check_box', (event) ->
    input = $(event.target)
#    if typeof(input.attr("data-status"))=="undefined"
#      alert("Please Confirm or Reject Confirmation Status")
#    else
    $.ajax
      dataType: 'script'
      type:"PUT"
      url: '/reservations/'+input.attr("data-reservation-id")
      data:
        restaurant_id: input.attr("data-reservation-id")
        confirmed: input.attr("data-status")


  $('.wait_time').click ->
    $('button').removeClass('active')
    $('.wait_time_field').val($(this).html());
  $('.wait_time_field').focus ->
    $('button').removeClass('active')

  window.getLocalTime = (date) ->
    a = new Date(date)
    a = new Date(a.toString())
    moment(date).format 'hh:mm a'


  $('.localtime').each (i, v) ->
    $(v).html getLocalTime($(v).attr('data-date'))
    return
  window.export_reservations = ->
    est_arr = [];
    $('.localtime').each (i, v) ->
      est_arr.push $(v).html()
    console.log(est_arr.toString()) 
    $('#est').val(est_arr.toString()) 
    $('form#reservation').attr('action','/reservations.csv');
    $('form#reservation').submit();
    $('form#reservation').attr('action','/reservations');
    return

  setInterval (->
    $('.clock').html moment().format('hh:mm a')
    return
    ), 1000




