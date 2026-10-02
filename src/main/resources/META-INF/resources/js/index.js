async function getTranslation(locale, name) {
  const response = await fetch(`../rsc/locale/translate/${locale}/${name}`);
  if (!response.ok) {
    throw new Error(`HTTP error ${response.status}`);
  }
  return await response.text();
}

async function getDocumentCount(includeReviews = false) {
  const filter = includeReviews ? '' : ' AND -mods.relatedItem:*reviewOf*';
  const query = encodeURIComponent(`objectType:mods AND state:published${filter}`);

  const response = await fetch(`../api/v1/search?q=${query}&rows=0&wt=json`);
  if (!response.ok) {
    throw new Error(`HTTP error ${response.status}`);
  }
  const data = await response.json();
  return data?.response?.numFound ?? 0;
}

function ignoreEmptyFieldsOnSubmit(event) {
  const form = event.currentTarget;
  const inputs = form.querySelectorAll('input');

  inputs.forEach(input => {
    if (!input.value) {
      input.dataset.nameBackup = input.name;
      input.removeAttribute('name');
    }
  });

  setTimeout(() => {
    inputs.forEach(input => {
      if (input.dataset.nameBackup) {
        input.name = input.dataset.nameBackup;
        delete input.dataset.nameBackup;
      }
    });
  }, 0);
}

document.addEventListener('DOMContentLoaded', async () => {
  const form = document.getElementById('project-searchMainPage');
  const input = document.getElementById('project-searchInput');
  const switchReviews = document.getElementById('switchReviews');

  form?.addEventListener('submit', ignoreEmptyFieldsOnSubmit);

  if (input) {
    try {
      const placeholder = await getTranslation(currentLang, 'artus.index.search.placeholder');

      const updateCount = async () => {
        const count = await getDocumentCount(switchReviews?.checked ?? false);
        input.placeholder = placeholder.replace('{0}', count.toLocaleString('de-DE'));
      };

      switchReviews?.addEventListener('change', updateCount);
      await updateCount();
    } catch (err) {
      console.error('Error updating search placeholder:', err);
    }
  }
});


