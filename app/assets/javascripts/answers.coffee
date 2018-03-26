# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@update = ->
  $ ->
    $('.edit-answer-link').click (e) ->
      e.preventDefault()
      $(this).hide()
      answer_id = $(this).data('answerId')
      $('form#edit-answer-' + answer_id).show()
@update()

$ ->
  $("#new_answer").bind "ajax:error", (event, jqXHR, ajaxSettings, thrownError) ->
    if jqXHR.status == 401 # thrownError is 'Unauthorized'
      $(".errors").html('To answer a question, you must either sign up for an account')
