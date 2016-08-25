$(document).ready(function() {
  $('.course .name').hover(function(e) {
    var courseId = $(e.currentTarget).closest(".course").data("course-id");
    $(e.currentTarget).append("<div class='hover-description'style='display: none'></div>");
    $(".hover-description", $(e.currentTarget)).load("/courses/" + courseId + "?tooltip=1",
      function() { $(this).show(); }
    );
  }, function(e) {
    $(".hover-description", $(e.currentTarget)).remove();
  });
});