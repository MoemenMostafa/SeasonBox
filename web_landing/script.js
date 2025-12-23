document.addEventListener('DOMContentLoaded', () => {
    const languageSelect = document.getElementById('languageSelect');

    // 1. Priority: URL Path > LocalStorage > Browser Language

    // Check path for language (e.g. /es/...)
    const pathSegments = window.location.pathname.split('/').filter(p => p.length > 0);
    const pathLang = pathSegments.length > 0 && ['en', 'de', 'es', 'fr', 'it'].includes(pathSegments[0]) ? pathSegments[0] : null;

    // Store/Retrieve from localStorage
    const storedLang = localStorage.getItem('seasonbox_lang');

    // Detect browser language
    const browserLang = navigator.language.split('-')[0];
    const supportedLangs = ['en', 'de', 'es', 'fr', 'it'];

    let initialLang = 'en';
    if (pathLang) {
        initialLang = pathLang;
    } else if (storedLang && supportedLangs.includes(storedLang)) {
        initialLang = storedLang;
        // If we have a stored lang but no path lang, maybe redirect? 
        // For now, let's just use it to render content.
    } else if (supportedLangs.includes(browserLang)) {
        initialLang = browserLang;
    }

    if (languageSelect) {
        languageSelect.value = initialLang;
        languageSelect.addEventListener('change', (e) => {
            const newLang = e.target.value;
            updateLanguage(newLang);
            updateUrl(newLang);
        });
    }

    // Initial Update
    updateLanguage(initialLang);

    // Enforce URL structure: /:lang/...
    // If path doesn't start with correctly supported lang, we redirect/replace to initialLang
    if (!pathLang || pathLang !== initialLang) {
        updateUrl(initialLang, true);
    }

    // Explicitly scroll to hash if present, to handle potential layout shifts or history updates
    if (window.location.hash) {
        setTimeout(() => {
            const element = document.querySelector(window.location.hash);
            if (element) {
                const headerOffset = 120; // Adjust based on your header height + buffer
                const elementPosition = element.getBoundingClientRect().top;
                const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                window.scrollTo({
                    top: offsetPosition,
                    behavior: "smooth"
                });
            }
        }, 100);
    }
});

function updateUrl(lang, replace = false) {
    const supportedLangs = ['en', 'de', 'es', 'fr', 'it'];
    let pathSegments = window.location.pathname.split('/').filter(p => p.length > 0);

    // If first segment is a lang code, replace it. Else prepend it.
    if (pathSegments.length > 0 && supportedLangs.includes(pathSegments[0])) {
        pathSegments[0] = lang;
    } else {
        pathSegments.unshift(lang);
    }

    // Removing 'en' from path if desired to keep root clean? 
    // User requested ./xx, so let's keep it explicit for all non-default or even default if they want consistency.
    // Let's assume we want explicit /en/ too for consistency based on "rewrite ?lang=xx to ./xx"

    const newPath = '/' + pathSegments.join('/');

    // Keep query params if any (though we removed ?lang)
    const params = new URLSearchParams(window.location.search);
    params.delete('lang'); // clean up legacy param
    const queryString = params.toString() ? '?' + params.toString() : '';

    const newUrl = newPath + queryString + window.location.hash;

    if (replace) {
        window.history.replaceState({}, '', newUrl);
    } else {
        window.history.pushState({}, '', newUrl);
    }

    // Update internal links to persist language
    updateInternalLinks(lang);
}

function updateInternalLinks(lang) {
    const supportedLangs = ['en', 'de', 'es', 'fr', 'it'];
    const internalLinks = document.querySelectorAll('a[href^="/"], a[href^="index"], a[href^="privacy"], a[href^="terms"], a[href^="home"], a[href^="help"]');

    internalLinks.forEach(link => {
        let url = new URL(link.href, window.location.origin);
        if (url.origin === window.location.origin) {
            let pathSegments = url.pathname.split('/').filter(p => p.length > 0);

            // Remove existing lang prefix if present
            if (pathSegments.length > 0 && supportedLangs.includes(pathSegments[0])) {
                pathSegments.shift();
            }

            // Add new lang prefix
            pathSegments.unshift(lang);

            link.href = '/' + pathSegments.join('/') + url.search + url.hash;
        }
    });
}

function updateLanguage(lang) {
    // Save preference
    localStorage.setItem('seasonbox_lang', lang);

    const translations = (typeof l10n !== 'undefined') ? l10n[lang] : null;
    if (!translations) return;

    // Update all elements with data-i18n attribute
    const elements = document.querySelectorAll('[data-i18n]');
    elements.forEach(element => {
        const key = element.getAttribute('data-i18n');
        if (translations[key]) {
            element.innerHTML = translations[key];
        }
    });

    // Update document title if needed
    if (translations['appTitle']) {
        document.title = `${translations['appTitle']} - ${translations['login_tagline']}`;
    }

    // Update HTML lang attribute
    document.documentElement.lang = lang;

    // Update Google Play Badge
    const badge = document.getElementById('googlePlayBadge');
    if (badge) {
        badge.src = `assets/images/google/badge_${lang}.png`;
    }

    // Also insure links are updated on language switch
    updateInternalLinks(lang);
}
