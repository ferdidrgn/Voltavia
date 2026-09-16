// Voltavia Admin Paneli — mock veriyle çalışan arayüz iskeleti.
// Gerçek sürümde bu veriler Firestore + backend API'den (Cloudflare Workers) gelecektir.

const stations = [
  { name: 'Zorlu Center Şarj Noktası', city: 'İstanbul', district: 'Beşiktaş', operator: 'VoltCharge', power: '150 kW', status: 'available' },
  { name: 'İstinye Park Otopark', city: 'İstanbul', district: 'Sarıyer', operator: 'Şimşek Enerji', power: '120 kW', status: 'busy' },
  { name: 'Akbatı AVM Şarj İstasyonu', city: 'İstanbul', district: 'Esenyurt', operator: 'AkımNet', power: '22 kW', status: 'available' },
  { name: 'Kadıköy Sahil Otoparkı', city: 'İstanbul', district: 'Kadıköy', operator: 'VoltCharge', power: '180 kW', status: 'maintenance' },
  { name: 'Kızılay Meydan Şarj Üniteleri', city: 'Ankara', district: 'Çankaya', operator: 'ElektraPark', power: '90 kW', status: 'available' },
];

const operators = [
  { name: 'VoltCharge', count: 412, integration: true, status: 'Aktif' },
  { name: 'Şimşek Enerji', count: 268, integration: true, status: 'Aktif' },
  { name: 'AkımNet', count: 190, integration: false, status: 'Görüşme Aşamasında' },
  { name: 'ElektraPark', count: 378, integration: false, status: 'Aktif' },
];

const companies = [
  { name: 'VoltCharge A.Ş.', plan: 'Kurumsal', fee: '38.000 ₺ / ay', renewal: '12 Mar 2027', status: 'Aktif' },
  { name: 'Şimşek Enerji Ltd.', plan: 'Standart', fee: '24.000 ₺ / ay', renewal: '05 Kas 2026', status: 'Aktif' },
  { name: 'AkımNet', plan: 'Deneme', fee: '—', renewal: '—', status: 'Görüşme' },
];

const auditLogs = [
  { time: '13 Ağu 2026 · 14:22', user: 'admin@voltavia.app', action: 'Kadıköy Sahil Otoparkı istasyonu pasife alındı' },
  { time: '12 Ağu 2026 · 09:10', user: 'admin@voltavia.app', action: 'Yeni istasyon eklendi: Kızılay Meydan Şarj Üniteleri' },
  { time: '10 Ağu 2026 · 18:47', user: 'ops@voltcharge.com', action: 'VoltCharge lisans paketi Kurumsal olarak güncellendi' },
];

const statusLabel = { available: 'Müsait', busy: 'Dolu', maintenance: 'Bakımda' };

function badge(status) {
  return `<span class="badge badge-${status}"><span class="badge-dot"></span>${statusLabel[status]}</span>`;
}

function renderStations() {
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
  document.getElementById('operatorRows').innerHTML = operators.map(o => `
    <tr>
      <td>${o.name}</td>
      <td>${o.count}</td>
      <td>${o.integration ? '✅ Var' : '— Yok'}</td>
      <td>${o.status}</td>
    </tr>`).join('');
}

function renderCompanies() {
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
  document.getElementById('auditRows').innerHTML = auditLogs.map(a => `
    <tr>
      <td>${a.time}</td>
      <td>${a.user}</td>
      <td>${a.action}</td>
    </tr>`).join('');
}

function login() {
  document.getElementById('loginScreen').style.display = 'none';
  document.getElementById('dashboard').style.display = 'flex';
}

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
