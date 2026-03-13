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


    //We do not want to use the standard action mapping for adding reviews with "create-child"
    $("a[href*='editor-admins.xed']").each(function () {
        try {
            const url = new URL($(this).attr("href"));
            if (
                url.pathname.endsWith("editor-admins.xed") &&
                url.searchParams.has("relatedItemId") &&
                url.searchParams.get("genre") === "review"
            ) {
                url.pathname = url.pathname.replace("editor-admins.xed", "editor-review.xed");
                $(this).attr("href", url.toString());
            }
        } catch (e) {
            console.warn("Invalid URL skipped:", $(this).attr("href"));
        }
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




