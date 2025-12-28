// Firebase Configuration
const firebaseConfig = {
    apiKey: 'AIzaSyD9qccu0ew4wWuBX1LeDFlZFYFRPGwTENM',
    appId: '1:839774020308:web:a6d9f7c8e9b0c1d2e3f4f5',
    messagingSenderId: '839774020308',
    projectId: 'seasonbox-f4b24',
    authDomain: 'seasonbox-f4b24.firebaseapp.com',
    storageBucket: 'seasonbox-f4b24.firebasestorage.app',
};

// Global pricing state
let pricingConfig = {
    monthly: '4.99',
    yearly: '49.99'
};

document.addEventListener('DOMContentLoaded', () => {
    const languageSelect = document.getElementById('languageSelect');

    // 1. Priority: URL Path > LocalStorage > Browser Language

    // Check path for language (e.g. /es/...)
    const pathSegments = window.location.pathname.split('/').filter(p => p.length > 0);
    const pathLang = pathSegments.length > 0 && ['en', 'de', 'es', 'fr', 'it'].includes(pathSegments[0]) ? pathSegments[0] : null;

    // Store/Retrieve from localStorage
    let storedLang = null;
    try {
        storedLang = localStorage.getItem('seasonbox_lang');
    } catch (e) {
        console.warn('LocalStorage not accessible:', e);
    }

    // Detect browser language
    const browserLang = navigator.language.split('-')[0];
    const supportedLangs = ['en', 'de', 'es', 'fr', 'it'];

    let initialLang = 'en';
    if (pathLang) {
        initialLang = pathLang;
    } else if (storedLang && supportedLangs.includes(storedLang)) {
        initialLang = storedLang;
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
    // Only if not on a local file system
    if (window.location.protocol !== 'file:') {
        if (!pathLang || pathLang !== initialLang) {
            updateUrl(initialLang, true);
        }
    }

    // Explicitly scroll to hash if present
    if (window.location.hash && window.location.hash !== '#delete-account') {
        setTimeout(() => {
            try {
                const element = document.querySelector(window.location.hash);
                if (element) {
                    const headerOffset = 120;
                    const elementPosition = element.getBoundingClientRect().top;
                    const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                    window.scrollTo({
                        top: offsetPosition,
                        behavior: "smooth"
                    });
                }
            } catch (e) {
                console.warn('Hash scroll failed:', e);
            }
        }, 100);
    }

    // Handle Contact Form Submission
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        // Check hash for pre-selecting account deletion
        if (window.location.hash === '#delete-account') {
            const typeSelect = document.getElementById('type');
            if (typeSelect) {
                typeSelect.value = 'delete';
                // Scroll to form after a small delay
                setTimeout(() => {
                    contactForm.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }, 500);
            }
        }

        contactForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            const typeSelect = document.getElementById('type');
            const type = typeSelect.options[typeSelect.selectedIndex].text;
            const message = document.getElementById('message').value;

            const subject = `SeasonBox Contact: ${type}`;
            const body = `Name: ${name}\nEmail: ${email}\nType: ${type}\n\nMessage:\n${message}`;

            window.location.href = `mailto:support@seasonbox.app?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
            return false;
        });
    }

    // Initialize Firebase
    initFirebase();

    // Setup Pricing Toggle
    const billingToggle = document.getElementById('billingToggle');
    if (billingToggle) {
        billingToggle.addEventListener('change', () => {
            updatePricingDisplay();
            // Track toggle event
            if (typeof posthog !== 'undefined') {
                posthog.capture('web_pricing_toggle_changed', {
                    billing_period: billingToggle.checked ? 'yearly' : 'monthly'
                });
            }
        });
    }
});

async function initFirebase() {
    try {
        // Load Firebase SDKs dynamically to avoid blocking
        const scripts = [
            'https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js',
            'https://www.gstatic.com/firebasejs/10.7.1/firebase-remote-config-compat.js'
        ];

        for (const src of scripts) {
            await new Promise((resolve) => {
                const script = document.createElement('script');
                script.src = src;
                script.onload = resolve;
                document.head.appendChild(script);
            });
        }

        // Initialize App
        const app = firebase.initializeApp(firebaseConfig);
        const remoteConfig = firebase.remoteConfig();

        remoteConfig.settings = {
            minimumFetchIntervalMillis: 600000, // 10 minutes
        };

        remoteConfig.defaultConfig = {
            'subscription_pricing': JSON.stringify(pricingConfig)
        };

        await remoteConfig.fetchAndActivate();

        const val = remoteConfig.getString('subscription_pricing');
        if (val) {
            pricingConfig = JSON.parse(val);
            updatePricingDisplay();
        }
    } catch (error) {
        console.error("Firebase Initialization Error:", error);
    }
}

function updatePricingDisplay() {
    const isYearly = document.getElementById('billingToggle')?.checked;
    const priceElement = document.getElementById('premiumPrice');
    const suffixElement = document.getElementById('priceSuffix');
    const lang = localStorage.getItem('seasonbox_lang') || 'en';

    if (priceElement && suffixElement) {
        const price = isYearly ? pricingConfig.yearly : pricingConfig.monthly;
        priceElement.innerText = price;

        const suffixKey = isYearly ? 'pricing_suffix_yearly' : 'pricing_suffix_monthly';
        if (l10n[lang] && l10n[lang][suffixKey]) {
            suffixElement.innerHTML = l10n[lang][suffixKey];
        }
    }
}

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

    // Update dynamic pricing labels
    updatePricingDisplay();

    // Update Google Play Badge
    const badge = document.getElementById('googlePlayBadge');
    if (badge) {
        badge.src = `assets/images/google/badge_${lang}.png`;
    }

    // Also insure links are updated on language switch
    updateInternalLinks(lang);
}
