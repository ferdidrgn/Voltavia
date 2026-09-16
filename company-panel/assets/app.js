// Voltavia Firma Paneli — mock veriyle çalışan arayüz iskeleti.

const stations = [
  { name: 'Zorlu Center Şarj Noktası', city: 'İstanbul', district: 'Beşiktaş', sockets: 6, status: 'available' },
  { name: 'Kadıköy Sahil Otoparkı', city: 'İstanbul', district: 'Kadıköy', sockets: 2, status: 'maintenance' },
  { name: 'Bostancı Sahil Yolu', city: 'İstanbul', district: 'Kadıköy', sockets: 4, status: 'busy' },
  { name: 'Ataşehir Finans Merkezi', city: 'İstanbul', district: 'Ataşehir', sockets: 8, status: 'available' },
];

const statusLabel = { available: 'Müsait', busy: 'Dolu', maintenance: 'Bakımda' };

function badge(status) {
  return `<span class="badge badge-${status}"><span class="badge-dot"></span>${statusLabel[status]}</span>`;
}

function renderStations() {
  const el = document.getElementById('stationRows');
  if (!el) return;
  el.innerHTML = stations.map(s => `
    <tr>
      <td>${s.name}</td>
      <td>${s.district}, ${s.city}</td>
      <td>${s.sockets} adet</td>
      <td>${badge(s.status)}</td>
      <td><button class="btn btn-secondary" style="padding:6px 12px;font-size:12px">Düzenle</button></td>
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

renderStations();
