// Voltavia Admin Paneli — Firestore bağlanana kadar boş iskelet. Sahte kayıt yok.

const stations = [];
const operators = [];
const companies = [];
const auditLogs = [];

const statusLabel = { available: 'Müsait', busy: 'Dolu', maintenance: 'Bakımda' };

function badge(status) {
  return `<span class="badge badge-${status}"><span class="badge-dot"></span>${statusLabel[status]}</span>`;
}

function emptyRow(cols, text) {
  return `<tr><td colspan="${cols}">${text}</td></tr>`;
}

function renderStations() {
  if (stations.length === 0) {
    const empty = emptyRow(6, 'Kayıt yok.');
    document.getElementById('stationRows').innerHTML = empty;
    document.getElementById('dashboardStationRows').innerHTML = emptyRow(4, 'Kayıt yok.');
    return;
  }
  document.getElementById('stationRows').innerHTML = stations.map(s => `
    <tr>
      <td>${s.name}</td>
      <td>${s.district}, ${s.city}</td>
      <td>${s.operator}</td>
      <td>${s.power}</td>
      <td>${badge(s.status)}</td>
      <td><button class="btn btn-secondary" style="padding:6px 12px;font-size:12px">Düzenle</button></td>
    </tr>`).join('');

  document.getElementById('dashboardStationRows').innerHTML = stations.slice(0, 4).map(s => `
    <tr>
      <td>${s.name}</td>
      <td>${s.city}</td>
      <td>${s.operator}</td>
      <td>${badge(s.status)}</td>
    </tr>`).join('');
}

function renderOperators() {
  if (operators.length === 0) {
    document.getElementById('operatorRows').innerHTML = emptyRow(4, 'Kayıt yok.');
    return;
  }
  document.getElementById('operatorRows').innerHTML = operators.map(o => `
    <tr>
      <td>${o.name}</td>
      <td>${o.count}</td>
      <td>${o.integration ? '✅ Var' : '— Yok'}</td>
      <td>${o.status}</td>
    </tr>`).join('');
}

function renderCompanies() {
  if (companies.length === 0) {
    document.getElementById('companyRows').innerHTML = emptyRow(5, 'Kayıt yok.');
    return;
  }
  document.getElementById('companyRows').innerHTML = companies.map(c => `
    <tr>
      <td>${c.name}</td>
      <td>${c.plan}</td>
      <td>${c.fee}</td>
      <td>${c.renewal}</td>
      <td>${c.status}</td>
    </tr>`).join('');
}

function renderAudit() {
  if (auditLogs.length === 0) {
    document.getElementById('auditRows').innerHTML = emptyRow(3, 'Kayıt yok.');
    return;
  }
  document.getElementById('auditRows').innerHTML = auditLogs.map(a => `
    <tr>
      <td>${a.time}</td>
      <td>${a.user}</td>
      <td>${a.action}</td>
    </tr>`).join('');
}

function login() {
  const note = document.querySelector('#loginScreen .hint');
  if (note) note.textContent = 'Firebase projesi bağlı değil. Giriş açılmadı.';


function logout() {
  document.getElementById('dashboard').style.display = 'none';
  document.getElementById('loginScreen').style.display = 'flex';
}

function showView(el) {
  document.querySelectorAll('.nav-item[data-view]').forEach(n => n.classList.remove('active'));
  document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
  el.classList.add('active');
  document.getElementById(el.dataset.view).classList.add('active');
}

function toggleStationForm() {
  const form = document.getElementById('stationForm');
  form.style.display = form.style.display === 'none' ? 'block' : 'none';
}

renderStations();
renderOperators();
renderCompanies();
renderAudit();
