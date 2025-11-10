
$(document).ready(function() {

  // spam protection for mails
  $('span.madress').each(function(i) {
      var text = $(this).text();
      var address = text.replace(" [at] ", "@");
      $(this).after('<a href="mailto:'+address+'">'+ address +'</a>')
      $(this).remove();
  });

  // activate empty search on start page
  $("#project-searchMainPage").submit(function (evt) {
    $(this).find(":input").filter(function () {
          return !this.value;
      }).attr("disabled", true);
    return true;
  });

  //Disserations have a xed:validator for related item. Though disabled fields are ignored during validation, making it seem as if the field does not exist.
  //Therefore the disabled title field must be automatically enabled before the document is sent.
    document.querySelectorAll('button[name="_xed_submit_servlet:CreateObjectServlet"], button[name="_xed_submit_servlet:UpdateObjectServlet"]')
        .forEach(btn => {
            const form = btn.closest('form');
            function onClick(e) {
                e.preventDefault();
                form.querySelectorAll('.mir-fieldset-content.mir-related-item-search input[disabled]')
                    .forEach(i => {
                        i.removeAttribute('disabled');
                    });
                btn.removeEventListener('click', onClick);
                setTimeout(() => {
                    btn.click();
                }, 0);
            }
            btn.addEventListener('click', onClick);
        });



});
