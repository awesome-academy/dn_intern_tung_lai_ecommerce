(function ($) {
  /**
   * Toggle parent category: show subcategories
   */
  $(".toggle-down-wrapper").each((indx, elm) => {
    elm = $(elm);
    let main = $(".toggle-down-main", elm);
    let content = $(".toggle-down-content", elm);
    console.log(main, content);
    main.on("click", () => content.slideToggle(400));
  });
})(jQuery);
