# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  paintIt = (element, backgroundColor, textColor) ->
    element.style.backgroundColor = backgroundColor
    if textColor?
      element.style.color = textColor
#  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
#    answer = $.parseJSON(xhr.responseText)
#    $('.answers').append(answer.user_id + ' ' + answer.body + '<br>');
#  .bind 'ajax:success', (e, xhr, status, error) ->
#    errors = $.parseJSON(xhr.responseText)
#    $.each errors, (index, value) ->
#      $('.answer-errors').append(value);
  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    console.log(data)
    answer = $.parseJSON(data['answer'])
    $('.answers').append('<div class="answer" id="answer_' + answer.id + '">' + answer.user_id + ' ' + answer.body);
    $('.answers').append('<a href="#" onclick="paintIt(this, "#990000")">Edit</a>');
    $('.new_answer #answer_body').val('');

