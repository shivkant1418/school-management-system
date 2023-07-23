// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import * as bootstrap from "bootstrap"

import jquery from 'jquery'
window.jQuery = jquery
window.$ = jquery

$(document).on('change', 'select#enrollment_school_id', function () {
  $('select#enrollment_course_id')
    .attr('disabled', '')
    .find('option')
    .remove()
    .end()
    .append("<option value='' selected='selected'>Select Course ...</option>");

  $('select#enrollment_batch_id')
    .attr('disabled', '')
    .find('option')
    .remove()
    .end()
    .append("<option value='' selected='selected'>Select Batch ...</option>");

  if ($(this).val() != '') {
    $.ajax({
      type: "get",
      url: '/admin/courses',
      data: { school_id: $(this).val() },
      success: function(data){
        $.each(data.courses, function(key, course) {
          $('select#enrollment_course_id')
            .removeAttr('disabled', '')
            .append($("<option></option>")
            .attr("value", course.id)
            .text(course.name));
        });
      },
      dataType: 'json'
    });
  }
});

$(document).on('change', 'select#enrollment_course_id', function () {
  $('select#enrollment_batch_id')
    .attr('disabled', '')
    .find('option')
    .remove()
    .end()
    .append("<option value='' selected='selected'>Select Batch ...</option>");

  if ($(this).val() != '') {
    $.ajax({
      type: "get",
      url: '/admin/batches',
      data: { course_id: $(this).val() },
      success: function(data){
        $.each(data.batches, function(key, batch) {
          $('select#enrollment_batch_id')
            .removeAttr('disabled', '')
            .append($("<option></option>")
            .attr("value", batch.id)
            .text(batch.name));
        });
      },
      dataType: 'json'
    });
  }
});