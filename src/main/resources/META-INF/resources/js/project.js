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

});
//Deletes all selectable genre options except those listed
$(document).ajaxComplete(function () {
    $("select#genre option").filter(function () {
        return ![
            "book",
            "article",
            "collection",
            "thesis",
            "unpublished_dissertation",
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