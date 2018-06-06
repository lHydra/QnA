@error = ->
  $ ->
    $("#new_comment").bind "ajax:error", (event, jqXHR, ajaxSettings, thrownError) ->
      if jqXHR.status == 401 # thrownError is 'Unauthorized'
        $(".comments-errors").html('To comment this you must either sign up for an account')
@error()
