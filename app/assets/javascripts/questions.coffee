# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  PrivatePub.subscribe '/questions/new', (data, channel) ->
    console.log(data)
    question = $.parseJSON(data['question'])
    html = '<tr class="question_' + question.id + '"><td>' + question.user_id + '</td><td>' + question.title + '</td></tr>'
    $('#questions').append(html);

jQuery ->
  $('#questions').DataTable()
