# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.edit-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    comment_id = $(this).data('commentId');
    $('form#edit-comment-' + comment_id).show();

  questionId = $('.question').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    console.log(data)
    comment = $.parseJSON(data['comment'])
    $('.question .comments').append(comment.id + ' ' + comment.body);
    $('.new_comment #comment_body').val('');

  answerId = $('.answers .answer').data('answerId')
  PrivatePub.subscribe '/answers/' + answerId + '/comments', (data, channel) ->
    console.log(data)
    comment = $.parseJSON(data['comment'])
    $('.answers .aswer .comments #' + answerId).append(comment.id + ' ' + comment.body);
    $('.new_comment #comment_body').val('');
