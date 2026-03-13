$(document).ready(function () {
    const genreSelect = document.querySelector('select[name*="mods:genre"][name$="@valueURIxEditor"]');

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

    document.addEventListener("DOMContentLoaded", function () {
        const saveButton = document.querySelector('button[name="_xed_submit_servlet:CreateObjectServlet"]');
        if (!saveButton) return;

        saveButton.addEventListener("click", function () {
            const titleInput = document.querySelector('input[name="/mycoreobject/metadata[1]/def.modsContainer[1]/modsContainer[1]/mods:mods[1]/mods:titleInfo[1]/mods:title[1]"]');
            const noteTextarea = document.querySelector('textarea[name="/mycoreobject/metadata[1]/def.modsContainer[1]/modsContainer[1]/mods:mods[1]/mods:note[1]"]');
            const reviewedTitleInput = document.querySelector('input[name*="relatedItem"][name*="titleInfo"][name*="mods:title"]');
            const authorInputs = document.querySelectorAll('input[ref_key="searchBox"]');

            if (!titleInput || titleInput.value.trim() !== "") {
                return;
            }

            const bookTitle = reviewedTitleInput ? reviewedTitleInput.value.trim() : "";
            if (!bookTitle) {
                return;
            }

            const authors = Array.from(authorInputs)
                .map(a => a.value.trim())
                .filter(a => a !== "");

            let authorText = "";
            if (authors.length === 1) {
                authorText = authors[0];
            } else if (authors.length === 2) {
                authorText = authors.join(" and ");
            } else if (authors.length > 2) {
                authorText = authors[0] + " et al.";
            }

            let generatedTitle = `Review of "${bookTitle}"`;
            if (authorText) {
                generatedTitle += ` by ${authorText}`;
            }

            titleInput.value = generatedTitle;
            titleInput.dispatchEvent(new Event("input", {bubbles: true}));
            titleInput.dispatchEvent(new Event("change", {bubbles: true}));

            if (noteTextarea) {
                const noteWrapper = noteTextarea.closest(".d-none");
                if (noteWrapper) {
                    noteWrapper.classList.remove("d-none");
                }
                noteTextarea.value = "The title of this metadata was automatically generated";
                noteTextarea.dispatchEvent(new Event("input", {bubbles: true}));
                noteTextarea.dispatchEvent(new Event("change", {bubbles: true}));
            }
        });
    });
});
