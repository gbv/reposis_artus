$(document).ready(function () {

    // spam protection for mails
    $('span.madress').each(function (i) {
        var text = $(this).text();
        var address = text.replace(" [at] ", "@");
        $(this).after('<a href="mailto:' + address + '">' + address + '</a>')
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

    const genreSelect = document.querySelector(
        'select[name*="mods:genre"][name$="@valueURIxEditor"]'
    );

    if (genreSelect) {
        const wasReviewSelected = (genreSelect.value === "review");
        const reviewOption = genreSelect.querySelector('option[value="review"]');
        //remove the option review, so it can not be selected
        if (reviewOption) reviewOption.remove();
        if (wasReviewSelected) {
            //if it was selected before reset publikationstyp to "Bitte wählen"
            const emptyOption = genreSelect.querySelector('option[value=""]');
            if (emptyOption) emptyOption.selected = true;
            genreSelect.dispatchEvent(new Event("change"));
            const relatedItemSelect = document.querySelector('select[name*="mods:relatedItem"]');

            if (relatedItemSelect) {
                //also if review was previously selected the relation of the related item should be "Rezension von"
                const reviewOfOpt = relatedItemSelect.querySelector('option[value="reviewOf"]');
                if (reviewOfOpt) {
                    reviewOfOpt.selected = true;
                }
            }
        }
    }
});
//Deletes all selectable genre options except those listed
$(document).ajaxComplete(function () {
    $("select#genre option").filter(function () {
        return ![
            "book",
            "article",
            "collection",
            "thesis",
            "dissertation"

        ].includes($(this).val());
    }).remove();

//Deletes all selectable host options except those listed
    $("select#host option").filter(function () {
        return ![
            "standalone",
            "journal",
            "collection",
            "series"
        ]
            .includes($(this).val());
    }).remove();
});