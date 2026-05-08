const screens = document.querySelectorAll(".screen");
const navButtons = document.querySelectorAll(".nav-btn");

const fromCurrency = document.getElementById("fromCurrency");
const toCurrency = document.getElementById("toCurrency");
const fromCurrencyCode = document.getElementById("fromCurrencyCode");
const toCurrencyCode = document.getElementById("toCurrencyCode");

const fromAmount = document.getElementById("fromAmount");
const toAmount = document.getElementById("toAmount");
const rateInfo = document.getElementById("rateInfo");

const numberButtons = document.querySelectorAll(".number-pad button");
const swapBtn = document.getElementById("swapBtn");

const clearHistoryBtn = document.getElementById("clearHistoryBtn");
const historyList = document.getElementById("historyList");

const themeToggle = document.getElementById("themeToggle");
const languageSelect = document.getElementById("languageSelect");
const homeCurrencySelect = document.getElementById("homeCurrencySelect");
const fontSizeSelect = document.getElementById("fontSizeSelect");

const openFavoriteFormBtn = document.getElementById("openFavoriteFormBtn");
const favoriteForm = document.getElementById("favoriteForm");
const favoriteFromSelect = document.getElementById("favoriteFromSelect");
const favoriteToSelect = document.getElementById("favoriteToSelect");
const addFavoriteBtn = document.getElementById("addFavoriteBtn");
const favoritesList = document.getElementById("favoritesList");

const extra1Code = document.getElementById("extra1Code");
const extra1Name = document.getElementById("extra1Name");
const extra1Amount = document.getElementById("extra1Amount");
const extra1Rate = document.getElementById("extra1Rate");

const extra2Code = document.getElementById("extra2Code");
const extra2Name = document.getElementById("extra2Name");
const extra2Amount = document.getElementById("extra2Amount");
const extra2Rate = document.getElementById("extra2Rate");

const extra3Code = document.getElementById("extra3Code");
const extra3Name = document.getElementById("extra3Name");
const extra3Amount = document.getElementById("extra3Amount");
const extra3Rate = document.getElementById("extra3Rate");

let currentInput = "1000";

const currencyNames = {
  EUR: "Euro",
  USD: "US-Dollar",
  GBP: "Britisches Pfund",
  CHF: "Schweizer Franken",
  TRY: "Türkische Lira",
  INR: "Indische Rupie",
  JPY: "Japanischer Yen",
  CNY: "Chinesischer Yuan",
  AUD: "Australischer Dollar",
  CAD: "Kanadischer Dollar",
  SEK: "Schwedische Krone",
  NOK: "Norwegische Krone",
  DKK: "Dänische Krone",
  PLN: "Polnischer Złoty",
  CZK: "Tschechische Krone",
  HUF: "Ungarischer Forint",
  RON: "Rumänischer Leu",
  BGN: "Bulgarischer Lew",
  AED: "VAE-Dirham",
  SAR: "Saudi-Riyal",
  QAR: "Katar-Riyal",
  KWD: "Kuwait-Dinar",
  BRL: "Brasilianischer Real",
  MXN: "Mexikanischer Peso",
  ZAR: "Südafrikanischer Rand"
};

const currencyNamesEnglish = {
  EUR: "Euro",
  USD: "US Dollar",
  GBP: "British Pound",
  CHF: "Swiss Franc",
  TRY: "Turkish Lira",
  INR: "Indian Rupee",
  JPY: "Japanese Yen",
  CNY: "Chinese Yuan",
  AUD: "Australian Dollar",
  CAD: "Canadian Dollar",
  SEK: "Swedish Krona",
  NOK: "Norwegian Krone",
  DKK: "Danish Krone",
  PLN: "Polish Zloty",
  CZK: "Czech Koruna",
  HUF: "Hungarian Forint",
  RON: "Romanian Leu",
  BGN: "Bulgarian Lev",
  AED: "UAE Dirham",
  SAR: "Saudi Riyal",
  QAR: "Qatari Riyal",
  KWD: "Kuwaiti Dinar",
  BRL: "Brazilian Real",
  MXN: "Mexican Peso",
  ZAR: "South African Rand"
};

/*
  Beispielkurse:
  Basis: 1 EUR = x Fremdwährung
*/
let eurRates = {};

let favorites = [
  { from: "EUR", to: "USD" },
  { from: "GBP", to: "EUR" },
  { from: "CHF", to: "EUR" }
];

function showScreen(screenId) {
  screens.forEach((screen) => {
    screen.classList.remove("active");
  });

  navButtons.forEach((button) => {
    button.classList.remove("active");
  });

  const selectedScreen = document.getElementById(screenId);
  const selectedButton = document.querySelector(`[data-screen="${screenId}"]`);

  if (selectedScreen) {
    selectedScreen.classList.add("active");
  }

  if (selectedButton) {
    selectedButton.classList.add("active");
  }
}

navButtons.forEach((button) => {
  button.addEventListener("click", () => {
    showScreen(button.dataset.screen);
  });
});

function parseGermanNumber(value) {
  return Number(value.replace(",", "."));
}

function formatGermanNumber(value, digits = 2) {
  return new Intl.NumberFormat("de-DE", {
    minimumFractionDigits: 0,
    maximumFractionDigits: digits
  }).format(value);
}

function getConvertedAmount(amount, from, to) {
  const amountInEUR = amount / eurRates[from];
  return amountInEUR * eurRates[to];
}

function getCurrentCurrencyNames() {
  if (languageSelect && languageSelect.value === "en") {
    return currencyNamesEnglish;
  }

  return currencyNames;
}

function updateExtraCards(amount, from, to) {
  const names = getCurrentCurrencyNames();
  const allCurrencies = Object.keys(eurRates);

  const extraCurrencies = allCurrencies
    .filter((currency) => currency !== from && currency !== to)
    .slice(0, 3);

  const extraElements = [
    {
      code: extra1Code,
      name: extra1Name,
      amount: extra1Amount,
      rate: extra1Rate
    },
    {
      code: extra2Code,
      name: extra2Name,
      amount: extra2Amount,
      rate: extra2Rate
    },
    {
      code: extra3Code,
      name: extra3Name,
      amount: extra3Amount,
      rate: extra3Rate
    }
  ];

  extraCurrencies.forEach((currency, index) => {
    const converted = getConvertedAmount(amount, from, currency);
    const rate = getConvertedAmount(1, from, currency);

    extraElements[index].code.textContent = currency;
    extraElements[index].name.textContent = names[currency];
    extraElements[index].amount.textContent = formatGermanNumber(converted);
    extraElements[index].rate.textContent = `1 ${from} = ${formatGermanNumber(rate, 4)} ${currency}`;
  });
}

function updateConverter() {
  const amount = parseGermanNumber(currentInput);
  const from = fromCurrency.value;
  const to = toCurrency.value;

  if (Number.isNaN(amount)) {
    fromAmount.textContent = "0";
    toAmount.textContent = "0";
    return;
  }

  const result = getConvertedAmount(amount, from, to);
  const singleRate = getConvertedAmount(1, from, to);

  fromCurrencyCode.textContent = from;
  toCurrencyCode.textContent = to;

  fromAmount.textContent = formatGermanNumber(amount);
  toAmount.textContent = formatGermanNumber(result);
  rateInfo.textContent = `1 ${from} = ${formatGermanNumber(singleRate, 4)} ${to}`;

  updateExtraCards(amount, from, to);
  renderFavorites();
}

function handleNumberInput(value) {
  if (value === "delete") {
    currentInput = currentInput.slice(0, -1);

    if (currentInput === "") {
      currentInput = "0";
    }

    updateConverter();
    return;
  }

  if (value === "," && currentInput.includes(",")) {
    return;
  }

  if (currentInput === "0" && value !== ",") {
    currentInput = value;
  } else {
    currentInput += value;
  }

  updateConverter();
}

numberButtons.forEach((button) => {
  button.addEventListener("click", () => {
    handleNumberInput(button.dataset.value);
  });
});

swapBtn.addEventListener("click", () => {
  const temp = fromCurrency.value;
  fromCurrency.value = toCurrency.value;
  toCurrency.value = temp;

  updateConverter();
});

fromCurrency.addEventListener("change", updateConverter);
toCurrency.addEventListener("change", updateConverter);

if (clearHistoryBtn) {
  clearHistoryBtn.addEventListener("click", () => {
    historyList.innerHTML = `
      <div class="empty-alert-box">
        <div>🗑</div>
        <p>Der Verlauf wurde gelöscht.</p>
      </div>
    `;
  });
}

if (themeToggle) {
  themeToggle.addEventListener("change", () => {
    if (themeToggle.checked) {
      document.body.classList.add("light-mode");
    } else {
      document.body.classList.remove("light-mode");
    }
  });
}

if (homeCurrencySelect) {
  homeCurrencySelect.addEventListener("change", () => {
    fromCurrency.value = homeCurrencySelect.value;

    if (fromCurrency.value === toCurrency.value) {
      toCurrency.value = fromCurrency.value === "USD" ? "EUR" : "USD";
    }

    updateConverter();
  });
}

if (fontSizeSelect) {
  fontSizeSelect.addEventListener("change", () => {
    document.body.classList.remove("font-small", "font-large");

    if (fontSizeSelect.value === "small") {
      document.body.classList.add("font-small");
    }

    if (fontSizeSelect.value === "large") {
      document.body.classList.add("font-large");
    }
  });
}

function renderFavorites() {
  if (!favoritesList) return;

  const names = getCurrentCurrencyNames();
  favoritesList.innerHTML = "";

  favorites.forEach((favorite, index) => {
    const rate = getConvertedAmount(1, favorite.from, favorite.to);
    const changeValue = index % 2 === 0 ? "+0.21%" : "-0.09%";
    const changeClass = index % 2 === 0 ? "positive" : "negative";

    const favoriteCard = document.createElement("div");
    favoriteCard.className = "favorite-card";

    favoriteCard.innerHTML = `
      <div class="favorite-left">
        <div class="star-icon">★</div>
        <div>
          <h4>${favorite.from} / ${favorite.to}</h4>
          <p>${names[favorite.from].toUpperCase()} ZU ${names[favorite.to].toUpperCase()}</p>
        </div>
      </div>

      <div class="favorite-right ${changeClass}">
        <h4>${formatGermanNumber(rate, 4)}</h4>
        <p>${changeValue}</p>
      </div>

      <button class="remove-favorite-btn" data-index="${index}">✕</button>
    `;

    favoritesList.appendChild(favoriteCard);
  });

  const removeButtons = document.querySelectorAll(".remove-favorite-btn");

  removeButtons.forEach((button) => {
    button.addEventListener("click", () => {
      const index = Number(button.dataset.index);
      favorites.splice(index, 1);
      renderFavorites();
    });
  });
}

if (openFavoriteFormBtn) {
  openFavoriteFormBtn.addEventListener("click", () => {
    favoriteForm.classList.toggle("hidden");
  });
}

if (addFavoriteBtn) {
  addFavoriteBtn.addEventListener("click", () => {
    const from = favoriteFromSelect.value;
    const to = favoriteToSelect.value;

    if (from === to) {
      alert("Bitte zwei unterschiedliche Währungen auswählen.");
      return;
    }

    const alreadyExists = favorites.some((favorite) => {
      return favorite.from === from && favorite.to === to;
    });

    if (alreadyExists) {
      alert("Dieses Währungspaar ist bereits in deinen Favoriten.");
      return;
    }

    favorites.push({ from, to });
    favoriteForm.classList.add("hidden");
    renderFavorites();
  });
}

const translations = {
  de: {
    appTitle: "CURRENCY CONVERTER",

    fromLabel: "Von",
    toLabel: "Nach",
    moreCurrenciesTitle: "Weitere Währungen",

    historySubtitle: "WÄHRUNGS-ZENTRALE",
    historyTitle: "Verlauf",
    historySearchInput: "Suche im Verlauf",
    lastRequestsTitle: "Letzte Abfragen",
    clearHistoryBtn: "ALLE LÖSCHEN",
    favoritesTitle: "Favoriten",
    openFavoriteFormBtn: "+ Hinzufügen",
    addFavoriteBtn: "Favorit speichern",

    alertsSubtitle: "BENACHRICHTIGUNGEN",
    alertsTitle: "Alarme",
    activeAlertText: "AKTIV",
    pausedAlertText: "PAUSIERT",
    alertConditionOne: "Melden, wenn > 1,05",
    alertConditionTwo: "Melden, wenn > 105,00",
    currentRateTextOne: "AKTUELLER KURS",
    currentRateTextTwo: "AKTUELLER KURS",
    emptyAlertText: "Füge weitere Währungspaare zur Überwachung hinzu",

    settingsTitle: "Einstellungen",
    settingsSubtitle: "Hier kannst du Darstellung und Optionen anpassen.",
    generalTitle: "ALLGEMEIN",
    languageTitle: "Sprache",
    languageDesc: "Systemsprache auswählen",
    homeCurrencyTitle: "Heimatwährung",
    homeCurrencyDesc: "Standardwährung auswählen",
    appearanceTitle: "ERSCHEINUNGSBILD",
    themeTitle: "Heller Modus",
    themeDesc: "Beim Aktivieren wird die App weiß",
    fontSizeTitle: "Schriftgröße",
    fontSizeDesc: "Textgröße anpassen",
    dataTitle: "DATEN",
    offlineTitle: "Offline-Modus",
    offlineDesc: "Nur über WLAN synchronisieren",
    cacheTitle: "Cache leeren",
    cacheDesc: "Lokalen Speicher freigeben",

    navConverter: "Konverter",
    navHistory: "Verlauf",
    navAlerts: "Alarme",
    navSettings: "Einstellungen"
  },

  en: {
    appTitle: "CURRENCY CONVERTER",

    fromLabel: "From",
    toLabel: "To",
    moreCurrenciesTitle: "More currencies",

    historySubtitle: "CURRENCY CENTER",
    historyTitle: "History",
    historySearchInput: "Search history",
    lastRequestsTitle: "Recent conversions",
    clearHistoryBtn: "CLEAR ALL",
    favoritesTitle: "Favorites",
    openFavoriteFormBtn: "+ Add",
    addFavoriteBtn: "Save favorite",

    alertsSubtitle: "NOTIFICATIONS",
    alertsTitle: "Alerts",
    activeAlertText: "ACTIVE",
    pausedAlertText: "PAUSED",
    alertConditionOne: "Notify when > 1.05",
    alertConditionTwo: "Notify when > 105.00",
    currentRateTextOne: "CURRENT RATE",
    currentRateTextTwo: "CURRENT RATE",
    emptyAlertText: "Add more currency pairs for monitoring",

    settingsTitle: "Settings",
    settingsSubtitle: "Manage appearance and options.",
    generalTitle: "GENERAL",
    languageTitle: "Language",
    languageDesc: "Choose system language",
    homeCurrencyTitle: "Home currency",
    homeCurrencyDesc: "Choose default currency",
    appearanceTitle: "APPEARANCE",
    themeTitle: "Light mode",
    themeDesc: "When enabled, the app becomes white",
    fontSizeTitle: "Font size",
    fontSizeDesc: "Adjust text size",
    dataTitle: "DATA",
    offlineTitle: "Offline mode",
    offlineDesc: "Sync only over Wi-Fi",
    cacheTitle: "Clear cache",
    cacheDesc: "Free local storage",

    navConverter: "Converter",
    navHistory: "History",
    navAlerts: "Alerts",
    navSettings: "Settings"
  }
};

function setText(id, value) {
  const element = document.getElementById(id);

  if (element) {
    element.textContent = value;
  }
}

function setPlaceholder(id, value) {
  const element = document.getElementById(id);

  if (element) {
    element.placeholder = value;
  }
}

function changeLanguage(language) {
  const text = translations[language];

  setText("appTitle", text.appTitle);

  setText("fromLabel", text.fromLabel);
  setText("toLabel", text.toLabel);
  setText("moreCurrenciesTitle", text.moreCurrenciesTitle);

  setText("historySubtitle", text.historySubtitle);
  setText("historyTitle", text.historyTitle);
  setPlaceholder("historySearchInput", text.historySearchInput);
  setText("lastRequestsTitle", text.lastRequestsTitle);
  setText("clearHistoryBtn", text.clearHistoryBtn);
  setText("favoritesTitle", text.favoritesTitle);
  setText("openFavoriteFormBtn", text.openFavoriteFormBtn);
  setText("addFavoriteBtn", text.addFavoriteBtn);

  setText("alertsSubtitle", text.alertsSubtitle);
  setText("alertsTitle", text.alertsTitle);
  setText("activeAlertText", text.activeAlertText);
  setText("pausedAlertText", text.pausedAlertText);
  setText("alertConditionOne", text.alertConditionOne);
  setText("alertConditionTwo", text.alertConditionTwo);
  setText("currentRateTextOne", text.currentRateTextOne);
  setText("currentRateTextTwo", text.currentRateTextTwo);
  setText("emptyAlertText", text.emptyAlertText);

  setText("settingsTitle", text.settingsTitle);
  setText("settingsSubtitle", text.settingsSubtitle);
  setText("generalTitle", text.generalTitle);
  setText("languageTitle", text.languageTitle);
  setText("languageDesc", text.languageDesc);
  setText("homeCurrencyTitle", text.homeCurrencyTitle);
  setText("homeCurrencyDesc", text.homeCurrencyDesc);
  setText("appearanceTitle", text.appearanceTitle);
  setText("themeTitle", text.themeTitle);
  setText("themeDesc", text.themeDesc);
  setText("fontSizeTitle", text.fontSizeTitle);
  setText("fontSizeDesc", text.fontSizeDesc);
  setText("dataTitle", text.dataTitle);
  setText("offlineTitle", text.offlineTitle);
  setText("offlineDesc", text.offlineDesc);
  setText("cacheTitle", text.cacheTitle);
  setText("cacheDesc", text.cacheDesc);

  setText("navConverter", text.navConverter);
  setText("navHistory", text.navHistory);
  setText("navAlerts", text.navAlerts);
  setText("navSettings", text.navSettings);

  updateConverter();
}

if (languageSelect) {
  languageSelect.addEventListener("change", () => {
    changeLanguage(languageSelect.value);
  });
}

async function loadRates() {
  try {
    const response = await fetch("http://localhost:3000/rates");
    const data = await response.json();

    eurRates = {};

    for (const key in data) {
      eurRates[key.toUpperCase()] = data[key];
    }

    updateConverter();

  } catch (error) {
    console.error("Fehler beim Laden der Kurse:", error);
  }
}

loadRates();