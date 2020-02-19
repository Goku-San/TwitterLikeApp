# main notifications from controllers
$(document).on 'turbolinks:load', ->
  if $('.alert').attr('id') == 'danger' or $('.alert').attr('id') == 'warning'
    $('#button').on 'click', ->
      $('#notifications').fadeOut 700, ->
        $(this).remove()

  else
    $('#notifications').delay(1500).slideUp 500, ->
      $(this).remove()
