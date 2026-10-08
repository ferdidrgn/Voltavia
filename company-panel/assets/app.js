// Voltavia Firma Paneli — yerel Faz 2 demosu. Arka uç yok.

const STORAGE = {
  stations: 'voltavia-firma-istasyonlar',
  license: 'voltavia-firma-lisans',
  pilot: 'voltavia-firma-pilot',
  ocpi: 'voltavia-firma-ocpi',
};

const OCPI_STEPS = [
  ['ticari', 'Ticari lisans', 'Aylık lisans ve KVKK. Voltavia şarj bedelini tahsil etmez.'],
  ['credentials', 'OCPI kimlik değişimi', 'Versions ve Credentials. Anahtar panele yazılmaz.'],
  ['locations', 'İstasyon ve EVSE', 'Location kimliği ve EVSE uid.'],
  ['tariffs', 'Tarife', 'Birim fiyat operatörden gelir.'],
  ['tokens', 'Kullanıcı jetonu', 'APP_USER jetonu.'],
  ['commands', 'Başlat ve durdur', 'StartSession ve StopSession.'],
  ['payment', 'Operatör tahsilatı', 'Kart operatörün ödeme kuruluşunda kalır.'],
];

const PILOT_FLAG = 'pilot isteniyor';

const LICENSE_STATES = ['Taslak', 'Görüşmede', 'Aktif'];

const LICENSE_DETAIL = {
  Taslak: 'Henüz yürürlükte değil. Sözleşme taslak aşamasında.',
  Görüşmede: 'Operatörle görüşme sürüyor. Lisans yürürlükte değil.',
  Aktif: 'Yerel demo işareti. Gerçek sözleşme, fatura veya yenileme tarihi yoktur.',
};

const memory = {};
let editingId = null;

function storageGet(key) {
  try {
    return localStorage.getItem(key);
  } catch (err) {
    return Object.prototype.hasOwnProperty.call(memory, key) ? memory[key] : null;
  }
}

function storageSet(key, value) {
  memory[key] = value;
  try {
    localStorage.setItem(key, value);
  } catch (err) {
    /* gizli pencerede bellek yedeği yeter */
  }
}

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function loadLicense() {
  const stored = storageGet(STORAGE.license);
  return LICENSE_STATES.includes(stored) ? stored : 'Taslak';
}

function saveLicense(state) {
  if (!LICENSE_STATES.includes(state)) return;
  storageSet(STORAGE.license, state);
  renderLicense();
  updateOverview();
}

function pilotRequested() {
  return storageGet(STORAGE.pilot) === PILOT_FLAG;
}

function loadOcpi() {
  const raw = storageGet(STORAGE.ocpi);
  if (!raw) return [];
  try {
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed.map(String) : [];
  } catch (err) {
    return [];
  }
}

function renderOcpi() {
  const host = document.getElementById('ocpiSteps');
  if (!host) return;
  const done = new Set(loadOcpi());
  host.innerHTML = OCPI_STEPS.map(([id, title, body]) => {
    const checked = done.has(id) ? 'checked' : '';
    return `<label class="ocpi-step"><input type="checkbox" data-ocpi="${escapeHtml(id)}" ${checked} /> <span><strong>${escapeHtml(title)}</strong><br />${escapeHtml(body)}</span></label>`;
  }).join('');
}

function toggleOcpi(id) {
  const done = new Set(loadOcpi());
  if (done.has(id)) done.delete(id);
  else done.add(id);
  storageSet(STORAGE.ocpi, JSON.stringify([...done]));
  renderOcpi();
}

function requestPilot() {
  storageSet(STORAGE.pilot, PILOT_FLAG);
  renderPilot();
  updateOverview();
}

function normalizeStation(raw, index) {
  const source = raw && typeof raw === 'object' ? raw : {};
  const sockets = Number(source.sockets);
  const marked = source.marked === true && source.status === 'musait';
  return {
    id: String(source.id || `s${index + 1}`),
    name: String(source.name || 'Adsız istasyon').slice(0, 80),
    city: String(source.city || '—'),
    district: String(source.district || '—'),
    sockets: Number.isInteger(sockets) && sockets >= 0 ? sockets : 0,
    status: marked ? 'musait' : 'kayit',
    marked,
  };
}

function loadStations() {
  const raw = storageGet(STORAGE.stations);
  if (!raw) return [];
  try {
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    return parsed.map(normalizeStation);
  } catch (err) {
    return [];
  }
}

function saveStations(list) {
  storageSet(STORAGE.stations, JSON.stringify(list));
}

function statusBadge(station) {
  if (station.marked === true && station.status === 'musait') {
    return '<span class="badge badge-available"><span class="badge-dot"></span>Müsait</span>';
  }
  return '<span class="badge badge-kayit"><span class="badge-dot"></span>Kayıt</span>';
}

function setStationNotice(message, isError) {
  const el = document.getElementById('stationNotice');
  if (!el) return;
  el.textContent = message || '';
  el.classList.toggle('is-error', Boolean(isError));
}

function renderStations() {
  const el = document.getElementById('stationRows');
  if (!el) return;
  const stations = loadStations();
  if (stations.length === 0) {
    el.innerHTML = '<tr><td colspan="6">Kayıt yok. İstasyonu sen eklersin.</td></tr>';
    return;
  }
  el.innerHTML = stations.map((station) => {
    const id = escapeHtml(station.id);
    const place = `${escapeHtml(station.district)}, ${escapeHtml(station.city)}`;
    if (station.id === editingId) {
      return `
        <tr data-id="${id}">
          <td><input class="cell-input" data-field="name" value="${escapeHtml(station.name)}" maxlength="80" /></td>
          <td>${place}</td>
          <td><input class="cell-input cell-narrow" data-field="sockets" type="number" min="0" step="1" value="${station.sockets}" /></td>
          <td>${statusBadge(station)}</td>
          <td>Fiyat yok</td>
          <td>
            <div class="row-actions">
              <button type="button" class="btn btn-primary btn-sm" data-action="save" data-id="${id}">Kaydet</button>
              <button type="button" class="btn btn-secondary btn-sm" data-action="cancel">Vazgeç</button>
            </div>
          </td>
        </tr>`;
    }
    return `
      <tr data-id="${id}">
        <td>${escapeHtml(station.name)}</td>
        <td>${place}</td>
        <td>${station.sockets} adet</td>
        <td>${statusBadge(station)}</td>
        <td>Fiyat yok</td>
        <td><button type="button" class="btn btn-secondary btn-sm" data-action="edit" data-id="${id}">Düzenle</button></td>
      </tr>`;
  }).join('');

  if (editingId) {
    const input = el.querySelector('input[data-field="name"]');
    if (input) input.focus();
  }
}

function startEdit(id) {
  editingId = id;
  setStationNotice('');
  renderStations();
}

function cancelEdit() {
  editingId = null;
  setStationNotice('');
  renderStations();
}

function saveEdit(id, row) {
  if (!row) return;
  const name = row.querySelector('[data-field="name"]').value.trim();
  const socketsRaw = row.querySelector('[data-field="sockets"]').value.trim();
  if (!name) {
    setStationNotice('İstasyon adı gerekli.', true);
    return;
  }
  if (!/^\d+$/.test(socketsRaw)) {
    setStationNotice('Soket sayısı sıfır veya pozitif bir tam sayı olmalı.', true);
    return;
  }

  const stations = loadStations();
  const index = stations.findIndex((station) => station.id === id);
  if (index === -1) return;
  stations[index] = {
    ...stations[index],
    name: name.slice(0, 80),
    sockets: Number(socketsRaw),
  };
  saveStations(stations);
  editingId = null;
  setStationNotice('Ad ve soket sayısı bu tarayıcıya kaydedildi.');
  renderStations();
  updateOverview();
}

function renderLicense() {
  const state = loadLicense();
  document.querySelectorAll('#licenseChoices .choice').forEach((button) => {
    button.classList.toggle('active', button.dataset.license === state);
  });
  const detail = document.getElementById('licenseDetail');
  if (detail) detail.textContent = LICENSE_DETAIL[state];
}

function renderPilot() {
  const button = document.getElementById('pilotBtn');
  const note = document.getElementById('pilotNote');
  if (!button || !note) return;
  if (pilotRequested()) {
    button.textContent = 'Pilot isteniyor';
    button.disabled = true;
    note.textContent = 'İşaret bu tarayıcıda saklandı. API bağlı değil.';
  } else {
    button.textContent = 'Pilot istiyorum';
    button.disabled = false;
    note.textContent = '';
  }
}

function updateOverview() {
  const stations = loadStations();
  const sockets = stations.reduce((sum, station) => sum + station.sockets, 0);
  const license = loadLicense();
  const stationEl = document.getElementById('statStations');
  const socketEl = document.getElementById('statSockets');
  const licenseEl = document.getElementById('statLicense');
  const licenseNote = document.getElementById('statLicenseNote');
  const integrationNote = document.getElementById('statIntegrationNote');
  if (stationEl) stationEl.textContent = String(stations.length);
  if (socketEl) socketEl.textContent = `${sockets} soket · yerel liste`;
  if (licenseEl) licenseEl.textContent = license;
  if (licenseNote) licenseNote.textContent = LICENSE_DETAIL[license];
  if (integrationNote) {
    integrationNote.textContent = pilotRequested()
      ? 'Pilot isteniyor · API bağlı değil'
      : 'Canlı doluluk ve fiyat yok';
  }
  const integrationEl = document.getElementById('statIntegration');
  if (integrationEl) integrationEl.textContent = 'Bağlı değil';
}

function login() {
  const email = document.getElementById('email').value.trim();
  const error = document.getElementById('loginError');
  if (!email) {
    error.hidden = false;
    error.textContent = 'Devam etmek için bir e-posta yazın.';
    return;
  }
  error.hidden = true;
  error.textContent = '';
  document.getElementById('loginScreen').style.display = 'none';
  document.getElementById('dashboard').style.display = 'flex';
  updateOverview();
}

function logout() {
  document.getElementById('dashboard').style.display = 'none';
  document.getElementById('loginScreen').style.display = 'flex';
}

function showView(el) {
  document.querySelectorAll('.nav-item[data-view]').forEach((item) => item.classList.remove('active'));
  document.querySelectorAll('.view').forEach((view) => view.classList.remove('active'));
  el.classList.add('active');
  document.getElementById(el.dataset.view).classList.add('active');
  updateOverview();
}

function onStationClick(event) {
  const button = event.target.closest('button');
  if (!button) return;
  const action = button.dataset.action;
  const id = button.dataset.id;
  if (action === 'edit') startEdit(id);
  if (action === 'cancel') cancelEdit();
  if (action === 'save') saveEdit(id, button.closest('tr'));
}

document.getElementById('stationRows').addEventListener('click', onStationClick);
document.getElementById('licenseChoices').addEventListener('click', (event) => {
  const button = event.target.closest('[data-license]');
  if (!button) return;
  saveLicense(button.dataset.license);
});
document.getElementById('pilotBtn').addEventListener('click', requestPilot);
document.getElementById('ocpiSteps').addEventListener('change', (event) => {
  const input = event.target.closest('[data-ocpi]');
  if (!input) return;
  toggleOcpi(input.dataset.ocpi);
});
document.getElementById('email').addEventListener('input', () => {
  const error = document.getElementById('loginError');
  error.hidden = true;
  error.textContent = '';
});

renderStations();
renderLicense();
renderPilot();
renderOcpi();
updateOverview();
