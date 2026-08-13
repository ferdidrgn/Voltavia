/**
 * Voltavia API — Cloudflare Workers iskeleti.
 *
 * Faz 1 kapsamı (bkz. ROADMAP.md § 2.4):
 *  - GET /version      → istasyon veri paketinin güncel sürüm bilgisi (küçük JSON, CDN'den dağıtılır)
 *  - GET /stations      → istasyon listesi (ilk kullanımda indirilen tam paket)
 *  - GET /health        → servis sağlık kontrolü
 *
 * Gerçek veri Firestore'a taşındığında bu handler'lar ilgili sorgularla değiştirilecektir.
 */

export interface Env {
  // FIRESTORE_PROJECT_ID: string;
  // MEDIA: R2Bucket;
}

const mockVersion = { version: 128, updatedAt: '2026-08-10T12:00:00Z' };

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { 'content-type': 'application/json; charset=utf-8' },
  });
}

export default {
  async fetch(request: Request, _env: Env): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname === '/health') {
      return json({ status: 'ok' });
    }

    if (url.pathname === '/version') {
      return json(mockVersion);
    }

    if (url.pathname === '/stations') {
      return json({ version: mockVersion.version, stations: [] });
    }

    return json({ error: 'Not found' }, 404);
  },
};
