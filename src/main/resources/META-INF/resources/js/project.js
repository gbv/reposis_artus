document.addEventListener("DOMContentLoaded", function () {

    // spam protection for mails
    document.querySelectorAll('span.madress').forEach(function (span) {
        var text = span.textContent;
        var address = text.replace(" [at] ", "@");
        span.insertAdjacentHTML('afterend', '<a href="mailto:' + address + '">' + address + '</a>')
        span.remove();
    });

    // activate empty search on start page
    document.getElementById("project-searchMainPage")?.addEventListener("submit", function (evt) {
        this.querySelectorAll("input, select, textarea, button").forEach(function (el) {
            if (!el.value) {
                el.disabled = true;
            }
        });
        return true;
    });


    // We do not want to use the standard action mapping for adding reviews with "create-child"
    document.querySelectorAll("a[href*='editor-admins.xed']").forEach(function (a) {
        try {
            const url = new URL(a.getAttribute("href"));
            if (
                url.pathname.endsWith("editor-admins.xed") &&
                url.searchParams.has("relatedItemId") &&
                url.searchParams.get("genre") === "review"
            ) {
                url.pathname = url.pathname.replace("editor-admins.xed", "editor-review.xed");

                // Changed relatedItemType from host to reviewOf
                if (url.searchParams.get("relatedItemType") === "host") {
                    url.searchParams.set("relatedItemType", "reviewOf");
                }

                if (url.searchParams.has("genre")) {
                    url.searchParams.delete("genre");
                }

                a.setAttribute("href", url.toString());
            }
        } catch (e) {
            console.warn("Invalid URL skipped:", a.getAttribute("href"));
        }
    });
});

// Deletes all selectable genre options except those listed
new MutationObserver(function () {
    document.querySelectorAll("select#genre option").forEach(function (option) {
        if (![
            "book",
            "article",
            "collection",
            "thesis",
            "dissertation"
        ].includes(option.value)) {
            option.remove();
        }
    });

    // Deletes all selectable host options except those listed
    document.querySelectorAll("select#host option").forEach(function (option) {
        if (![
            "standalone",
            "journal",
            "collection",
            "series"
        ].includes(option.value)) {
            option.remove();
        }
    });
}).observe(document.documentElement, { childList: true, subtree: true });
